include <BOSL2/std.scad>

t = 5.0;
inner_oring_id = 60.0;
inner_oring_t = 3.0;
outer_oring_id = 80.0;
outer_oring_t = 3.0;
outer_oring_curve_r = 1000;
hose_od = 19.0;
hose_hole_l = 10.0;
hose_hole_d_diff_max = 1.0;
hose_hole_d_diff_min = -0.3;
hose_hole_pos_angle = 120;
overhang_ratio = 0.8;
outer_d = outer_oring_id + outer_oring_t + t;
bath_inlet_t = 10.7;
bath_inlet_d = 70.0;
latch_w = 2.0;
latch_h = 1.5;
latch_pos = [15, 55, 154]/219*360;
latch_base_h = (outer_oring_id+outer_oring_t-t-bath_inlet_d)/2;
latch_gap = 6.0;
space_filler_angle = 15;
outer_shell_bottom_h = outer_oring_t * 1.5;
inner_shell_bottom_h = inner_oring_t;
hose_hole_bottom_z = (bath_inlet_t + outer_shell_bottom_h + inner_shell_bottom_h + hose_od / overhang_ratio) / 2;
inner_shell_h = hose_hole_bottom_z - bath_inlet_t - inner_shell_bottom_h;
rot_fn = 64;
chamfer = 0.5;
_ = 0.05;

module oring_holder(id, t, w, ratio=2/3) {
    a = atan(2 * ratio - 1);
    p = [
            [cos(a), sin(a)] * t / 2,
            [cos(a) + (1 + sin(a)) * tan(a), -1] * t / 2,
            [-cos(a) - (1 + sin(a)) * tan(a), -1] * t / 2,
            [-cos(a), sin(a)] * t / 2,
        ];
    rotate_extrude($fn=rot_fn)
        move([(id+t)/2, t/2, 0])
            difference() {
                move([0, -t/2]) rect(size=[w, t*ratio - _], anchor=BOTTOM);
                polygon(points=p);
            }
}

module oring_holder2(id, t, w, h, curve_r=0, ratio=2/3) {
    function cs(a) = let(
        oring_stop_ang = atan(2 * ratio - 1),
        r = (id + t) / 2,
        oring_stop_path = [
                [w / 2, sin(oring_stop_ang) * t / 2],
                [cos(oring_stop_ang), sin(oring_stop_ang)] * t / 2,
                [cos(oring_stop_ang) + sin(oring_stop_ang) * tan(oring_stop_ang), 0] * t / 2,
                [1, -1] * t / 2,
                [-1, -1] * t / 2,
                [-cos(oring_stop_ang) - sin(oring_stop_ang) * tan(oring_stop_ang), 0] * t / 2,
                [-cos(oring_stop_ang), sin(oring_stop_ang)] * t / 2,
                [-w / 2, sin(oring_stop_ang) * t / 2],
            ],
        x = r * cos(a),
        theta = curve_r == 0 ? 0 : asin(x/curve_r),
        path = right(r, [[w/2, -h], each [for (i = [0:len(oring_stop_path)-1]) oring_stop_path[i] + [0, curve_r * (cos(theta)-1)]], [-w/2, -h]])
        )
        up(h, zrot(a, xrot(90, path3d(path))));
    num_steps = 60;
    paths = [for (i = [0 : num_steps-1]) cs(i * 360 / num_steps)];
    // for (i = [0 : num_steps-1]) stroke(paths[i]);
    skin(paths, slices=0, closed=true);
}

module wall_latch() {
    s = 1.0;
    rotate([90, 0, 0])
        prismoid(size1=[latch_w, latch_w + latch_base_h * s], size2=[latch_w, latch_w - latch_h * s], h=latch_base_h+latch_h, shift=[0, (latch_h + latch_base_h) * s/2], anchor=BACK+BOTTOM);
}

module hole_shape(l, d_loose, d_tight, n) {
    down(l) union() {
        for(i = [0:n-1]) {
            up(i * l / n) {
                cyl(d1=d_loose, d2=d_tight, h=l/n/2+_, anchor=BOTTOM, $fn=rot_fn);
                up(l/n+_) cyl(d1=d_tight, d2=d_loose, h=l/n/2+_, anchor=TOP, $fn=rot_fn);
            }
        }
    }
}

