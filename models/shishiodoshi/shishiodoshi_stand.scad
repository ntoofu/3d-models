// ====================================================================
// Shishiodoshi (鹿威し) Stand - 3mm Interlocking Plate + 4mm Base Boss (v5)
// Designed for shishiodoshi.scad twin-spine mount (outer width 84mm, M4 pivot)
// - H-shaped base frame (3mm base + 1mm boss around slot holes = 4mm slot depth)
// - Side plates & cross-brace (3mm thick, 4mm bottom tabs)
// - Side plate v5: Compact base (116mm matching tab span),
//   3-step bearing slots (60/80mm: 45-deg J-slot, 100mm: vertical U-slot)
//   (Compatible with existing v3 base_frame & cross_brace)
// ====================================================================

$fn = 48;

// --- Parameters ---
plate_t          = 3.0;     // Board thickness (mm)
base_boss_h      = 1.0;     // Extra boss thickness around base slot holes (mm)
base_boss_pad    = 4.0;     // Boss margin around each base slot hole (mm)
base_slot_depth  = plate_t + base_boss_h; // 4.0 mm total base thickness at slots
fit_tol          = 0.15;    // Interlock clearance per side (mm) -> slot = 3.3mm
chamfer          = 0.6;     // Edge rounding/chamfer (mm)

// Cradle & Pivot geometry
cradle_outer_w   = 84.0;    // shishiodoshi.scad neck_center_z * 2
side_clearance   = 2.0;     // Clearance per side between cradle and stand wall
inner_w          = cradle_outer_w + side_clearance * 2; // 88.0 mm
wall_center_y    = (inner_w + plate_t) / 2;             // 45.5 mm

pivot_heights    = [60.0, 80.0, 100.0]; // 3-step M4 pivot heights above base top (mm)
pivot_h          = 100.0;   // Highest pivot height (mm)
bolt_d           = 4.0;     // M4 bolt shaft diameter
bolt_slot_w      = 4.6;     // J-slot width (4.0 + 0.6 clearance)
j_drop           = 2.5;     // Vertical drop at bottom of J-slot to prevent slip-out
top_margin       = 10.0;    // Material above highest bolt center
total_h          = pivot_h + top_margin; // 110.0 mm

// Side plate dimensions
side_base_len    = 116.0;   // Bottom length X (-58 to +58, 5mm shoulder outside tabs)
side_top_w       = 34.0;    // Top width X (-17 to +17)
side_foot_h      = 14.0;    // Vertical foot height at ends before tapering
frame_w          = 15.0;    // Truss frame border width
rib_half_w       = 8.0;     // Center vertical rib half-width (16mm total)

// Base frame dimensions ("H" frame: open front/rear, central crossbar at X=0)
base_len         = 150.0;   // X (-75 to +75)
base_wing        = 18.0;    // Outrigger beyond side plate outer face
base_w           = inner_w + 2 * plate_t + 2 * base_wing; // 130.0 mm (Y: -65 to +65)
base_side_rail_w = 32.0;    // Side rail width
base_cross_w     = 28.0;    // Center crossbar width along X (-14 to +14)

// Interlock tabs (tenons)
tab_len          = 30.0;    // Side plate bottom tab length
tab_x_offset     = 38.0;    // Side plate tab center X positions (-38, +38)

// Cross-brace (single piece spanning both side plates via vertical cross-slits)
brace_half_w     = base_w / 2 - 2.0; // 63.0 mm (Y: -63 to +63)
brace_h          = 34.0;    // Height at side plate intersection (Z=4 to Z=38, lowered 10mm from v3)
brace_mid_h      = 10.0;    // Reduced center height to guarantee bottle V-arch clearance
slit_h           = 22.0;    // Half-lap vertical slit height (side_plate: 0..22, brace: 22..34)

brace_in_tab_y   = 20.0;    // Inner base tab center Y (+/-20)
brace_in_tab_l   = 20.0;    // Inner base tab length
brace_out_tab_y  = 56.0;    // Outer base tab center Y (+/-56)
brace_out_tab_l  = 10.0;    // Outer base tab length

