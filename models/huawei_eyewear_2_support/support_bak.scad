include <BOSL2/std.scad>

temple_w = 7.7;
temple_h = 8.5;

l = 10.0;
t_wall = 2.0;
t_inside = 1.0;
tightness = 0.9;
support_t = 4.0;
support_ang_1 = -20;
support_ang_2 = 10;
support_ang_3 = 30;
support_ang_z = 30;
support_r_yz = 40.0;
support_r_xy = 25.0;

chamfer = 0.8;
support_path_res = 20;
_ = 0.1;

total_w = temple_w + t_wall + t_inside;
bend_point_ratio = (support_ang_2 - support_ang_1) / (support_ang_3 - support_ang_1);

module temple_ring() {
    difference() {
        cuboid([total_w, temple_h + 2 * t_wall, l], anchor=LEFT+BOTTOM, chamfer=chamfer, edges=[FRONT, TOP+LEFT, TOP+RIGHT, BOTTOM+LEFT, BOTTOM+RIGHT, BACK+RIGHT]);
        move([t_inside + tightness / 2, 0, -_]) cuboid([temple_w-tightness, temple_h-tightness, l + 2* _], anchor=LEFT+BOTTOM, chamfer=-chamfer);
    }
}

module support() {
    support_path = [for (i=[0:support_path_res]) [
                if (i / support_path_res < bend_point_ratio) 0 else (1 - cos(support_ang_z * (i / support_path_res - bend_point_ratio) / (1 - bend_point_ratio))) * support_r_xy,
                cos(-90 + support_ang_1 + (support_ang_2 + support_ang_3 - support_ang_1) * i / support_path_res) * support_r_yz,
                sin(-90 + support_ang_1 + (support_ang_2 + support_ang_3 - support_ang_1) * i / support_path_res) * support_r_yz
                ]
            ];
    difference() {
        top_half() back_half()
        move([0, -(support_r_yz - support_t / 2) * sin(support_ang_1), (support_r_yz - support_t / 2) + support_t])
        move(support_path[len(support_path)-1]) rotate([45, 0, 0]) top_half() rotate([-45, 0, 0]) move(-support_path[len(support_path)-1]) union() {
                path_extrude(support_path) union() {
                    rect([support_t, l], anchor=FRONT);
                    intersection() {
                        circle(d=support_t, $fn=16);
                        rect([support_t, support_t / 2], anchor=BACK);
                    }
                }
                move(support_path[len(support_path)-1]) sphere(d=support_t, $fn=16);
            }
        xflip_copy() move([support_t/2, support_r_yz, 0]) chamfer_edge_mask(l=support_r_yz * 2, chamfer=chamfer, orient=FRONT);
    }
}

temple_ring();
move([support_t/2, temple_h/2+t_wall, 0]) xflip() support();

/*
difference() {
    union() {
        cuboid([total_w, support_l1, l], chamfer=chamfer, edges=[BOTTOM+LEFT, BOTTOM+RIGHT], anchor=FRONT);
        move([0, support_l1, 0]) rotate([90, 0, 180]) prismoid(size1=[total_w, l], size2=[total_w, l], shift=[0, support_l2], h=support_l2, chamfer=chamfer);
    }
    move([0, support_l1/2, support_l1]) rotate([0, 90, 0]) cyl(h=total_w+_, r=support_l1, rounding=-total_w/2);
}
*/
