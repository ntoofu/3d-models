include <BOSL2/std.scad>
include <BOSL2/gears.scad>

$fn = 24;

shaft_d = 5.0;
t = 4.0;
chamfer = 0.5;
target_d_gear1 = 73.5;
target_d_gear2 = 122.5;
pitch = 18.5;
clearance = 0.3;
heli = 0;
init_layer = 0.20;

_ = 0.05;

function n_teeth(target_d) = round(target_d/2/pitch_radius(circ_pitch=pitch, teeth=1, helical=heli));

module chamfer_cap(reg, chamfer) {
    path = path3d(offset(reg, delta=0), fill=0);
    shrinked_path = path3d(offset(reg, delta=-chamfer), fill=chamfer);
    vnf = vnf_vertex_array(
            points=[
                resample_path(path,          len(path), keep_corners=45),
                resample_path(shrinked_path, len(path), keep_corners=45)],
            col_wrap=true, caps=true);
    vnf_polyhedron(vnf);
}

module tightening_hole(d, h, chamfer) {
    l = d / sqrt(3);
    slit_d = l / 3;
    union() {
        linear_extrude(height=h) union() {
            hexagon(id=d);
            zrot_copies(n=6) move([l/2, -d/2]) move([l/2, slit_d/2])
                glued_circles(d=slit_d, spread=l, tangent=0);
        }
    }
    cyl(d1=d+chamfer*2, d2=d, h=chamfer, anchor=BOTTOM);
    move([0, 0, h]) cyl(d1=d, d2=d+chamfer*2, h=chamfer, anchor=TOP);
}

module gear(target_d) {
    gear_or = outer_radius(circ_pitch=pitch, teeth=n_teeth(target_d), helical=heli);
    difference() {
        union() {
            spur_gear(circ_pitch=pitch, teeth=n_teeth(target_d), thickness=t-2*chamfer, helical=heli, herringbone=true, slices=5, backlash=clearance);
            zflip_copy() move([0, 0, t / 2 - chamfer])
                chamfer_cap(spur_gear2d(circ_pitch=pitch, teeth=n_teeth(target_d), helical=heli, backlash=clearance), chamfer);
            move([0, 0, t/2]) cyl(d=target_d * 0.45, h=t+clearance, anchor=BOTTOM);
        }
        move([0, 0, -t/2-_]) tightening_hole(d=shaft_d*0.95, h=2*t+clearance+2*_, chamfer=chamfer);
        move([target_d*0.3, 0, t/2+_]) cyl(d1=8, d2=10, h=t/2, anchor=TOP);
        move([0, 0, -t/2-_]) cuboid([gear_or, init_layer*2, init_layer+_], anchor=LEFT+BOTTOM);
    }
}

module gear2(d1, d2) {
    gear_or = outer_radius(circ_pitch=pitch, teeth=n_teeth(d1), helical=heli);
    difference() {
        union() {
            spur_gear(circ_pitch=pitch, teeth=n_teeth(d1), thickness=t-2*chamfer, helical=heli, herringbone=true, slices=5, backlash=clearance);
            zflip_copy() move([0, 0, t / 2 - chamfer])
                chamfer_cap(spur_gear2d(circ_pitch=pitch, teeth=n_teeth(d1), helical=heli, backlash=clearance), chamfer);
            move([0, 0, t])
                spur_gear(circ_pitch=pitch, teeth=n_teeth(d2), thickness=t-chamfer+clearance, helical=heli, herringbone=true, slices=5, backlash=clearance);
            move([0, 0, t*3/2+clearance-chamfer]) chamfer_cap(spur_gear2d(circ_pitch=pitch, teeth=n_teeth(d2), helical=heli, backlash=clearance), chamfer);
        }
        move([0, 0, -t/2-_]) tightening_hole(d=shaft_d*0.95, h=2*t+clearance+2*_, chamfer=chamfer);
        move([0, 0, -t/2-_]) cuboid([gear_or, init_layer*2, init_layer+_], anchor=LEFT+BOTTOM);
    }
}

/*
// finding appropriate pitch
nt1=n_teeth(target_d_gear1);
nt2=n_teeth(target_d_gear2);
for(p=[15:0.5:25]) {
    echo("-----");
    echo(p);
    echo(gear_dist(circ_pitch=p, teeth1=nt1, teeth2=nt1, helical=heli));
    echo(gear_dist(circ_pitch=p, teeth1=nt1, teeth2=nt2, helical=heli));
    echo(gear_dist(circ_pitch=p, teeth1=nt2, teeth2=nt2, helical=heli));
}
*/

gear(target_d_gear1);
/* gear(target_d_gear2); */
/* gear2(target_d_gear2, target_d_gear1); */
