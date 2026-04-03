include <BOSL2/std.scad>

_ = 0.01;
$fs = 0.1;

t = 3.0;
mount_hole_w = 30.0;
mount_hole_d = 3.5;
vert_hole_w = 30.0;
vert_hole_d = 3.2;
vert_hole_offset = t + 5.0;
base_d = 15.0;
base_w = mount_hole_w + mount_hole_d * 5;
base_h = t + vert_hole_offset + vert_hole_w + vert_hole_d * 2;

difference() {
    union() {
        cuboid([base_w, base_d, t], anchor=BOTTOM+FRONT);
        move(z=t-_) prismoid(size1=[base_w, t], size2=[vert_hole_d * 3, t], h=base_h-t+_, anchor=BOTTOM+FRONT);
        move(x=-mount_hole_w/4) prismoid(size1=[t, base_d], size2=[t, 0], shift=[0, -base_d/2], h=base_d, anchor=BOTTOM+FRONT);
        move(x=mount_hole_w/4) prismoid(size1=[t, base_d], size2=[t, 0], shift=[0, -base_d/2], h=base_d, anchor=BOTTOM+FRONT);
    }
    move([mount_hole_w/2, (base_d+t)/2, -_]) cyl(d=mount_hole_d, h=t+2*_, anchor=BOTTOM);
    move([-mount_hole_w/2, (base_d+t)/2, -_]) cyl(d=mount_hole_d, h=t+2*_, anchor=BOTTOM);
    move([0, -_, vert_hole_offset]) rotate([-90, 0, 0]) cyl(d=vert_hole_d, h=t+2*_, anchor=BOTTOM);
    move([0, -_, vert_hole_offset+vert_hole_w]) rotate([-90, 0, 0]) cyl(d=vert_hole_d, h=t+2*_, anchor=BOTTOM);
}
