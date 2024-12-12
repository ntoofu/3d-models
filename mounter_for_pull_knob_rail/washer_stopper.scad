include <BOSL2/std.scad>
use <mount.scad>

w = 15.0;
front_t = 7.0;
mounter_top_to_trench = 24.2;
mounter_top_to_bottom = 28.9;
stopper_y1 = -(47.3 + mounter_top_to_trench + 0.5);
stopper_t = 3.0;
stopper_w = 5.0;
stopper_l = 10.0;
dist = 40.0;
chamfer=0.5;
_ = 0.05;

module hex_pillar(id, h) {
    extrude_from_to([0, 0, -h/2], [0, 0, h/2])
        hexagon(id=id, realign=true);
}

mirror([0,1,0])
difference() {
    union() {
        move([0, 0, -w/2]) mount(width=w, front_t=front_t);
        move([0, stopper_y1, dist]) cuboid([stopper_t, stopper_w, stopper_l], anchor=RIGHT+BACK+BOTTOM, chamfer=chamfer, edges=[TOP]);
        move([-stopper_t, -mounter_top_to_bottom+chamfer, 0]) rotate([90, 0, 0]) prismoid(size1=[front_t-stopper_t-chamfer, w], size2=[0, w], shift=[(front_t-stopper_t-chamfer)/2, 0], h=front_t-stopper_t-chamfer, anchor=RIGHT+BACK+BOTTOM);
        mirror([1, 0, 0]) rotate([90,0,90])
            linear_extrude(height=stopper_t, convexity=10)
                polygon([
                    [-mounter_top_to_bottom+chamfer, -w],
                    [stopper_y1-stopper_w+dist-stopper_w, -w],
                    [stopper_y1-stopper_w, dist-stopper_w],
                    [stopper_y1-stopper_w, dist],
                    [stopper_y1, dist],
                    [stopper_y1+dist, 0],
                    [-mounter_top_to_bottom+chamfer, 0],
                ]);
    }
    move([0, -100-mounter_top_to_bottom+chamfer, -w])rotate([90,0,0]) chamfer_edge_mask(l=200, chamfer=chamfer);
    move([-stopper_t, -100-mounter_top_to_bottom+2*chamfer-front_t+stopper_t, -w])rotate([90,0,0]) chamfer_edge_mask(l=200, chamfer=chamfer);
}
