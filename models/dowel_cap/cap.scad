include <BOSL2/std.scad>

id = 5.2;
od = 9.8;
hole_h = 9.5;
h = 11.0;
brim_d = 13.0;
brim_t = 0.5;
chamfer = 1.0;
_ = 0.1;

difference() {
    union() {
        cyl(d = od, h = h, chamfer2 = chamfer, anchor = BOTTOM, $fn = 64);
        cyl(d = brim_d, h = brim_t, anchor = BOTTOM, $fn = 64);
    }
    cyl(d = id, h = hole_h, chamfer1 = -chamfer, anchor = BOTTOM, $fn = 64);
}
