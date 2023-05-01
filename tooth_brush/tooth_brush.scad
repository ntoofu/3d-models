include <BOSL2/std.scad>


n = 2;
t = 2.0;
pocket_d = 7.5;
hook_d = 3.5;
/* height = 52.0; */
depth = 20.0;
beam_dist = 44.0;

height = beam_dist+hook_d+2*t;
pocket_w = pocket_d + 2 * t;
w = pocket_w * n;

EPSILON=0.01;

module hook() {
    union() {
        move(y=-hook_d-t) {
            rotate([0, 90, 0])
                intersection() {
                    tube(ir=hook_d, wall=t, h=w, anchor=CENTER);
                    pie_slice(ang=90, r=hook_d+t+EPSILON, h=w+EPSILON, anchor=CENTER);
                }
            move(y=EPSILON, z=-hook_d) cuboid([w, hook_d * 0.5, t], anchor=TOP+BACK);
        }
    }

}

module holder() {
    prismoid(size1=[pocket_d, t], size2=[0, 0], h=pocket_d, shift=[0,-pocket_d*0.6], anchor=FRONT+BOTTOM);
    move(y=t, z=-t) rotate([-90,0,0]) rect_tube(isize=pocket_d, wall=t, h=t, anchor=BACK+BOTTOM);
    move(y=t+depth, z=-t) rotate([-90,0,0]) rect_tube(isize=pocket_d, wall=t, h=t, anchor=BACK+BOTTOM);
}

union() {
    cuboid([w, height, t], anchor=BOTTOM+BACK);
    move(z=EPSILON) hook();
    /* move(y=-beam_dist, z=EPSILON) hook(); */
    move(y=-beam_dist, z=EPSILON) cuboid([w, t, hook_d+EPSILON], anchor=TOP+BACK);
    move(y=-beam_dist-hook_d-t, z=EPSILON) cuboid([w, t, hook_d+EPSILON], anchor=TOP+BACK);
    for(i=[-(n-1):2:(n-1)]) {
        move([pocket_w / 2 * i,-0.6*height,t-EPSILON]) holder();
    }
}
