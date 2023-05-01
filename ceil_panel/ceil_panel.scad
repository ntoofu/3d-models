include <BOSL2/std.scad>

t = 2.0;
d = 99.0;
_ = 0.1;

hole_d = 16.0;
latch_w = 15.0;
latch_d = 2.5;
latch_t = 3.0;
latch_l = 5.0;
latch_gap = 49.0;


module latch() {
    union() {
        move(z=-_) cuboid([latch_t, latch_w, latch_d+latch_t+2*_], anchor=BOTTOM+RIGHT+BACK);
        move(x=-latch_t, z=latch_d) cuboid([latch_t+latch_l, latch_w, latch_t], anchor=BOTTOM+LEFT+BACK);
    }
}

difference() {
    union() {
        cyl(d=d, h=t, anchor=TOP);
        move(x=latch_gap/2) latch();
        rotate([0, 0, 180]) move(x=latch_gap/2) latch();
    }
    move(z=_) cyl(d=hole_d, h=t+2*_, anchor=TOP);
}
