include <BOSL2/std.scad>

$fn = 32;

pole_d = 17.0;
gap = 2.0;
h = 30.0;
strap_hole_d = 6.0;
screw_hole_d = 3.3;
tapping_d = 2.7;
chamfer_size = 3.0;
wall_t = 7.0;
mounter_l = 20.0;

_ = 0.01;

width = pole_d+2*wall_t;

module tap_hole() {
    union() {
        extrude_from_to([-15, 0, 0], [_, 0, 0])
            hexagon(id=tapping_d, realign=true);
        rotate([0, 0, 90])
            teardrop(d=screw_hole_d, h=5+_, ang=30, cap_h=screw_hole_d/2, anchor=BACK);
        move([5, 0, 0]) rotate([0, 0, 90])
            teardrop(d=screw_hole_d*2.0, h=width/2-5+_, ang=30, cap_h=screw_hole_d*2.0/2, anchor=BACK);
    }
}

module joint() {
    difference() {
        union() {
            cyl(d=width, h=h, chamfer=chamfer_size);
            cuboid([width, pole_d/2+mounter_l, h], anchor=FRONT, chamfer=chamfer_size, edges=[BACK,TOP+RIGHT,TOP+LEFT,BOTTOM+RIGHT,BOTTOM+LEFT]);
        }
        cyl(d=pole_d, h=h+_);
            cuboid([gap, pole_d/2+wall_t+_, h+_], anchor=BACK);
        tap_y = pole_d/2+0.3*mounter_l;
        move([0, tap_y, 0])
            zcopies(n=2, spacing=0.5*h)
            tap_hole();
        strap_y = pole_d/2+0.65*mounter_l;
        move([0, strap_y, 0])
            xcopies(n=2, spacing=0.4*width)
            cyl(d=strap_hole_d, h=h+_);
    }
}

move([ 0.2, 0, 0]) right_half() joint();
move([-0.2, 0, 0])  left_half() joint();
