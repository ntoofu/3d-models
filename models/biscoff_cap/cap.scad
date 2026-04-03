include <BOSL2/std.scad>

package_x = 74.0;
package_y = 32.0;
cap_t = 3.0;
cap_h = 20.0;
chamfer = 1.0;
_ = 0.1;

difference() {
    cuboid([package_x+2*cap_t, package_y+2*cap_t, cap_h+cap_t], chamfer=chamfer, anchor=BOTTOM);
    move([0, 0, -_]) cuboid([package_x, package_y, cap_h+_], chamfer=chamfer, anchor=BOTTOM);
    move([0, 0, -_]) prismoid(size1=[package_x+2*chamfer, package_y+2*chamfer], size2=[package_x-2*chamfer, package_y-2*chamfer], h=2*chamfer, anchor=BOTTOM);
    move([-21, -16, cap_h+cap_t+1]) mirror([0, 0, 1]) scale([0.05, 0.05, 0.02]) surface(file="logo.png");
}
