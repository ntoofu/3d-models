include <BOSL2/std.scad>

trench_w = 4.5;
trench_l = 150.0;
trench_d = 6.0;
rail_h1 = 3.0;
rail_h2 = 4.5;
rail_end = 3.0;
rail_t = 4.0;
top_opened_l1 = 15.0;
top_opened_l2 = 30.0;
top_opened_t = 1.5;
tapping_d = 2.7;
mount_l = 20.0;
mount_w = 10.0;
mount_pos_from_back = 90.0;

chamfer = 0.5;
_ = 0.1;


module hex_pillar(id, h) {
    extrude_from_to([0, 0, -h/2], [0, 0, h/2])
        hexagon(id=id, realign=true);
}


difference() {
    union() {
        cuboid([rail_t + trench_d, trench_l + rail_end, rail_h1 + trench_w + rail_h2], chamfer=chamfer, anchor=RIGHT+FRONT+BOTTOM);
        move([-chamfer, trench_l+rail_end-mount_pos_from_back, 0]) rotate([0, 90, 0]) prismoid(size1=[rail_h2, mount_w*2], size2=[rail_h2, mount_w], h=mount_l+chamfer, anchor=RIGHT+BACK+BOTTOM, chamfer=chamfer);
    }
    move([_, -_, rail_h2]) cuboid([trench_d+_, trench_l+_, trench_w], chamfer=chamfer, anchor=RIGHT+FRONT+BOTTOM, edges=[LEFT+TOP, LEFT+BOTTOM, LEFT+BACK, TOP+BACK, BOTTOM+BACK]);
    move([_, -_, rail_h2+trench_w-chamfer]) prismoid(size1=[trench_d+_, top_opened_l2+_], size2=[trench_d+_, top_opened_l1+_], shift=[0, (top_opened_l1-top_opened_l2)/2], h=rail_h1-top_opened_t+chamfer, anchor=RIGHT+FRONT+BOTTOM);
    move([_, -_, rail_h2+trench_w+rail_h1-top_opened_t-_]) cuboid([trench_d+_, top_opened_l1+_, top_opened_t+2*_], chamfer=-chamfer, anchor=RIGHT+FRONT+BOTTOM, edges=[TOP]);
    move([mount_l-rail_t, trench_l+rail_end-mount_pos_from_back-mount_w, rail_h2/2]) hex_pillar(tapping_d, rail_h2+_);
    move([-trench_d, trench_l+rail_end-mount_pos_from_back-mount_w, rail_h2/2]) hex_pillar(tapping_d, rail_h2+_);
}

/*
spacer_l = 15.0;
move([0, 0.5*trench_l, rail_h2+trench_w+rail_h1-chamfer])
ycopies(n=2, l=0.5*trench_l)
    difference() {
        cuboid([trench_d+rail_t, trench_d+rail_t, spacer_l+chamfer], anchor=RIGHT+BOTTOM, chamfer=chamfer, edges=[TOP, FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]);
        move([-(trench_d+rail_t)/2, 0, (spacer_l+chamfer)/2]) hex_pillar(tapping_d, spacer_l+chamfer+_);
    }
*/
