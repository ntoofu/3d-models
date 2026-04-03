include <BOSL2/std.scad>

$fn = 32;

shaft_id = 5.8;
shaft_od = 8.6;
shaft_hole_depth = 6.6;
shaft_hole_slope_gap = 3.0;
shaft_hole_slope_center_z = 2.7;
shaft_hole_slope_angle = 20.0;
latch_arm_top_z = 6.4;
latch_arm_length = 3.0;
latch_arm_thickness = 2.5;
latch_top_z = 4.0;
latch_size = 1.0;
latch_angle = 90.0;
bottom_z = 9.0;
center_part_od = 18.0;

clearance = 0.1;
_ = 0.01;


module shaft_hole_slope() {
    intersection() {
        move([0, shaft_hole_slope_gap / 2 + clearance, -shaft_hole_slope_center_z])
            rotate([0, shaft_hole_slope_angle, 0])
            cuboid([bottom_z * 2, shaft_od, bottom_z], anchor=TOP+FRONT);
        cyl(d=shaft_od, h=bottom_z, anchor=TOP);
    }
}

module latch() {
    rotate([0, 0, 90]) intersection() {
        move([0, 0, -latch_top_z])
            tube(id=(shaft_od + latch_arm_length * 2), od=center_part_od, h=(bottom_z - latch_top_z), anchor=TOP);
        pie_slice(d=center_part_od, ang=latch_angle, h=bottom_z, anchor=TOP);
    }
    move([0, shaft_od / 2 + latch_arm_length, -latch_top_z]) cuboid([latch_arm_thickness / 2, (center_part_od - shaft_od - latch_arm_length * 2) / 2, bottom_z - latch_top_z], anchor=TOP+LEFT+FRONT);
    rotate([0, 0, latch_angle])
        move([0, shaft_od / 2 + latch_arm_length, -latch_top_z])
        union() {
            cuboid([latch_size, (center_part_od - shaft_od - latch_arm_length * 2) / 2, bottom_z - latch_top_z], anchor=TOP+RIGHT+FRONT);
            rotate([90, 0, 0])
                prismoid(size1=[latch_size, bottom_z - latch_top_z], size2=[0, bottom_z - latch_top_z], shift=[latch_size / 2, 0], h=latch_size, anchor=BOTTOM+RIGHT+BACK);
        }
    intersection() {
        move([0, 0, -latch_arm_top_z]) cuboid([latch_arm_thickness, center_part_od / 2, bottom_z - latch_arm_top_z], anchor=TOP+FRONT);
        tube(id=shaft_id, od=center_part_od, h=bottom_z, anchor=TOP);
    }

}

module center_part() {
    tube(id=shaft_id, od=shaft_od, h=bottom_z, anchor=TOP);
    rotate([0, 0,   0]) shaft_hole_slope();
    rotate([0, 0, 180]) shaft_hole_slope();
    rotate([0, 0,   0]) latch();
    rotate([0, 0, 120]) latch();
    rotate([0, 0, 240]) latch();
}

module propeller_wing() {
    path = arc(d=50, angle=30, $fn=64);
    widths = [for (i=idx(path)) 2*(1-i/len(path))+1];
    move([10, -5, -6.4]) rotate([10, 0, 0]) rotate([0, 90, 0])
        extrude_from_to([0, 0, 0], [0, 0, 50], twist=15, scale=1.5, slices=40)
            move([-25, 0, 0]) stroke(path, width=widths, $fa=1, $fs=1);
}

module propeller() {
    difference() {
        intersection() {
            zrot_copies(n=3) propeller_wing();
            cyl(r=55, h=20);
        }
        cyl(r=15, h=20);
    }
    zrot_copies(n=3)
        intersection() {
            tube(or=15, wall=2, h=8, anchor=TOP);
            pie_slice(r=15, ang=60, spin=-28, h=8, anchor=TOP);
        }
    move([0, 0, -4.5])
        union() {
            rotate([0, 0, 93])
                zrot_copies(n=3)
                    cylindrical_extrude(ir=55, or=57, $fn=64)
                        scale([3, 1])
                            circle(r=5);
            tube(ir=55, wall=2, h=3, $fn=120);
        }
}

union() {
    rotate([0, 0, 10])
        center_part();
    move([0, 0, -bottom_z])
        scale(center_part_od/30)
            propeller();
}
