include <BOSL2/std.scad>

stapler_layer_t = 0.35;
tray_d = 50.0;
tray_w = 100.0;
tray_h = 6.0;
tray_t = 3.0;
chamfer = 1.0;
num_hooks = 3;
hook_h = 30.0;
hook_l = 30.0;
hook_d = 10.0;

_ = 0.05;

union() {

    // Tray
    difference() {
        cuboid([tray_w, tray_d, tray_h], chamfer=chamfer, anchor=BOTTOM+BACK, edges=[FRONT,LEFT+TOP,LEFT+BOTTOM,RIGHT+TOP,RIGHT+BOTTOM]);
        move([0, tray_h-tray_t*2, tray_t]) cuboid([tray_w+2*(tray_h-tray_t)-2*tray_t, tray_d+2*(tray_h-tray_t)-2*tray_t, 2*(2+sqrt(2))*(tray_h-tray_t)], rounding=(2+sqrt(2))*(tray_h-tray_t), anchor=BOTTOM+BACK);
    }

    // Stapler Layer
    move([0, 0, chamfer]) cuboid([tray_w, stapler_layer_t, hook_h-hook_d/2+chamfer], anchor=TOP+BACK);

    // Hook
    xcopies(n=3, l=tray_w-hook_d) {
        move([0, 0, chamfer]) cuboid([hook_d, hook_d, hook_h+chamfer], anchor=BACK+TOP, chamfer=chamfer, edges=[FRONT+RIGHT, FRONT+LEFT]);
        move([0, 0, -hook_h]) ycyl(h=hook_l, d=hook_d, anchor=BACK);
        move([0, -hook_l, -hook_h]) sphere(d=sqrt(2)*hook_d);
    }
}