// Output mode: "side_plate", "base_frame", "cross_brace", "print_base_set", "assembled"
part = "assembled";

// --- 2D Profiles ---

module side_plate_2d() {
    slot_w = plate_t + 2 * fit_tol;

    difference() {
        union() {
            // Main trapezoidal body with rounded corners
            offset(r = 3) offset(delta = -3)
            polygon(points = [
                [-side_base_len / 2, 0],
                [ side_base_len / 2, 0],
                [ side_base_len / 2, side_foot_h],
                [ side_top_w / 2,    total_h],
                [-side_top_w / 2,    total_h],
                [-side_base_len / 2, side_foot_h]
            ]);

            // Bottom interlocking tabs (2x, matching base_slot_depth)
            for (sx = [-1, 1]) {
                translate([sx * tab_x_offset - tab_len / 2, -base_slot_depth])
                    square([tab_len, base_slot_depth + 1]);
            }
        }

        // 3-step bearing slots at X=0:
        // - Lower/Mid (60, 80mm): 45-deg J-slot from +X side with 2.5mm vertical drop
        // - Top (100mm): vertical U-slot from top edge
        for (py = pivot_heights) {
            if (py == pivot_h) {
                // Top step: vertical U-slot
                translate([0, py])
                    circle(d = bolt_slot_w);
                translate([-bolt_slot_w / 2, py])
                    square([bolt_slot_w, top_margin + 1]);
                // 45-degree flared entry at top
                polygon(points = [
                    [-bolt_slot_w / 2, total_h - 3],
                    [ bolt_slot_w / 2, total_h - 3],
                    [ bolt_slot_w / 2 + 4, total_h + 1],
                    [-bolt_slot_w / 2 - 4, total_h + 1]
                ]);
            } else {
                // Lower/Mid steps: vertical drop pocket + 45-deg angled entry slot
                hull() {
                    translate([0, py])
                        circle(d = bolt_slot_w);
                    translate([0, py + j_drop])
                        circle(d = bolt_slot_w);
                }
                hull() {
                    translate([0, py + j_drop])
                        circle(d = bolt_slot_w);
                    translate([45, py + j_drop + 45])
                        circle(d = bolt_slot_w);
                }
            }
        }

        // Left & Right truss cutout windows (kept below Y=44mm so J-slot region stays solid)
        for (sx = [-1, 1]) {
            scale([sx, 1])
            offset(r = 4) offset(delta = -4)
            polygon(points = [
                [rib_half_w,              frame_w],
                [side_base_len / 2 - 16,  frame_w],
                [rib_half_w,              44.0]
            ]);
        }

        // Vertical half-lap slit from bottom (0 to slit_h) for cross-brace
        translate([-slot_w / 2, -0.5])
            square([slot_w, slit_h + 0.5 + fit_tol]);
    }
}

module base_outer_2d() {
    // "H" frame: two side rails + central crossbar at X=0
    offset(r = 4) offset(delta = -4)
    union() {
        // Left & Right side rails
        for (sy = [-1, 1]) {
            translate([0, sy * (base_w / 2 - base_side_rail_w / 2)])
                square([base_len, base_side_rail_w], center = true);
        }
        // Central crossbar supporting the cross-brace
        square([base_cross_w, base_w], center = true);
    }
}

module base_holes_2d() {
    slot_w = plate_t + 2 * fit_tol;
    slot_l = tab_len + 2 * fit_tol;

    // Side plate tab slots (2 per side, 4 total)
    for (sy = [-1, 1]) {
        for (sx = [-1, 1]) {
            translate([sx * tab_x_offset, sy * wall_center_y])
                square([slot_l, slot_w], center = true);
        }
    }

