include <BOSL2/std.scad>

length = 25.0;
thickness_xy = 3.5;
thickness_z = 2.0;
r = 0.5;
tab = 2.0;
hole_w = 15.0;
hole_h = 3.0;
hole_d = 6.3;

_ = 0.01;
$fn = 32;

module leg(l) {
    difference() {
        union() {
            cuboid([thickness_xy , hole_h, hole_d + thickness_z + 2.0], rounding = r, p1 = [0, 0, 0]);
            cuboid([thickness_xy, l + _, thickness_z], rounding = r, edges = [FRONT, TOP + RIGHT, TOP + LEFT, BOTTOM + RIGHT, BOTTOM + LEFT], p1 = [0, 0, 0]);
            cuboid([tab + _, hole_h - 2 * r, 2 - r], p1 = [thickness_xy - _, r, thickness_z + hole_d]);
        }
        move([thickness_xy / 2, hole_h / 2, -_]) prismoid(size1 = [0.4 * thickness_xy + 0.1, 0.4 * hole_h + 0.1], size2 = [0.2 * thickness_xy + 0.1, 0.4 * hole_h + 0.1], h = hole_d + thickness_z + 2.0 + 5.0);
    }
}

union() {
    move(y = length - hole_w / 2) intersection() {
        difference() {
            cyl(l = thickness_z, d = hole_w, rounding = r, anchor = BOTTOM);
            move(z = -_) cyl(d = hole_w - 2 * thickness_xy, h = thickness_z + 2 * _, rounding = -r, anchor = BOTTOM);
        }
        move(x = -hole_w / 2) cube([hole_w, hole_w /2, thickness_z]);
    };
    move(x = hole_w / 2 - thickness_xy) leg(length - hole_w / 2);
    xflip() move(x = hole_w / 2 - thickness_xy) leg(length - hole_w / 2);
}

move(x = -0.4 * thickness_xy) rotate([-90, 0, 0]) prismoid(size1 = [0.4 * thickness_xy, 0.4 * hole_h], size2 = [0.2 * thickness_xy, 0.4 * hole_h], h = hole_d + thickness_z + 2.0 + 5.0, anchor = BOTTOM + BACK);
move(x = 0.4 * thickness_xy, y = hole_d + thickness_z + 2.0 + 5.0) rotate([90, 0, 0]) prismoid(size1 = [0.4 * thickness_xy, 0.4 * hole_h], size2 = [0.2 * thickness_xy, 0.4 * hole_h], h = hole_d + thickness_z + 2.0 + 5.0, anchor = BOTTOM + FRONT);
