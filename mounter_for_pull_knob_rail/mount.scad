include <BOSL2/std.scad>

top_trench_w = 3.1;
top_trench_h = 4.0;
top_front_wall = 2.0;
bottom_trench_w = 5.8;
bottom_trench_h = 1.7;
bottom_slope_rate = 0.30;
bottom_front_wall = 3.0;
h = 18.2;
back_t = 3.0;

chamfer = 0.5;
_ = 0.05;
$fn = 40;


module mount(width, front_t) {
    function accumlate(initial, delta) = len(delta) == 0 ? initial :
        let(last = initial[len(initial)-1]) accumlate(concat(initial, [last+delta[0]]), [for (i=[1:1:len(delta)-1]) delta[i]]);

    function angle_2d(vec) = atan2(vec[1], vec[0]);

    path_diff = [
        [0, -top_front_wall-top_trench_h-h-bottom_trench_h-bottom_front_wall],
        [-front_t, 0],
        [0, bottom_front_wall],
        [-bottom_trench_h, bottom_trench_h],
        [-bottom_trench_w+2*bottom_trench_h, 0],
        [-bottom_trench_h, -bottom_trench_h],
        [-back_t, bottom_slope_rate*back_t],
        [0, -bottom_slope_rate*back_t+bottom_trench_h+h+top_trench_h],
        [back_t+bottom_trench_w-top_trench_w, 0],
        [0, -top_trench_h],
        [top_trench_w, 0],
        [0, top_trench_h+top_front_wall],
    ];
    path = accumlate([[0, 0]], path_diff);
    difference() {
        move([0, 0 , -width/2])
                linear_extrude(height=width, convexity=10) polygon(path);
        zflip_copy(offset=width/2)
            for(i=[0:len(path)-1]) {
                prev = (i - 1 + len(path)) % len(path);
                next = (i + 1) % len(path);
                ang_p = angle_2d(path[i]-path[prev]);
                ang_n = angle_2d(path[next]-path[i]);
                ang_diff = (ang_n - ang_p + 360) % 360 - 180;
                if(ang_diff > 0) {
                } else {
                    move([each path[i], 0]) rotate([0, 0, ang_p-90]) pie_slice(ang=180-abs(ang_diff), l=chamfer, r1=0, r2=chamfer, anchor=TOP);
                }
                move([each (path[i]+path[next])/2, 0]) chamfer_edge_mask(l=norm(path[next]-path[i]), chamfer=chamfer, orient=[each path[next]-path[i], 0], spin=angle_2d(path[next]-path[i]), excess=0);
            }
    }
}

function mount_h() = top_front_wall+top_trench_h+h+bottom_trench_h+bottom_front_wall;

mount(front_t=4.0);
