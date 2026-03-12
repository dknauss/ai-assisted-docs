#!/usr/bin/env python3

from __future__ import annotations

import argparse
import io
import re
import sys
import zipfile
from pathlib import Path
import xml.etree.ElementTree as ET


W_NS = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
R_NS = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
PKG_REL_NS = "http://schemas.openxmlformats.org/package/2006/relationships"
CONTENT_TYPES_NS = "http://schemas.openxmlformats.org/package/2006/content-types"

ET.register_namespace("w", W_NS)
ET.register_namespace("r", R_NS)


def qname(ns: str, tag: str) -> str:
    return f"{{{ns}}}{tag}"


def parse_xml(raw: bytes) -> ET.ElementTree:
    return ET.ElementTree(ET.fromstring(raw))


def to_xml_bytes(tree: ET.ElementTree) -> bytes:
    buf = io.BytesIO()
    tree.write(buf, encoding="utf-8", xml_declaration=True)
    return buf.getvalue()


def next_rel_id(rel_root: ET.Element) -> str:
    max_num = 0
    for rel in rel_root.findall(qname(PKG_REL_NS, "Relationship")):
        rel_id = rel.attrib.get("Id", "")
        match = re.fullmatch(r"rId(\d+)", rel_id)
        if match:
            max_num = max(max_num, int(match.group(1)))
    return f"rId{max_num + 1}"


def ensure_footer_content_type(content_types_root: ET.Element, footer_name: str) -> None:
    part_name = f"/word/{footer_name}"
    for override in content_types_root.findall(qname(CONTENT_TYPES_NS, "Override")):
        if override.attrib.get("PartName") == part_name:
            return
    ET.SubElement(
        content_types_root,
        qname(CONTENT_TYPES_NS, "Override"),
        {
            "PartName": part_name,
            "ContentType": "application/vnd.openxmlformats-officedocument.wordprocessingml.footer+xml",
        },
    )


def build_footer_xml() -> bytes:
    root = ET.Element(qname(W_NS, "ftr"))
    paragraph = ET.SubElement(root, qname(W_NS, "p"))
    p_pr = ET.SubElement(paragraph, qname(W_NS, "pPr"))
    ET.SubElement(p_pr, qname(W_NS, "pStyle"), {qname(W_NS, "val"): "Footer"})
    ET.SubElement(p_pr, qname(W_NS, "jc"), {qname(W_NS, "val"): "center"})

    ET.SubElement(ET.SubElement(paragraph, qname(W_NS, "r")), qname(W_NS, "fldChar"), {qname(W_NS, "fldCharType"): "begin"})
    instr_run = ET.SubElement(paragraph, qname(W_NS, "r"))
    instr_text = ET.SubElement(
        instr_run,
        qname(W_NS, "instrText"),
        {"{http://www.w3.org/XML/1998/namespace}space": "preserve"},
    )
    instr_text.text = " PAGE "
    ET.SubElement(ET.SubElement(paragraph, qname(W_NS, "r")), qname(W_NS, "fldChar"), {qname(W_NS, "fldCharType"): "separate"})
    text_run = ET.SubElement(paragraph, qname(W_NS, "r"))
    text_value = ET.SubElement(text_run, qname(W_NS, "t"))
    text_value.text = "1"
    ET.SubElement(ET.SubElement(paragraph, qname(W_NS, "r")), qname(W_NS, "fldChar"), {qname(W_NS, "fldCharType"): "end"})

    return to_xml_bytes(ET.ElementTree(root))


def patch_docx(docx_path: Path) -> bool:
    original = docx_path.read_bytes()
    zin = zipfile.ZipFile(io.BytesIO(original), "r")
    files = {name: zin.read(name) for name in zin.namelist()}
    zin.close()

    document_tree = parse_xml(files["word/document.xml"])
    rels_tree = parse_xml(files["word/_rels/document.xml.rels"])
    content_types_tree = parse_xml(files["[Content_Types].xml"])

    document_root = document_tree.getroot()
    body = document_root.find(qname(W_NS, "body"))
    if body is None:
        raise RuntimeError(f"{docx_path}: missing word body")

    sect_pr = body.find(qname(W_NS, "sectPr"))
    if sect_pr is None:
        raise RuntimeError(f"{docx_path}: missing section properties")

    rels_root = rels_tree.getroot()
    footer_target = None
    footer_rel = None
    for rel in rels_root.findall(qname(PKG_REL_NS, "Relationship")):
        if rel.attrib.get("Type") == "http://schemas.openxmlformats.org/officeDocument/2006/relationships/footer":
            footer_rel = rel
            footer_target = rel.attrib["Target"]
            break

    if footer_rel is None:
        footer_name = "footer1.xml"
        footer_rel_id = next_rel_id(rels_root)
        footer_rel = ET.SubElement(
            rels_root,
            qname(PKG_REL_NS, "Relationship"),
            {
                "Type": "http://schemas.openxmlformats.org/officeDocument/2006/relationships/footer",
                "Id": footer_rel_id,
                "Target": footer_name,
            },
        )
        footer_target = footer_name
    else:
        footer_rel_id = footer_rel.attrib["Id"]
        footer_name = footer_target

    existing_ref = None
    for ref in sect_pr.findall(qname(W_NS, "footerReference")):
        if ref.attrib.get(qname(W_NS, "type")) == "default":
            existing_ref = ref
            break

    if existing_ref is None:
        footnote_pr = sect_pr.find(qname(W_NS, "footnotePr"))
        ref_el = ET.Element(
            qname(W_NS, "footerReference"),
            {
                qname(W_NS, "type"): "default",
                qname(R_NS, "id"): footer_rel_id,
            },
        )
        insert_at = list(sect_pr).index(footnote_pr) if footnote_pr is not None else len(list(sect_pr))
        sect_pr.insert(insert_at, ref_el)
    else:
        existing_ref.attrib[qname(R_NS, "id")] = footer_rel_id

    files[f"word/{footer_name}"] = build_footer_xml()
    files["word/document.xml"] = to_xml_bytes(document_tree)
    files["word/_rels/document.xml.rels"] = to_xml_bytes(rels_tree)
    ensure_footer_content_type(content_types_tree.getroot(), footer_name)
    files["[Content_Types].xml"] = to_xml_bytes(content_types_tree)

    out = io.BytesIO()
    with zipfile.ZipFile(out, "w", compression=zipfile.ZIP_DEFLATED) as zout:
        for name in sorted(files):
            zout.writestr(name, files[name])

    updated = out.getvalue()
    changed = updated != original
    if changed:
        docx_path.write_bytes(updated)
    return changed


def main() -> int:
    parser = argparse.ArgumentParser(description="Add centered page numbering footer to a DOCX template.")
    parser.add_argument("docx", nargs="+", help="Path(s) to DOCX file(s)")
    args = parser.parse_args()

    changed_any = False
    for raw_path in args.docx:
        path = Path(raw_path)
        changed = patch_docx(path)
        status = "updated" if changed else "unchanged"
        print(f"{status}: {path}")
        changed_any = changed_any or changed

    return 0 if changed_any or args.docx else 1


if __name__ == "__main__":
    sys.exit(main())
