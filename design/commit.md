feat(model): add transparency and color coding for geometry inspection

- Introduced variable constants for transparency and component colors in `models/box.scad`.
- Applied color-coding to distinct model parts (base, walls, inner cutout sections).
- Wrapped components in `union()` to ensure correct alpha rendering in OpenSCAD.
- Updated `GEMINI.md` with a new Visualization section documenting these changes.
