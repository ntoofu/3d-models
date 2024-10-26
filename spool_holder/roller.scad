include <BOSL2/std.scad>

bearing_t = 7.0;
bearing_od = 22.0;

d = 35.0;
chamfer = 1.0;
l = bearing_t + chamfer*2;
clearance = 0.05;
_ = 0.1;

difference() {
	cyl(d=d, h=l, chamfer=chamfer, $fn=64);
	cyl(d=bearing_od + clearance * 2, h=l + _, chamfer=-chamfer, $fn=48);
	torus(d_maj=d+l-chamfer*4, d_min=(l-chamfer*4)*sqrt(2), $fn=64);
}
