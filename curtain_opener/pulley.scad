include <BOSL2/std.scad>
include <BOSL2/gears.scad>

$fn = 24;

shaft_d = 3.0;
shaft_support = 5.0;
t = 5.0;
target_d_driven = 33;
target_d_drive = 32;
pitch = 4.0;
heli = 30;
clearance = 0.1;
init_layer = 0.20;

_ = 0.05;

function n_teeth(target_d) = round(target_d/2/pitch_radius(circ_pitch=pitch, teeth=1, helical=heli));

module hex_pillar(od, h) {
    extrude_from_to([0, 0, -h/2], [0, 0, h/2])
        hexagon(od=od, realign=false);
}

module drive() {
    gear_or = outer_radius(circ_pitch=pitch, teeth=n_teeth(target_d_drive), helical=heli);
    gear_pr = pitch_radius(circ_pitch=pitch, teeth=n_teeth(target_d_drive), helical=heli);
    difference() {
        union() {
            spur_gear(circ_pitch=pitch, teeth=n_teeth(target_d_drive), thickness=t, helical=heli, herringbone=true, slices=5, backlash=clearance);
            move([0, 0, t/2]) cyl(h=shaft_support, r=t, anchor=BOTTOM);
        }
        trench_d = gear_or - gear_pr;
        zflip_copy() move([0, 0, -_]) tube(h=trench_d+_, ir1=gear_or-trench_d, or1=gear_or+_, ir2=gear_or, or2=gear_or+_, anchor=BOTTOM, $fn=64);
        move([0, 0, shaft_support/2]) hex_pillar(od=shaft_d+clearance*2, h=t+shaft_support+_);
        move([0, 0, -t/2-_]) cuboid([gear_or, init_layer*2, init_layer+_], anchor=LEFT+BOTTOM);
    }
}

module driven() {
    gear_or = outer_radius(circ_pitch=pitch, teeth=n_teeth(target_d_driven), helical=heli);
    gear_pr = pitch_radius(circ_pitch=pitch, teeth=n_teeth(target_d_driven), helical=heli);
    difference() {
        spur_gear(circ_pitch=pitch, teeth=n_teeth(target_d_driven), thickness=t, shaft_diam=shaft_d+clearance, helical=heli, herringbone=true, slices=5, backlash=clearance);
        trench_d = gear_or - gear_pr;
        zflip_copy() move([0, 0, -_]) tube(h=trench_d+_, ir1=gear_or-trench_d, or1=gear_or+_, ir2=gear_or, or2=gear_or+_, anchor=BOTTOM, $fn=64);
        move([0, 0, -t/2-_]) cuboid([gear_or, init_layer*2, init_layer+_], anchor=LEFT+BOTTOM);
    }
}

dist = gear_dist(circ_pitch=pitch, teeth1=n_teeth(target_d_drive), teeth2=n_teeth(target_d_driven), helical=heli);
echo(dist);

/* drive(); */
/* move([dist, 0, 0]) rotate([0, 180, 0]) */
    driven();
