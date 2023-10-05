include <BOSL2/std.scad>

leg_d = 25.2;
leg_space_x = 545;
leg_space_y = 575;
leg_length = 635;
diagonal_x = 775;
diagonal_y = 755;
leg_ax = 90 - acos((leg_length^2 + leg_space_x^2 - diagonal_x^2) / ( 2 * leg_length * leg_space_x));
leg_ay = 90 - acos((leg_length^2 + leg_space_y^2 - diagonal_y^2) / ( 2 * leg_length * leg_space_y));
echo(leg_ax);
echo(leg_ay);

thickness = 3.0;
h = 30.0;
mount_l = 50.0;
mount_w = 15.0;
hole_d1 = 3.0;
hole_d2 = 6.0;
clearance = 0.3;

_ = 0.01;

module mount() {
    difference() {
        union() {
            d = leg_d+clearance*2+thickness*2;
            rotate([-leg_ay, leg_ax, 0]) cyl(h=h, d=d, $fn=64);
            difference() {
                m_h = h*0.8;
                m_w = d*0.8;
                m_d = d/2;
                rotate([0, 90, 0]) prismoid(size1=[m_h,m_w], size2=[thickness,mount_l], h=m_d+mount_w, shift=[(m_h-thickness)/2,0], anchor=BOTTOM);
                move([m_d+mount_w/2, 0.25*mount_l,-m_h/2-_]) cyl(h=m_h, d=hole_d1+clearance, anchor=BOTTOM, $fn=16);
                move([m_d+mount_w/2,-0.25*mount_l,-m_h/2-_]) cyl(h=m_h, d=hole_d1+clearance, anchor=BOTTOM, $fn=16);
                move([m_d+mount_w/2, 0.25*mount_l,-m_h/2+thickness+0.1*m_h]) cyl(h=m_h, d=hole_d2+clearance, anchor=BOTTOM, $fn=16);
                move([m_d+mount_w/2,-0.25*mount_l,-m_h/2+thickness+0.1*m_h]) cyl(h=m_h, d=hole_d2+clearance, anchor=BOTTOM, $fn=16);
            }
        }
        rotate([-leg_ay, leg_ax, 0]) cyl(h=h+2*_, d=leg_d+2*clearance, $fn=64);
    }
}

mount();
