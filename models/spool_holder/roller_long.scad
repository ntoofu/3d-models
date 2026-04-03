include <BOSL2/std.scad>

// 608Z
bearing_t = 7.0;
bearing_od = 22.0;

d_min = 20.0;
d_max = bearing_od + 2 * 4.0;
cap_h = 3.0;
chamfer = 0.5;

l_body = 80.0;
l_total = l_body + cap_h * 2 + chamfer * 4;

clearance = 0.1;

difference() {
    union() {
        n = 20;
        skin([for (i=[-n/2:n/2]) path3d(circle(d=d_min + (d_max - d_min) * pow(2 * i / n, 2), $fn=64), (l_body * i / n))], slices=n);
        
        zflip_copy() move([0, 0, l_body / 2]) {
            cyl(d1=d_max, d2=d_max+cap_h, h=cap_h, anchor=BOTTOM);
            move([0, 0, cap_h]) cyl(d=d_max+cap_h, h=chamfer*2, chamfer2=chamfer, anchor=BOTTOM);
        }
    }
    zflip_copy() move([0, 0, l_total / 2]) {
        cyl(d=bearing_od+clearance, h=bearing_t+cap_h-chamfer, chamfer1=cap_h, chamfer2=-chamfer, anchor=TOP);
    }
}
