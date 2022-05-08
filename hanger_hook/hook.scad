include <BOSL2/std.scad>

_ = 0.01;
t = 5;
d = 30;
h = 50;
h_b = 10;
$fn=64;

/* module corner(r_inner, t) { */
/*     intersection() { */
/*         difference() { */
/*             cyl(r = r_inner + t, h = t, anchor = BOTTOM); */
/*             translate([0, 0, -_]) cyl(r = r_inner, h = t + 2 * _, anchor = BOTTOM); */
/*         } */
/*         translate([-_, -_, -_]) cube([r_inner + t + _, r_inner + t + _, t + 2 * _]); */
/*     } */
/* } */
module corner(r_inner, t) {
    intersection() {
        tube(ir = r_inner, wall = t, h = t, anchor = BOTTOM);
        cube([r_inner + t, r_inner + t, t]);
    }
}

module top_part() {
    union() {
        intersection() {
            tube(id = d, wall = t, h = t, anchor = BOTTOM);
            pie_slice(ang = 210, d = d + 2 * t, h = t);
        }
        rotate([0, 0, 210]) move(x = (d + t) / 2) cyl(d = t, h = t, anchor = BOTTOM);
    }
}

module bottom_part() {
    cube([t, h, t]);
    translate([0.1 * d + t, h, 0]) rotate([0, 0, 90]) corner(0.1 * d, t);
    translate([0.1 * d + t, 0.1 * d + h, 0]) cube([0.8 * d, t, t]);
    translate([0.9 * d + t, h, 0]) corner(d/10, t);
    translate([0.1 * d + t, 0.1 * d + h, 0]) cube([0.8 * d, t, t]);
    translate([d + t, h - h_b, 0]) cube([t, h_b, t]);
}

union() {
    top_part();
    translate([d/2 + t, 0, 0]) rotate([0, 0, 180]) bottom_part();
}
