// Drawer Insert Box
// Optimized for support-free 3D printing and vertical stacking

// --- Parameters ---
width = 80;
depth = 105;
height = 95;
wall_thickness = 2;
corner_radius = 4;
divider_count = 2; // Number of equal dividers along the shorter side
divider_thickness = 1;

// Visual Settings
transparency = 0.5;
color_outer_base = "DeepSkyBlue"; // Lighter than RoyalBlue
color_outer_walls = "MediumSeaGreen"; // Lighter than SeaGreen
color_inner_base = "HotPink"; // Lighter/Brighter than Tomato
color_inner_void = "Gold"; // Lighter than Goldenrod
color_inner_rim = "Orchid"; // Lighter than MediumPurple

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
    union() {
        color(color_outer_base, transparency)
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
        color(color_outer_walls, transparency)
        translate([0, 0, chamfer_size])
        linear_extrude(height - chamfer_size)
            rounded_rect_profile(width, depth, corner_radius);
    }
}

module box_inner_cutout() {
    inner_w = width - 2 * wall_thickness;
    inner_d = depth - 2 * wall_thickness;
    inner_r = max(0.1, corner_radius - wall_thickness);
    
    // Calculate how much the outer chamfer "eats" into the wall thickness zone
    // and create a matching inner chamfer to maintain constant wall thickness.
    inner_chamfer_height = max(0, chamfer_size - wall_thickness);

    translate([wall_thickness, wall_thickness, wall_thickness]) {
        union() {
            // 1. Bottom Inner Chamfer (Structural reinforcement)
            if (inner_chamfer_height > 0) {
                color(color_inner_base, transparency)
                hull() {
                    // Bottom of the void (narrower to match outer slope)
                    linear_extrude(0.1)
                        offset(delta = -inner_chamfer_height)
                        rounded_rect_profile(inner_w, inner_d, inner_r);
                    
                    // Transition to full inner width
                    translate([0, 0, inner_chamfer_height])
                    linear_extrude(0.1)
                        rounded_rect_profile(inner_w, inner_d, inner_r);
                }
            }

            // 2. Main hollow volume
            color(color_inner_void, transparency)
            translate([0, 0, inner_chamfer_height])
            linear_extrude(height)
                rounded_rect_profile(inner_w, inner_d, inner_r);
                
            // 3. Top stacking rim (inverted chamfer)
            color(color_inner_rim, transparency)
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
}

module dividers() {
    if (divider_count > 0) {
        inner_w = width - 2 * wall_thickness;
        inner_d = depth - 2 * wall_thickness;
        
        // Determine which side is shorter to place dividers correctly
        is_width_shorter = width <= depth;
        
        long_dim = is_width_shorter ? inner_d : inner_w;
        
        // Calculate section length (s) between dividers
        s = (long_dim - divider_count * divider_thickness) / (divider_count + 1);
        
        // Height to reach the inner lip (where the stacking chamfer starts)
        divider_height = height - wall_thickness - chamfer_size;
        
        for (i = [1 : divider_count]) {
            // Position along the long dimension
            pos = i * s + (i - 1) * divider_thickness;
            
            translate_x = is_width_shorter ? wall_thickness : wall_thickness + pos;
            translate_y = is_width_shorter ? wall_thickness + pos : wall_thickness;
            
            div_w = is_width_shorter ? inner_w : divider_thickness;
            div_d = is_width_shorter ? divider_thickness : inner_d;
            
            color(color_outer_walls, transparency)
            translate([translate_x, translate_y, wall_thickness])
            cube([div_w, div_d, divider_height]);
        }
    }
}

// --- Final Assembly ---
union() {
    difference() {
        box_outer_shape();
        box_inner_cutout();
    }
    dividers();
}
