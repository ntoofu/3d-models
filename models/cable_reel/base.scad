include <BOSL2/std.scad>

module screw_positions_copies(base_w, base_h, spacer_d, chamfer) {
    xcopies(l=base_w-spacer_d-chamfer*4, n=3)
        ycopies(l=base_h-spacer_d-chamfer*4, n=2)
            children();
}

module base(track_center_dist, base_t, base_w, base_h, gear_shfat_d, gear_h, spacer_d, clearance_hole_d, chamfer=0.5, clearance=0.3) {
    difference() {
        union() {
            cuboid([base_w, base_h, base_t], anchor=BOTTOM, chamfer=chamfer);
            up(base_t) {
                xcopies(spacing=track_center_dist, n=2)
                    cyl(h=gear_h+clearance, d=gear_shfat_d-clearance, anchor=BOTTOM, chamfer1=-chamfer, chamfer2=chamfer);
                screw_positions_copies(base_w, base_h, spacer_d, chamfer)
                    cyl(d=spacer_d, h=gear_h+clearance, anchor=BOTTOM, chamfer1=-chamfer, chamfer2=chamfer);
            }
        }
        xcopies(spacing=track_center_dist, n=2)
            xcopies(spacing=gear_shfat_d/2, n=2)
                cyl(h=base_t+gear_h+clearance, d=clearance_hole_d, anchor=BOTTOM, chamfer=-chamfer);
        screw_positions_copies(base_w, base_h, spacer_d, chamfer)
            cyl(d=clearance_hole_d, h=base_t+gear_h+clearance, anchor=BOTTOM, chamfer=-chamfer);
    }
}

base(track_center_dist=60.0, base_t=3.0, base_w=130.0, base_h=70.0, gear_shfat_d=20.0, gear_h=7.0, spacer_d=8.0, clearance_hole_d=3.2, chamfer=0.5);