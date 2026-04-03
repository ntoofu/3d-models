include <BOSL2/std.scad>

$fs = $preview ? 1 : 0.2;

tapping_id = 7.4;
d = 40.0;
l = 80.0;
edge = 3.0;
chamfer = 0.5;
_ = 0.1;

module hex_pillar(id, h) {
    extrude_from_to([0, 0, -h/2], [0, 0, h/2])
        hexagon(id=id, realign=false);
}

difference() {
    union() {
        cyl(d=d, h=l);
        zflip_copy() move([0, 0, l / 2]) cyl(d=d + edge * 2, h=chamfer * 2, anchor=TOP, chamfer2=chamfer);
        zflip_copy() move([0, 0, l / 2 - chamfer * 2]) cyl(d1=d, d2=d + edge * 2, h=edge, anchor=TOP);
    }
    hex_pillar(id=tapping_id, h=l+_);
    zflip_copy() move([0, 0, l / 2 + _]) cyl(d1=tapping_id, d2=tapping_id * 2 / sqrt(3), h=tapping_id * (2 / sqrt(3) - 1), anchor=TOP);
}
