include <BOSL2/std.scad>
include <BOSL2/gears.scad>

teeth=23;

module gear(gear_h, gear_shaft_d, track_circle_d, track_center_dist, horn_pocket_depth, horn_pocket_bottom_t, chamfer=0.5, clearance=0.3) {
    horn_gear_pocket_angle = asin((track_center_dist-track_circle_d)/track_circle_d);
    difference() {
        union() {
            gear_t2 = horn_pocket_depth+horn_pocket_bottom_t;
            gear_t1 = gear_h-clearance-gear_t2;
            spur_gear(mod=track_center_dist/teeth, teeth=teeth, thickness=gear_t1, shaft_diam=gear_shaft_d+clearance, anchor=BOTTOM, chamfer=chamfer, backlash=clearance);
            up(gear_t1)
                difference() {
                    cyl(h=gear_t2, d=track_center_dist, anchor=BOTTOM, chamfer2=chamfer);
                    up(horn_pocket_bottom_t) zrot_copies(n=6) union() {
                        right(track_circle_d/2) cyl(h=horn_pocket_depth, d=track_center_dist-track_circle_d, anchor=BOTTOM);
                        intersection() { 
                            tube(id=track_circle_d, od=track_center_dist, h=horn_pocket_depth, anchor=BOTTOM);
                            pie_slice(d=track_center_dist, ang=2*horn_gear_pocket_angle, spin=-horn_gear_pocket_angle, h=horn_pocket_depth, anchor=BOTTOM);
                        }
                    }
                }
        }
        cyl(h=gear_h+clearance, d=gear_shaft_d, anchor=BOTTOM, chamfer=-chamfer);
    }
}

gear(gear_h=6.0, gear_shaft_d=20.0, track_circle_d=50.0, track_center_dist=60.0, horn_pocket_depth=2.0, horn_pocket_bottom_t=1.0, chamfer=0.5, clearance=0.3);