# Drawer Insert Box - 3D Printing Guide

This project contains an OpenSCAD model for a stackable, 3D-printable drawer organizer.

## Model Description
- **Dimensions**: 70mm (W) x 105mm (D) x 95mm (H)
- **Wall Thickness**: 2mm
- **Stacking**: Vertical stacking with a self-centering chamfered rim.
- **Printability**: 
    - Designed with 45° chamfers on all bottom and top edges (both inner and outer) to allow printing without supports.
    - Inner bottom chamfer reinforces the floor-to-wall connection.

## Visualization
To aid in development and inspection of the internal geometry:
- **Transparency**: Components are set to 50% transparency.
- **Color Coding**: Different parts (outer base, walls, inner base, void, rim) are assigned distinct, light colors (DeepSkyBlue, MediumSeaGreen, HotPink, Gold, Orchid) to distinguish features and ensure correct geometry generation.
- **Customization**: Visual settings are defined as variables at the top of `models/box.scad`.

## Files
- `models/box.scad`: The parametric OpenSCAD source file.
- `scripts/export_stl.ps1`: PowerShell script to automatically export the STL.

## How to Export for 3D Printing

### Automated Export (Recommended)
Run the included PowerShell script to generate the STL file in the `build/` directory:
```powershell
.\scripts\export_stl.ps1
```

### Manual Export
1. Install [OpenSCAD](https://openscad.org/).
2. Open `models/box.scad`.
3. Press **F6** to render the geometry.
4. Press **F7** to export as an **STL** file.

## Printing Instructions (Creality Ender 3)
| Setting | Recommended Value |
| :--- | :--- |
| **Material** | PLA |
| **Layer Height** | 0.2mm or 0.28mm |
| **Supports** | **None** (Disabled) |
| **Infill** | 15% (Grid or Gyroid) |
| **Wall Count** | 3 (approx. 1.2mm total wall thickness) |
| **Adhesion** | Skirt (Brim only if you have warping issues) |

The 45-degree angles ensure that the overhanging parts of the stacking rim and the bottom taper print cleanly on an Ender 3 without needing sacrificial support structures.