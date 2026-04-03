include <BOSL2/std.scad>

_ = 0.01;
t = 10;
d = 35;
h = 100;
hole_r = 10;
arm_r = 40;
arm_pos = 50;
$fn=64;

union() {
    intersection() {
        torus(r_maj = (d + t) / 2, r_min = t / 2);
        pie_slice(ang = 210, d = d + 2 * t, h = t, anchor = CENTER);
    }
    rotate([0, 0, 210]) move(x = (d + t) / 2) sphere(d = t);
    move(x = (d + t) / 2) {
        rotate([90, 0, 0]) cyl(d = t, l = h, anchor = BOTTOM);
        move(y = -(h + hole_r + t / 2)) rotate([0, 90, 0]) torus(r_maj = hole_r + t / 2, r_min = t / 2);

        for(i = [-1, 1]) {
            move(y = arm_r - arm_pos) rotate([90 * i, 0, -90]) {
                intersection() {
                    torus(r_maj = arm_r + t / 2, r_min = t / 2);
                    pie_slice(ang = 60, d = 2 * (arm_r + t), h = t, anchor = CENTER);
                }
                rotate([0, 0, 60]) move(x = arm_r + t / 2) sphere(d = t);
            }
        }
    }
}
