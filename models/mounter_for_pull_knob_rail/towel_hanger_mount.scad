include <BOSL2/std.scad>
use <mount.scad>

hanger_hole_t = 2.2;
hanger_hole_w = 10.2;
front_t = hanger_hole_t*2 + 1.0;
tapping_d = 2.7;
head_d = 6.0;
chamfer=0.5;
_ = 0.05;

module hex_pillar(id, h) {
    extrude_from_to([0, 0, -h/2], [0, 0, h/2])
        hexagon(id=id, realign=true);
}

difference() {
    mount(width=hanger_hole_w+2*hanger_hole_t, front_t=front_t);
    move([-hanger_hole_t/2, -hanger_hole_t, 0]) cuboid([hanger_hole_t, mount_h()-hanger_hole_t+_, hanger_hole_w+2*hanger_hole_t], anchor=RIGHT+BACK, chamfer=-chamfer);
    move([-hanger_hole_t/2+_, -mount_h()*0.5, 0]) rotate([0, 90, 0]) hex_pillar(head_d, h=hanger_hole_t+_);
    move([-5+_, -mount_h()*0.5, 0]) rotate([0, 90, 0]) hex_pillar(tapping_d, h=10);
}

