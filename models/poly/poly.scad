include <BOSL2/std.scad>

_ = 0.01;
$fn = 128;

shaft_d = 3.0;
shaft_support = 8.0;
t = 5.0;
poly_d = 50.0;
brim_d = 65.0;

module hex_pillar(d, l) {
    move(z=-l/2) rotate([0, -90, 0])
        path_extrude2d(path=[[0, 0], [l, 0]]) hexagon(or=d/2);
}

difference() {
    union() {
        cyl(d=poly_d, h=t, rounding=-t/2, anchor=TOP);
        move(z=-t+_) cyl(d=brim_d, h=t/2, anchor=TOP);
        move(z=-_) cyl(r=shaft_support/2, h=t+_, anchor=BOTTOM);
    }
    hex_pillar(d=shaft_d+0.1, l=3*t+_);
}
