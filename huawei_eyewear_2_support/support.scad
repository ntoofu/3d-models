include <BOSL2/std.scad>
include <BOSL2/beziers.scad>

temple_w = 7.7;
temple_h = 8.5;

l = 10.0;
t_wall = 2.0;
t_inside = 1.0;
tightness = 0.9;
support_t = 4.0;
support_a_ang = 25;
support_a_rot = [90, 100, 95];
support_a_radius = 50.0;
support_b_ang = 20;
support_b_rot = [45, 0, 75];
support_b_radius = 35.0;

chamfer = 0.8;
support_path_res = 20;
_ = 0.1;

total_w = temple_w + t_wall + t_inside;
bend_point_ratio = support_a_ang / (support_a_ang + support_b_ang);

module temple_ring() {
    difference() {
        cuboid([total_w, temple_h + 2 * t_wall, l], anchor=LEFT+BOTTOM, chamfer=chamfer, edges=[FRONT, TOP+LEFT, TOP+RIGHT, BOTTOM+LEFT, BOTTOM+RIGHT, BACK+RIGHT]);
        move([t_inside + tightness / 2, 0, -_]) cuboid([temple_w-tightness, temple_h-tightness, l + 2* _], anchor=LEFT+BOTTOM, chamfer=-chamfer);
    }
}

module support() {
    a_tang_vec = (rot(support_a_rot) * [-sin(support_a_ang), cos(support_a_ang), 0, 1]);
    b_tang_vec = (rot(support_b_rot) * [0, 1, 0, 1]);
    a_path = rot(support_a_rot, p=path3d(arc(r=support_a_radius, angle=support_a_ang, $fn=128)));
    b_path = rot(from=b_tang_vec, to=a_tang_vec, p=rot(support_b_rot, p=path3d(arc(r=support_b_radius, angle=support_b_ang, $fn=128))));
    support_path = [
        [0, -_, 0],
        each move(-a_path[0], p=a_path),
        each move(-b_path[0]-a_path[0]+a_path[len(a_path)-1], p=[for (i=[1:len(b_path)-1]) b_path[i]]),
    ];
    path_extrude(support_path)
            scale([1, 1.5]) circle(d=support_t, $fn=32);
    support_bezpath = path_to_bezpath(support_path);
    path_end_bez_curve = [for (i=[-4:-1]) support_bezpath[len(support_bezpath)+i]];
    move(support_path[len(support_path)-1]) rot(from=[0, 1, 0], to=bezier_tangent(path_end_bez_curve, 1)) scale([1, 1, 1.5]) sphere(d=support_t, $fn=32);
}

temple_ring();
move([support_t/2, temple_h / 2 + t_wall, l / 2]) support();
