include <BOSL2/std.scad>

insert_od = 12.2;
clearance_od = 0.5;
insert_id = 10.2;
clearance_id = 1.5;
insert_l = 30.0 + 3.0;

base_w = 76.0;
half_l = 50.0;
clamp_h = 20.0;
clamp_l = 30.0;
hole_angle = 15;
hole_pos = clamp_h/2/tan(hole_angle);
mark_w = 2.0;
screw_hole_d = 3.5;
screw_hole_l = 4.5;
chamfer = 1.0;


p = [
	[-half_l/2, -clamp_h/2+chamfer],
	[-half_l/2+chamfer, -clamp_h/2],
	[ half_l/2, -clamp_h/2],
	[ hole_pos+clamp_l-chamfer, -clamp_h/2],
	[ hole_pos+clamp_l, -clamp_h/2+chamfer],
	[ hole_pos+clamp_l,  clamp_h/2-chamfer],
	[ hole_pos+clamp_l-chamfer,  clamp_h/2],
	[ half_l/2,  clamp_h/2],
	rot(a=-hole_angle*2, p=[-half_l/2+chamfer, clamp_h/2]),
	rot(a=-hole_angle*2, p=[-half_l/2, clamp_h/2-chamfer]),
];

offset = insert_l - (clamp_h/2/sin(hole_angle) - (insert_od+clearance_od)/2/tan(hole_angle));


rotate([90, -90-hole_angle, 0]) difference() {
    linear_extrude(height=base_w, center=true, convexity=5, slices=10) region(p);
    zcopies(n=2, spacing=base_w/2) union() {
        rotate([0, 90, -hole_angle]) cyl(h=half_l*4, d=insert_id+clearance_id);
        rotate([0, 0, -hole_angle]) move([-offset, 0, 0]) rotate([0, 90, 0]) cyl(h=insert_l+half_l, d=insert_od+clearance_od, anchor=BOTTOM, $fn=64);
    }
    zflip_copy() move([hole_pos, 0, -base_w/2]) prismoid(size1=[mark_w, clamp_h], size2=[0,clamp_h], shift=[-mark_w/2, 0], h=mark_w*0.5, anchor=LEFT+BOTTOM);
    move([half_l/2, 0, 0]) xcopies(n=2, spacing=half_l) union() {
        rotate([0, 90, 0]) move([0, -clamp_h/2, 0]) teardrop(l=screw_hole_l+screw_hole_d, d=screw_hole_d, $fn=16, chamfer2=-screw_hole_d, ang=30, anchor=FRONT);
        rotate([0, 90, 0]) move([0, -clamp_h/2+screw_hole_l+screw_hole_d, 0]) teardrop(l=clamp_h*2, d=screw_hole_d*2, $fn=16, ang=30, anchor=FRONT);
    }
}

