include <BOSL2/std.scad>

$fn = 32;

beam_w = 20.0;
beam_center_w = 7.3;
beam_corner_w = 3.7;
beam_edge_t = 1.6;
beam_diag_t = 1.4;
beam_slit_d = 6.5;
screw_head_w = 9.0;
screw_head_h = 1.5;
bearing_od = 22.0;
bearing_t = 7.0;

t = 3.0;
w = 20.0;
l = 120.0;
tapping_d = 2.7;
clearance = 0.1;
slit_xy = 0.5;
slit_z = 0.3;
_ = 0.1;

hook_h = (beam_w - beam_center_w) / 2;
hook_w = beam_w - beam_corner_w * 2;
hook_top_w = beam_center_w - 2 * beam_diag_t / sqrt(2);
hook_path = [
        [beam_center_w / 2 + clearance                                 , -hook_top_w / 2             ],
        [beam_w / 2 - beam_corner_w + beam_diag_t / sqrt(2) + clearance, -hook_w / 2 + clearance     ],
        [beam_w / 2 - beam_edge_t - clearance                          , -hook_w / 2 + clearance     ],
        [beam_w / 2 - beam_edge_t - clearance                          , -beam_slit_d / 2 + clearance],
        [beam_w / 2 + clearance                                        , -beam_slit_d / 2 + clearance],
        [beam_w / 2 + clearance                                        ,  beam_slit_d / 2 - clearance],
        [beam_w / 2 - beam_edge_t - clearance                          ,  beam_slit_d / 2 - clearance],
        [beam_w / 2 - beam_edge_t - clearance                          ,  hook_w / 2 - clearance     ],
        [beam_w / 2 - beam_corner_w + beam_diag_t / sqrt(2) + clearance,  hook_w / 2 - clearance     ],
        [beam_center_w / 2 + clearance                                 ,  hook_top_w / 2             ],
];

module hex_pillar(id, h) {
    extrude_from_to([0, 0, -h/2], [0, 0, h/2])
        hexagon(id=id, realign=false);
}

module mount() {
    difference() {
        linear_extrude(height=w, center=false, convexity=5, slices=10)
            union() {
                difference() {
                    move([0, -beam_w / 2])
                        rect([beam_w + (t + clearance) * 2, beam_w + t + clearance], anchor=FRONT);
                    move([0, -beam_w / 2 - _])
                        rect([beam_w + clearance * 2, beam_w + clearance + _], anchor=FRONT);
                    move([0, beam_w / 2 + clearance + screw_head_h - _])
                        rect([screw_head_w, screw_head_h + _], anchor=BACK);
                }
                xflip_copy() region(hook_path);
            }
        move([0, 0, w / 2]) rotate([90, 0, 90]) hex_pillar(id=tapping_d, h=beam_w + (t + clearance) * 2 + _);
    }
}

difference() {
    union() {
        mount();
        move([0, beam_w / 2 + t + clearance, 0])
            cuboid([beam_w + (t + clearance) * 2, l, w], anchor=FRONT+BOTTOM);
    }
    move([0, l + beam_w / 2 + clearance, w + _]) cyl(d=bearing_od + 2 * clearance, h=bearing_t + _, anchor=TOP);
    move([0, l + beam_w / 2 + clearance, w + _]) cuboid([bearing_od + 2 * clearance, t + _, bearing_t + _], anchor=TOP+FRONT);
    move([0, l + beam_w / 2 + clearance, -_]) cyl(d=bearing_od - t * 2, h=w + _, anchor=BOTTOM);
    move([0, l + beam_w / 2 + clearance, -_]) cuboid([bearing_od - t * 2, t + _, w + _], anchor=BOTTOM+FRONT);
    move([0, l + beam_w / 2 + clearance - bearing_od / 2 - l * 0.2, w / 2]) hex_pillar(id=tapping_d, h=w + _);
    move([0, l + beam_w / 2 + clearance - bearing_od / 2 - l * 0.2, -_]) cuboid([slit_xy, l * 0.2 + t + _, slit_z], anchor=BOTTOM+FRONT);
}