    // Cross-brace bottom tab slots along X=0 (inner 2x + outer 2x)
    for (sy = [-1, 1]) {
        translate([0, sy * brace_in_tab_y])
            square([slot_w, brace_in_tab_l + 2 * fit_tol], center = true);
        translate([0, sy * brace_out_tab_y])
            square([slot_w, brace_out_tab_l + 2 * fit_tol], center = true);
    }
}

module base_frame_2d() {
    difference() {
        base_outer_2d();
        base_holes_2d();
    }
}

module base_boss_2d() {
    difference() {
        intersection() {
            base_outer_2d();
            offset(r = base_boss_pad) base_holes_2d();
        }
        base_holes_2d();
    }
}

module cross_brace_2d() {
    // 2D coordinates: X = Y_stand (-brace_half_w to +brace_half_w), Y = Z above base top (0 to brace_h)
    slot_w = plate_t + 2 * fit_tol;

    difference() {
        union() {
            // Main symmetrical brace bridging both side plates
            offset(r = 2) offset(delta = -2)
            polygon(points = [
                [-brace_half_w,       0],
                [ brace_half_w,       0],
                [ brace_half_w,       8],
                [ wall_center_y + 5,  brace_h],
                [ wall_center_y - 6,  brace_h],
                [ 24,                 brace_mid_h],
                [-24,                 brace_mid_h],
                [-wall_center_y + 6,  brace_h],
                [-wall_center_y - 5,  brace_h],
                [-brace_half_w,       8]
            ]);

            // Bottom interlocking tabs into H-frame crossbar (matching base_slot_depth)
            for (sx = [-1, 1]) {
                translate([sx * brace_in_tab_y - brace_in_tab_l / 2, -base_slot_depth])
                    square([brace_in_tab_l, base_slot_depth + 1]);
                translate([sx * brace_out_tab_y - brace_out_tab_l / 2, -base_slot_depth])
                    square([brace_out_tab_l, base_slot_depth + 1]);
            }
        }

        // Vertical half-lap slits from top (slit_h to brace_h) at side plate positions
        for (sx = [-1, 1]) {
            translate([sx * wall_center_y - slot_w / 2, slit_h - fit_tol])
                square([slot_w, brace_h - slit_h + 2]);
        }
    }
}

// --- 3D Modules (Print Orientation: flat on XY, Z=0..plate_t) ---

module part_side_plate() {
    linear_extrude(height = plate_t)
        side_plate_2d();
}

module part_base_frame() {
    union() {
        linear_extrude(height = plate_t)
            base_frame_2d();
        if (base_boss_h > 0) {
            translate([0, 0, plate_t - 0.01])
            linear_extrude(height = base_boss_h + 0.01)
                base_boss_2d();
        }
    }
}

module part_cross_brace() {
    linear_extrude(height = plate_t)
        cross_brace_2d();
}

// --- Assembled View ---
module stand_assembled() {
    // H-shaped base frame at Z = 0..plate_t (boss Z = plate_t..base_slot_depth)
    part_base_frame();

    // Left & Right side plates (bottom edge at Z = base_slot_depth, tabs go Z = 0..base_slot_depth)
    for (sy = [-1, 1]) {
        translate([0, sy * wall_center_y + plate_t / 2, base_slot_depth])
        rotate([90, 0, 0])
            part_side_plate();
    }

    // Central cross-brace (spanning both side plates via vertical cross-slits)
    translate([-plate_t / 2, 0, base_slot_depth])
    rotate([90, 0, 90])
        part_cross_brace();
}

// --- Dispatch ---
if (part == "side_plate") {
    part_side_plate();
} else if (part == "base_frame") {
    part_base_frame();
} else if (part == "cross_brace") {
    part_cross_brace();
} else if (part == "print_base_set") {
    // H-base frame (Y: -38..+92) + cross-brace (Y: -94..-46) -> fits 200x200mm bed
    translate([0, 27, 0])
        part_base_frame();
    translate([0, -90, 0])
        part_cross_brace();
} else if (part == "assembled") {
    stand_assembled();
}
