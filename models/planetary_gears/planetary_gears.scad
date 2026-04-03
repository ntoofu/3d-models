include <BOSL2/std.scad>
include <BOSL2/gears.scad>
include <BOSL2/math.scad>

_ = 0.01;
$fn = 128;

shaft_d = 3.0;
gap_free = 0.3;
gap_fixed = 0.1;
ps_r = 1.5;
t = 3.0;
tap_hole_d = 3.2;

z_sun = 21;
z_p1 = 19;
z_o1 = 59;
n1 = 2;
z_p2 = 21;
z_o2 = 63;
n2 = 3;
pitch = 5;

height_offset = 15;
hole_distance = 15;

module hex_pillar(d, l) {
    move(z=-l/2) rotate([0, -90, 0])
        path_extrude2d(path=[[0, 0], [l, 0]]) hexagon(or=d/2);
}

module sun_gear() {
    difference() {
        spur_gear(pitch=pitch, teeth=z_sun, thickness=t*3);
        hex_pillar(d=shaft_d + gap_fixed, l=t*3+_);
    }
}

module outer_gear(z) {
    r = outer_radius(pitch=pitch, teeth=z);
    union() {
        difference() {
            cyl(r=r+t, l=t);
            rotate([0,0,360/z/2]) spur_gear(pitch=pitch, teeth=z, thickness=t+_);
        }
        move(z=-t/2) tube(ir=r-pitch/2, or=r+t, h=2*t, anchor=TOP);
        move(z=-t/2) tube(id=shaft_d+gap_free, od=2*shaft_d, h=2*t, anchor=TOP);
        move(z=-t*3/2)
            difference() {
                intersection() {
                    union() {
                        for(a=[0:60:360-_]) {
                            rotate([0, 0, a]) difference() {
                                cuboid([r+t, shaft_d*3, t], anchor=TOP+LEFT);
                                move(x=hole_distance, z=_) cyl(d=shaft_d+gap_fixed, h=t+2*_, anchor=TOP);
                            }
                        }
                    }
                    cyl(r=r+t, h=t, anchor=TOP);
                }
                move(z=_) cyl(d=shaft_d+gap_free, h=t+2*_, anchor=TOP);
            }
    }
}

module outer_gear_leg(z) {
    r = outer_radius(pitch=pitch, teeth=z);
    union() {
        move(z=-t*3/2) difference() {
            cuboid([2*(r+t), r+height_offset, 2*t], anchor=BACK);
            cyl(r=r, h=2*t+_);
        }
        move(y=-r-height_offset, z=-t/2-_) difference() {
            cuboid([2*(r+t), 2*t, height_offset+_], anchor=FRONT+BOTTOM);
            move([r/2,-_,height_offset/2]) rotate([90, 0, 0]) cyl(d=tap_hole_d, h=2*t+2*_, anchor=TOP);
            move([-r/2,-_,height_offset/2]) rotate([90, 0, 0]) cyl(d=tap_hole_d, h=2*t+2*_, anchor=TOP);
        }
        for(i=[-3:2:3]) {
            move([r*i/4,-r-height_offset+2*t-_,-t/2-_]) prismoid(size1=[t, 2*t], size2=[t, 0], shift=[0, -t], h=2*t, anchor=BOTTOM+FRONT);
        }
    }
}

module planetary_gear(z) {
    difference() {
        spur_gear(pitch=pitch, teeth=z, thickness=t-gap_free, clearance=0.5, backlash=0.5);
        cyl(d=shaft_d + gap_free, l=t-gap_free+_);
    }
}

module carrier(r_sun, r_p1, n1, r_p2, n2) {
    angle_offset = 360 / lcm(n1, n2) / 2;
    difference() {
        tube(ir=r_sun+r_p1-shaft_d, or=r_sun+r_p2+shaft_d, h=t, anchor=CENTER);
        for(i=[0:n1-1]) {
            rotate([0, 0, i * 360 / n1]) move(x=r_sun+r_p1) cyl(d=shaft_d+gap_fixed, h=t+2*_);
        }
        for(i=[0:n2-1]) {
            rotate([0, 0, i * 360 / n2 + angle_offset]) move(x=r_sun+r_p2) cyl(d=shaft_d+gap_fixed, h=t+2*_);
        }
    }
}

r_sun = pitch_radius(pitch=pitch, teeth=z_sun);
r_p1 = pitch_radius(pitch=pitch, teeth=z_p1);
r_p2 = pitch_radius(pitch=pitch, teeth=z_p2);
r_o1 = pitch_radius(pitch=pitch, teeth=z_o1);
r_o2 = pitch_radius(pitch=pitch, teeth=z_o2);

module assembled() {
    sun_gear();
    move(z=-t) outer_gear(z_o1);
    move(z=t) zflip() outer_gear(z_o2);

    for(i=[0:n1-1]) {
    rotate([0,0,i*360/n1]) move(z=-t) move(x=r_sun+r_p1) rotate([0,0,360/z_p1/2]) planetary_gear(z_p1);
    }
    move(z=-2*t) carrier(r_sun, r_p1, n1, r_p2, n2);

    angle_offset = 360 / lcm(n1, n2) / 2;
    for(i=[0:n2-1]) {
    rotate([0,0,i*360/n2+angle_offset]) move(z=t) move(x=r_sun+r_p2) rotate([0,0,360/z_p2/2]) planetary_gear(z_p2);
    }
    move(z=2*t) carrier(r_sun, r_p1, n1, r_p2, n2);

    carrier(r_sun, r_p1, n1, r_p2, n2);
}
/* assembled(); */

/* sun_gear(); */
/* planetary_gear(z_p1); */
/* planetary_gear(z_p2); */
/* carrier(r_sun, r_p1, n1, r_p2, n2); */
/* union() { */
/*     outer_gear_leg(z_o1); */
/*     outer_gear(z_o1); */
/* } */
outer_gear(z_o2);
