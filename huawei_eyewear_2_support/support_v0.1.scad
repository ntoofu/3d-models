include <BOSL2/std.scad>

temple_w = 7.7;
temple_h = 8.5;

l = 10.0;
t_wall = 2.0;
t_inside = 1.0;
tightness = 0.1;
support_t = 4.0;
support_l = 35.0;

chamfer = 0.8;
_ = 0.1;

difference() {
    cuboid([l, temple_h + 2 * t_wall, temple_w + t_wall + t_inside], anchor=BOTTOM, chamfer=chamfer, edges=[BACK, TOP, BOTTOM+RIGHT, BOTTOM+LEFT]);
    move([0, 0, t_wall]) rotate([0, -90, 0]) cuboid([temple_w, temple_h, l + _], anchor=LEFT, chamfer=-chamfer, edges=[TOP+LEFT, TOP+FRONT, TOP+BACK, BOTTOM+LEFT, BOTTOM+FRONT, BOTTOM+BACK]);
}

// move([0, -temple_h / 2 - t_wall, 0]) cuboid([l, _, support_t], anchor=BOTTOM+BACK, chamfer=chamfer, edges=[BOTTOM+RIGHT, BOTTOM+LEFT, TOP+RIGHT, TOP+LEFT]);


function xlated_ang(x, y, angle) = 90 + atan(tan(angle)*y/x);
function stretched_teardrop(x, y, angle, n) = [[x/2 * sin(-xlated_ang(x, y, angle)) + y/2 * (cos(-xlated_ang(x, y, angle)) + 1) / tan(angle), -y/2], for (i=[0:n]) [x/2 * sin(xlated_ang(x, y, angle) * (2 * i / n - 1)), y/2 * cos(xlated_ang(x, y, angle) * (2 * i / n - 1))], [x/2 * sin(xlated_ang(x, y, angle)) - y/2 * (cos(xlated_ang(x, y, angle)) + 1) / tan(angle), -y/2]];

// stroke(stretched_teardrop(20, 10, 30, 32), closed=true);

module support() {
    n = 16;
    vnf = vnf_vertex_array(
            points=[for(i=[0:n]) apply(up(support_l * i/n), path3d(stretched_teardrop(l-(l-support_t)*i/n, support_t, 45, 32)))],
            col_wrap=true, caps=true);
    vnf_polyhedron(vnf);
}

move([0, -temple_h / 2 - t_wall, support_t/2]) rotate([90, 0, 0]) support();
