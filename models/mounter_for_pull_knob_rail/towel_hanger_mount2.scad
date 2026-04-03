include <BOSL2/std.scad>
use <mount.scad>

hanger_w = 10.0;
front_t = 3.0;
tapping_d = 2.3;
tapping_space = 13.0;
chamfer=0.5;
_ = 0.05;

module hex_pillar(id, h) {
    extrude_from_to([0, 0, -h/2], [0, 0, h/2])
        hexagon(id=id, realign=true);
}

difference() {
    mount(width=hanger_w, front_t=front_t);
    #move([0, -mount_h()*0.5, 0])
        ycopies(spacing=tapping_space, n=2)
            rotate([0, 90, 0]) hex_pillar(tapping_d, h=2*(front_t+10));
}

