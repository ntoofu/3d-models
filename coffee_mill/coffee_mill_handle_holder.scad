include <BOSL2/std.scad>


t = 2.0;
depth = 7.0;
mill_d = 46.5;
brim = 6.0;
handle_w = 15.0;
handle_t = 2.5;
clearance = 0.5;

_ = 0.01;

difference() {
    union() {
        tube(od=mill_d+_, wall=brim, h=t, $fn=128);
        difference() {
            union() {
                tube(id=mill_d, wall=t, h=depth+t, $fn=128);
                move(x=mill_d/2) cuboid([handle_t+clearance+t, handle_w+clearance+2*t, t+depth], anchor=LEFT+BOTTOM);
            }
            move(x=mill_d/2, z=-_) cuboid([handle_t+clearance, handle_w+clearance, t+depth+2*_], anchor=LEFT+BOTTOM);
            move(z=t-_) cuboid([mill_d/2+_, handle_w+clearance, depth+2*_], anchor=LEFT+BOTTOM);
        }
    }
    move(z=-_) cuboid([mill_d/2+handle_t+2*t+_, clearance, t+depth+2*_], anchor=LEFT+BOTTOM);
}