module inner_shell() {
    move([0, 0, -bath_inlet_t]) {
        move([0, 0, -inner_oring_t]) difference() {
            cyl(d1=inner_oring_id+inner_oring_t+t-overhang_ratio*inner_shell_h*2, d2=inner_oring_id+inner_oring_t+t, h=inner_shell_h, anchor=TOP, $fn=rot_fn);
            cyl(d1=inner_oring_id+inner_oring_t-t-overhang_ratio*inner_shell_h*2, d2=inner_oring_id+inner_oring_t-t, h=inner_shell_h+_, anchor=TOP, $fn=rot_fn);
        }
        move([0, 0, -inner_oring_t]) oring_holder2(id = inner_oring_id, t = inner_oring_t, h = inner_oring_t, w = t);
    }
}

module outer_shell() {
    move([0, 0, -outer_shell_bottom_h]) oring_holder2(id = outer_oring_id, t = outer_oring_t, w = t, h = outer_shell_bottom_h, curve_r = outer_oring_curve_r);
    for (pos = latch_pos)
        rotate([0, 0, -pos])
            move([0, (outer_oring_id+outer_oring_t-t)/2, -latch_gap])
                wall_latch();
    intersection() {
        union() {
            tube(od=outer_oring_id, id=bath_inlet_d, h=t, anchor=TOP, $fn=rot_fn);
            move([0, 0, -t]) tube(od=outer_oring_id, id1=outer_oring_id, id2=bath_inlet_d, h=(outer_oring_id-bath_inlet_d)/2, anchor=TOP, $fn=rot_fn);
        }
        rotate([0, 0, -90-space_filler_angle/2]) pie_slice(ang=space_filler_angle, d=outer_oring_id, h=(outer_oring_id-bath_inlet_d)/2+t, anchor=TOP, $fn=rot_fn);
    }
    h2 = hose_hole_bottom_z - outer_shell_bottom_h;
    move([0, 0, -outer_shell_bottom_h])
        rotate([0, 0, hose_hole_pos_angle])
            difference(){
                union () {
                    cyl(d=outer_oring_id+outer_oring_t+t, h=h2, anchor=TOP, $fn=rot_fn);
                    skew(sxz=-overhang_ratio) right((outer_oring_id+outer_oring_t-hose_od-t)/2) cyl(d=hose_od+2*t, h=h2, anchor=TOP);
                }
                cyl(d=outer_oring_id+outer_oring_t-t, h=h2+_, anchor=TOP, $fn=rot_fn);
                skew(sxz=-overhang_ratio) right((outer_oring_id+outer_oring_t-hose_od-t)/2) cyl(d=hose_od, h=h2+_, anchor=TOP);
            }
}

module cap() {
    down(hose_hole_bottom_z) {
        inner_narrowed_d = inner_oring_id + inner_oring_t - overhang_ratio * inner_shell_h * 2;
        difference() {
            union() {
                tube(od=outer_oring_id+outer_oring_t+t, id=outer_oring_id+outer_oring_t-t, h=hose_hole_l, anchor=TOP, $fn=rot_fn);
                tube(od=inner_narrowed_d+t, id=inner_narrowed_d-t, h=hose_hole_l, anchor=TOP, $fn=rot_fn);
                cyl(d=hose_od+2*t, h=hose_hole_l, anchor=TOP, $fn=rot_fn);
                rotate([0, 0, hose_hole_pos_angle])
                    right(overhang_ratio * (hose_hole_bottom_z - outer_shell_bottom_h) + (outer_oring_id + outer_oring_t - t - hose_od)/2)
                        cyl(d=hose_od+2*t, h=hose_hole_l, anchor=TOP, $fn=rot_fn);
                down(hose_hole_l) cyl(d=outer_oring_id+outer_oring_t+t, h=t, anchor=BOTTOM, $fn=rot_fn);
            }
            rotate([0, 0, hose_hole_pos_angle])
                right(overhang_ratio * (hose_hole_bottom_z - outer_shell_bottom_h) + (outer_oring_id + outer_oring_t - t - hose_od)/2)
                    hole_shape(l=hose_hole_l, d_tight=hose_od+hose_hole_d_diff_min, d_loose=hose_od+hose_hole_d_diff_max, n=3);
            hole_shape(l=hose_hole_l, d_tight=hose_od+hose_hole_d_diff_min, d_loose=hose_od+hose_hole_d_diff_max, n=3);
            move([0, outer_oring_id/2, -hose_hole_l]) linear_extrude(h=0.1*t) star(n=1.5, r=t, align_tip=[0,1], anchor=BACK);
        }
    }
}

inner_shell();
outer_shell();
cap();
