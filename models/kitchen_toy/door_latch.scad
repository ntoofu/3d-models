include <BOSL2/std.scad>

base_x = 9.8;
base_y = 33.0;  // = 31.7; originally
base_z = 2.4;
len_to_latch = 6.5;
latch_l1 = 2.1;
latch_l2 = 4.4;
latch_w1 = base_x;
latch_w2 = base_x;
latch_w3 = 6.0;
latch_t1 = 2.8;
latch_t2 = 4.0;  // = 5.2; originally
latch_t3 = 0.4;
hole_d = 3.2;
hole_od = 5.2;
hole_ol = 2.0;
hole_dist = 23.4;
chamfer = 1.5;

layer_d = 0.1;
_ = 0.01;

difference() {
    cuboid([base_x, base_y, base_z], anchor=BOTTOM, edges=[TOP]);
    ycopies(spacing=hole_dist, n=2) rotate([90, 0, 90])
        teardrop(d=hole_d, cap_h=hole_d/2, h=base_z+_, ang=45, anchor=FRONT, $fn=16);
    ycopies(spacing=hole_dist, n=2) move([0, 0, base_z-hole_ol]) rotate([90, 0, 90])
        teardrop(d1=hole_d, cap_h1=hole_d/2, d2=hole_od, cap_h2=hole_od/2, h=hole_ol+_, ang=45, anchor=FRONT, $fn=16);
}
move([0, 0, base_z]) {
    cuboid([latch_w1, latch_t1, len_to_latch], anchor=BOTTOM, chamfer=-chamfer, edges=[BOTTOM+FRONT, BOTTOM+BACK]);
    move([0, 0, len_to_latch]) {
        prismoid(size1=[latch_w1, latch_t1], size2=[latch_w2, latch_t2], h=latch_l1, anchor=BOTTOM);
        move([0, 0, latch_l1])
            prismoid(size1=[latch_w2, latch_t2], size2=[latch_w3, latch_t3], h=latch_l2, anchor=BOTTOM);
    }
}
