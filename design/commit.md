Add configurable dividers and update box width

- Introduce `divider_count` and `divider_thickness` parameters to `models/box.scad`.
- Add `dividers` module to generate dividers along the shorter dimension.
- Update box width from 70mm to 80mm.
- Update `scripts/export_stl.ps1` with new output filename.
- Update `GEMINI.md` to document the new parameters.