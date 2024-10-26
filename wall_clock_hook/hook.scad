include <BOSL2/std.scad>

stapler_layer_t = 0.35;
stapler_area_w = 13.0;
stapler_area_l = 9.0;
chamfer = 0.5;
base_d = 50.0;
base_t = 3.0;
hook_d = 20.0;
hook_t = 2.0;
top_d = 25.0;
top_t = 3.0 + chamfer * 2;

_ = 0.05;
$fn=50;

union() {
    difference() {
        cyl(d=base_d, h=base_t, anchor=BOTTOM, chamfer2=chamfer);
        rot_copies(n=4, v=TOP) move([base_d/2-stapler_area_l,0,stapler_layer_t]) cuboid([stapler_area_l+_, stapler_area_w, base_t], anchor=LEFT+BOTTOM, chamfer=chamfer, edges=[LEFT+FRONT, LEFT+BACK, LEFT+BOTTOM, BOTTOM+FRONT, BOTTOM+BACK]);
    }
    move([0,0,base_t]) {
        cyl(d=hook_d, h=hook_t, anchor=BOTTOM);
        move([0,0,hook_t]) intersection() {
            cyl(d1=hook_d, d2=top_d, h=top_t, anchor=BOTTOM, chamfer2=chamfer);
            union() {
                cuboid([hook_d, top_d, top_t], anchor=FRONT+BOTTOM, chamfer=chamfer, edges=[TOP]);
                cyl(d=hook_d, h=top_t, anchor=BOTTOM, chamfer2=chamfer);
            }
        }
    }
}
