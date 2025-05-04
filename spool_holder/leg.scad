include <BOSL2/std.scad>

hole_dist = 62.5;
hole_d = 3.3;
w = 12.0;
t_min = 3.0;
t_max = 10.0;
chamfer = 0.5;

_ = 0.1;

difference() {
    union() {
        cuboid([hole_dist, w, t_min], chamfer=chamfer, anchor=BOTTOM);
        cuboid([hole_dist-w, w, t_max], chamfer=chamfer, anchor=BOTTOM);
        xcopies(n=2, spacing=hole_dist) cyl(d=w, l=t_min, chamfer=chamfer, anchor=BOTTOM, $fn=32);
    }
    move([0, 0, -_]) xcopies(n=2, spacing=hole_dist) cyl(d=hole_d, l=t_min+2*_, chamfer=-chamfer, anchor=BOTTOM, $fn=32);
    move([0, 0, t_min/2]) zflip_copy(-t_min/2-_) xcopies(n=2, spacing=hole_dist) tube(h=t_min*0.3, od1=hole_d*2.8, od2=hole_d*2.4, id1=hole_d*2.0, id2=hole_d*2.4, anchor=BOTTOM, $fn=32);
}
