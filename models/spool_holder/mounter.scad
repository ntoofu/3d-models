include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

$fn = 32;

beam_w = 20.0;
beam_center_w = 7.3;
beam_corner_w = 3.7;
beam_edge_t = 1.6;
beam_edge_chamfer = 0.5;
beam_diag_t = 1.4;
beam_slit_d = 6.5;
screw_head_w = 9.0;
screw_head_h = 1.5;

t = 3.0;
w = 15.0;
l = 20.0;
top_w = 15.0;
top_d = 35.0;
tapping_d = 2.7;
clearance = 0.15;
slit_xy = 0.5;
slit_z = 0.3;
chamfer = 0.5;
_ = 0.1;

hook_h = (beam_w - beam_center_w) / 2;
hook_w = beam_w - beam_corner_w * 2;
hook_top_w = beam_center_w - 2 * beam_diag_t / sqrt(2);
hook_path = [
        [beam_center_w / 2 + clearance                                 , -hook_top_w / 2                                               ],
        [beam_w / 2 - beam_corner_w + beam_diag_t / sqrt(2) + clearance, -hook_w / 2 + clearance                                       ],
        [beam_w / 2 - beam_edge_t - clearance                          , -hook_w / 2 + clearance                                       ],
        [beam_w / 2 - beam_edge_t - clearance                          , -beam_slit_d / 2 + clearance                                  ],
        [beam_w / 2 - beam_edge_t - clearance + beam_edge_chamfer      , -beam_slit_d / 2 + clearance                                  ],
        [beam_w / 2 + clearance                                        , -beam_slit_d / 2 - beam_edge_t - clearance + beam_edge_chamfer],
        [beam_w / 2 + clearance                                        , beam_slit_d / 2 + beam_edge_t + clearance - beam_edge_chamfer ],
        [beam_w / 2 - beam_edge_t - clearance + beam_edge_chamfer      , beam_slit_d / 2 - clearance                                   ],
        [beam_w / 2 - beam_edge_t - clearance                          , beam_slit_d / 2 - clearance                                   ],
        [beam_w / 2 - beam_edge_t - clearance                          , hook_w / 2 - clearance                                        ],
        [beam_w / 2 - beam_corner_w + beam_diag_t / sqrt(2) + clearance, hook_w / 2 - clearance                                        ],
        [beam_center_w / 2 + clearance                                 , hook_top_w / 2                                                ],
];

module hex_pillar(id, h) {
    extrude_from_to([0, 0, -h/2], [0, 0, h/2])
        hexagon(id=id, realign=false);
}

module mount() {
    mount_shape = union(
        [
            difference(
                [
            move([0, -beam_w / 2], rect([beam_w + (t + clearance) * 2, beam_w + t + clearance], anchor=FRONT)),
            move([0, -beam_w / 2 - _], rect([beam_w + clearance * 2, beam_w + clearance + _], anchor=FRONT)),
            move([0, beam_w / 2 + clearance + screw_head_h - _], rect([screw_head_w, screw_head_h + _], anchor=BACK))
                ]
            ),
            hook_path,
            xflip(hook_path)
        ]
    );
    difference() {
        offset_sweep(mount_shape, height=w, convexity=5, top=os_chamfer(width=chamfer), bottom=os_chamfer(width=chamfer));
        move([0, 0, w / 2]) rotate([90, 0, 90]) hex_pillar(id=tapping_d, h=beam_w + (t + clearance) * 2 + _);
    }
}

difference() {
    union() {
        rotate([90, 0, 0]) move([0, 0, -w/2]) mount();
        move([0, 0, beam_w / 2 + t - chamfer + clearance]) {
            prismoid(size1=[beam_w + (t + clearance) * 2, w], size2=[top_d, top_w], h=l, chamfer=chamfer);
            move([0, 0, l]) cuboid([top_d, top_w, chamfer], edges=[TOP, FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT], chamfer=chamfer, anchor=BOTTOM);
        }
    }
    xflip_copy() move([beam_w / 2 + t / 2, 0, beam_w / 2 + t + clearance + l / 2 + _]) hex_pillar(id=tapping_d, h=l);
    move([0, 0, beam_w / 2 + t - chamfer + t + clearance])
        prismoid(size1=[beam_w/2 + (t + clearance), w+_], size2=[top_d/2, top_w+_], h=l-3*t);
}
