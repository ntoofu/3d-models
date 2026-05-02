include <BOSL2/std.scad>

arm_l = 12.0;
arm_w = 5.0;
arm_t = 1.5;
screw_hole_d = 3.2;
center_d = 7.0;
center_h = 3.0;
mount_d = 7.0;
mount_h = 5.5;
support_w = 4.0;
support_h = 4.0;
dist_mount_to_center = arm_l+center_d/2+mount_d/2;
chamfer = 0.5;

module arm(n) {
    difference() {
        union() {
            rot_copies(v = DOWN, n = n) union() {
                difference() {
                    cuboid([dist_mount_to_center, arm_w, arm_t], anchor=LEFT+BOTTOM);
                    move([center_d/2+arm_l-arm_w/4, 0, 0]) ycopies(spacing=arm_w+arm_t, n=2) cyl(d=arm_w, h=mount_h, anchor=BOTTOM, $fn=16);
                }
                move([dist_mount_to_center, 0, 0])
                    cyl(d=mount_d, h=mount_h, chamfer2=chamfer, anchor=BOTTOM, $fn=16);
            }
            tube(od=center_d+arm_l*2+mount_d+support_w, id=center_d+arm_l*2+mount_d-support_w, h=support_h, anchor=BOTTOM, $fn=32);
        }
        rot_copies(v = DOWN, n = n)
            move([dist_mount_to_center, 0, 0])
                cyl(d=screw_hole_d, h=mount_h, chamfer=-chamfer, anchor=BOTTOM, $fn=16);
    }
}

difference() {
    union() {
        cyl(d=center_d, h=center_h, chamfer2=chamfer, anchor=BOTTOM, $fn=16);
        arm(4);
    }
    cyl(d=screw_hole_d, h=center_h, chamfer=-chamfer, anchor=BOTTOM, $fn=16);
}