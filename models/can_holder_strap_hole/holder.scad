include <BOSL2/std.scad>

ir = 38.0;
or = 42.0;
thickness = 2.0;

wing_ang = 20.0;
wing_arm = 0.5;
wing_l = 17.0;
wing_t = 3.0;
hole_r = 3.0;

_ = 0.1;
$fn = 256;

module wing() {
    difference() {
        rotate([0, 0, -wing_ang / 2]) intersection() {
            union() {
                tube(ir = or - _, or = or + wing_arm + _, h = thickness);
                tube(ir = or + wing_arm, or = or + wing_arm + wing_t, h = wing_l + thickness);
            }
            pie_slice(ang = wing_ang, r = or + wing_arm + wing_t, h = wing_l + thickness);
        }
        move(z = wing_l + thickness - hole_r - 2.0) xcyl(r = hole_r, l = 2 * (or + wing_arm + wing_t) + _);
    }
}


union() {
    tube(ir = ir, or = or, h = thickness);
    rotate([0, 0,   0]) wing();
    rotate([0, 0,  90]) wing();
    rotate([0, 0, 180]) wing();
    rotate([0, 0, 270]) wing();
}
