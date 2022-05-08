include <BOSL2/std.scad>

_ = 0.01;
t = 5;
d = 30;
h = 50;
hole_height = 10;
$fn=64;

module arc(r_inner, t, angle) {
    intersection() {
        tube(ir = r_inner, wall = t, h = t, anchor = BOTTOM);
        pie_slice(ang = angle, r = r_inner + t, h = t);
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
    union() {
        cuboid(p1 = [0, -_, 0], [t, h + 2 * _, t]);
        move([0.1 * d + t, h, 0]) rotate([0, 0, 90]) arc(0.1 * d, t, 90);
        cuboid(p1 = [0.1 * d + t - _, 0.1 * d + h, 0], [0.7 * d + 2 * _, t, t]);
        move([0.8 * d + t, h, 0]) rotate([0, 0, 60]) {
            arc(0.1 * d, t, 30);
            cuboid(p1 = [0.1 * d, - hole_height - _, 0], [t, hole_height + 2 * _, t]);
            move([0, -hole_height, 0]) rotate([0, 0, -60]) arc(0.1 * d, t, 60);
        }
        move([t - _, h - hole_height - t, 0]) rotate([0, 90, 0]) cuboid([t, t, d + _], rounding = -0.5 * t, edges = [BOTTOM+FRONT, BOTTOM+BACK], anchor = FRONT+BOTTOM+RIGHT);
    }
}

union() {
    top_part();
    translate([0.5 * d + t, 0, 0]) rotate([0, 0, 180]) bottom_part();
}
