include <BOSL2/std.scad>

plate_w = 210.0;
plate_h = 60.0;
plate_t = 2.5;
plate_t_min = 0.35;
stapler_space_h = 10.0;
stapler_space_w = 15.0;
latch_dist = 185.5;
chamfer = 0.5;
_ = 0.1;


module latch() {
    w1 = 7.0;
    w2 = 5.0;
    t = 2.5;
    arm_t = 2.5;
    arm_w = 4.0;
    h = 22.0;
    bottom_t = 2.0;
    union() {
        move([0, 0, arm_t])
            rotate([-90, 0, 0])
                prismoid(size1=[w1, t], size2=[w2, t], shift=[(w2-w1)/2, 0], h=h, anchor=LEFT+BACK+BOTTOM);
        cuboid([arm_w, h, arm_t], anchor=LEFT+FRONT+BOTTOM);
    }
    cuboid([w1, bottom_t, arm_t], anchor=LEFT+FRONT+BOTTOM);
}

difference() {
    cuboid([plate_w, plate_h, plate_t], chamfer=chamfer, anchor=BOTTOM);
    yflip_copy()
        move([0, -plate_h/2, plate_t_min])
            xcopies(n=2, l=plate_w-3*stapler_space_w)
                cuboid([stapler_space_w, stapler_space_h, plate_t], chamfer=chamfer, edges=[BOTTOM+BACK, BOTTOM+LEFT, BOTTOM+RIGHT], anchor=FRONT+BOTTOM);
    ycopies(l=plate_h) cuboid([plate_w * 0.6, plate_h * 0.6, plate_t], chamfer=-chamfer, anchor=BOTTOM);
}

xflip_copy()
    move([latch_dist/2, -plate_h/2, plate_t])
        latch();