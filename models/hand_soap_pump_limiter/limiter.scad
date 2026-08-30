include <BOSL2/std.scad>

inner_d = 17.5;
h = 8.0;
t = 3.0;
t_min = 1.5;
opening_angle = 90;

intersection() {
    union() {
        left_half() scale([(inner_d+2*t_min)/(inner_d+2*t), 1, 1]) cyl(h=h, d=inner_d+2*t, anchor=BOTTOM);
        right_half() cyl(h=h, d=inner_d+2*t, anchor=BOTTOM);
    }
    difference() {
        tube(h=h, id=inner_d, wall=t, anchor=BOTTOM);
        pie_slice(ang=opening_angle, h=h, r=inner_d/2+t, spin=-opening_angle/2);
    }
}

yflip_copy()
    rot([0, 0, opening_angle/2])
        right(inner_d/2)
            cuboid([2*t, t, h], anchor=LEFT+BOTTOM+FRONT, chamfer=t/4, edges=[RIGHT+FRONT, RIGHT+BACK]);
