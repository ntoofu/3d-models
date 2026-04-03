include <BOSL2/std.scad>

insert_od = 6.3;
clearance_od = 0.1;
insert_id = 5.1;
clearance_id = 0.9;
insert_l = 15.0;
clearance_l = -1.5;
od = 10.0;
l = 40.0;
cutout_d = 0.6;
cutout_pos = 3.0;
_ = 0.1;
chamfer = 0.5;


difference() {
    cyl(d=od, h=l, anchor=BOTTOM, chamfer=chamfer, $fn=32);
    move([0, 0, l+_]) cyl(d=insert_od+clearance_od, h=insert_l+clearance_l+_, chamfer2=-chamfer, anchor=TOP, $fn=32);
    cyl(d=insert_id+clearance_id, h=l, anchor=BOTTOM, chamfer1=-chamfer, $fn=32);
    move([0, 0, cutout_pos]) tube(id1=od-cutout_d*2, od1=od, id2=od, od2=od, h=cutout_d, anchor=BOTTOM, $fn=32);
}
