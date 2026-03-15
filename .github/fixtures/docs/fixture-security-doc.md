---
title: "Fixture Security Document"
date: "March 15, 2026"
version: "0.0.0-fixture"
---

## Overview

This fixture validates the shared docs-generation workflow from Markdown through DOCX, PDF, and EPUB.

## Commands

```bash
wp core verify-checksums
```

## Table

| Check | Expected |
|---|---|
| Workflow linting | Pass |
| DOCX generation | Pass |
| PDF and EPUB generation | Pass |
