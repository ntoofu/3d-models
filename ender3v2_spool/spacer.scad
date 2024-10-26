include <BOSL2/std.scad>

$fn = 32;

bearing_id = 8.0;
t1 = 3.0;
t2 = 4.0;
l = 2.0;
clearance = 0.1;
_ = 0.1;

difference() {
	cyl(d1=bearing_id + clearance * 2 + t2 * 2, d2=bearing_id + clearance * 2 + t1 * 2, h=l);
	cyl(d=bearing_id + clearance * 2, h=l + _);
}
