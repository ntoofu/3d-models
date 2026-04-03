include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

$fn = 32;


socket_id = 5.4;
socket_tapping_l = 2.0;

cap_w = 10.0;
l = 5.0;
filament_hole = 2.0;
chamfer = 0.5;
_ = 0.1;


module hex_pillar(id, h, chamfer1, chamfer2) {
    offset_sweep(
        hexagon(id=id, realign=false),
        height=h, convexity=5, top=os_chamfer(width=chamfer1), bottom=os_chamfer(width=chamfer2));
}

zflip()
    difference() {
        hex_pillar(id=cap_w, h=l, chamfer1=chamfer, chamfer2=chamfer);
        move([0, 0, socket_tapping_l]) cyl(d1=filament_hole, d2=filament_hole*2, h=l-socket_tapping_l, rounding=-chamfer, anchor=BOTTOM);
        move([0, 0, -_]) hex_pillar(id=socket_id, h=socket_tapping_l+_, chamfer1=0, chamfer2=-chamfer);
    }
