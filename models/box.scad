// Drawer Insert Box
// Optimized for support-free 3D printing and vertical stacking

// --- Parameters ---
width = 70;
depth = 105;
height = 95;
wall_thickness = 2;
corner_radius = 4;

// Chamfer settings for stacking and printability
// A 45-degree chamfer allows printing without supports.
chamfer_size = 4; 
stacking_clearance = 0.4; // Clearance between stacked boxes

// Precision
$fn = 64;

// --- Modules ---

module rounded_rect_profile(w, d, r) {
    translate([r, r, 0])
    minkowski() {
        square([w - 2*r, d - 2*r]);
        circle(r);
    }
}

module box_outer_shape() {
    hull() {
        // Bottom footprint (shrunken for chamfer)
        linear_extrude(0.1)
            offset(delta = -chamfer_size)
            rounded_rect_profile(width, depth, corner_radius);
        
        // Start of main walls
        translate([0, 0, chamfer_size])
        linear_extrude(0.1)
            rounded_rect_profile(width, depth, corner_radius);
    }
    
    // Main vertical walls
    translate([0, 0, chamfer_size])
    linear_extrude(height - chamfer_size)
        rounded_rect_profile(width, depth, corner_radius);
}

module box_inner_cutout() {
    inner_w = width - 2 * wall_thickness;
    inner_d = depth - 2 * wall_thickness;
    inner_r = max(0.1, corner_radius - wall_thickness);
    
    translate([wall_thickness, wall_thickness, wall_thickness]) {
        // Main hollow volume
        linear_extrude(height)
            rounded_rect_profile(inner_w, inner_d, inner_r);
            
        // Top stacking rim (inverted chamfer)
        translate([0, 0, height - wall_thickness - chamfer_size])
        hull() {
            linear_extrude(0.1)
                rounded_rect_profile(inner_w, inner_d, inner_r);
                
            translate([0, 0, chamfer_size + 0.1])
            linear_extrude(0.1)
                offset(delta = chamfer_size + stacking_clearance)
                rounded_rect_profile(inner_w, inner_d, inner_r);
        }
    }
}

// --- Final Assembly ---
difference() {
    box_outer_shape();
    box_inner_cutout();
}
