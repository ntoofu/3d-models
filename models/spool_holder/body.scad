include <BOSL2/std.scad>

bearing_t = 7.0;
bearing_id = 8.0;
bearing_id2 = 10.0;
roller_d = 35.0;
spool_d = 200.0;
spool_w = 63.0;
hole_d = 3.0;
tapping_d = 2.7;
guide_t = 2.0;

chamfer = 0.5;
unit = 5.0;
// l = (spool_d + roller_d) / 2 * sqrt(2);
l = 110.0;
h = max(roller_d / 2, (spool_d - l) / 2) + 2.0 * unit;
t = 4.0;
spacing = 2.0;

clearance = 0.05;
_ = 0.1;

module bearing_holder(id1, id2, t, t2) {
    union() {
        cyl(d=id2, h=t2, anchor=BOTTOM, $fn=32);
        cyl(d=id1-clearance*2, h=t+t2, anchor=BOTTOM, chamfer=chamfer, $fn=48);
    }
}

module hex_pillar(id, h) {
    extrude_from_to([0, 0, 0], [0, 0, h])
        hexagon(id=id, realign=false);
}

module holder() {
    difference() {
        union() {
            move([0, h, 0]) bearing_holder(bearing_id, bearing_id2, bearing_t, spacing);
            // move([0, -t/2, 0]) cuboid([bearing_id2 + 2*unit, h+bearing_id2/2+unit+t/2, t], anchor=FRONT+TOP, chamfer=chamfer, edges=[BACK, TOP+RIGHT, TOP+LEFT, BOTTOM+RIGHT, BOTTOM+LEFT]);
            move([0, -t/2, 0]) rotate([90, 0, 0]) prismoid(size1=[bearing_id2 + 2*unit, t], size2=[bearing_id2 + 6*unit, t], h=h+bearing_id2/2+unit+t/2, anchor=BACK+TOP, chamfer=chamfer);
            move([0, 0, -t]) cuboid([bearing_id2 + 8*unit, t, 4*unit+t], anchor=BACK+BOTTOM, chamfer=chamfer);
            xcopies(n=2, l=4*unit) move([0, -t/2, -t/2])
                prismoid(size1=[t, 1.5*unit+t], size2=[t,0], shift=[0, -(1.5*unit+t)/2], h=1.5*unit+t, anchor=BOTTOM+FRONT);
    
        }
        move([0, h, -t/2]) hex_pillar(id=tapping_d, h=bearing_t+spacing+t/2+_);
        xcopies(n=2, l=6*unit) {
            for ( z = [ unit : unit : 3*unit ] ) {
                move([0, _, z]) rotate([90, 0, 0])
                    hex_pillar(id=tapping_d, h=t+2*_);
            }
        }
    }
}

module hole_guide() {
    difference() {
        union() {
            cuboid([l+unit*8, spool_w, guide_t], anchor=TOP, chamfer=chamfer);
            xcopies(n=2, l=l) yflip_copy()
                move([0, spacing+bearing_t/2+spool_w/2, 0])
                    rotate([90, 0, 0]) {
                        xcopies(n=2, l=6*unit)
                            move([0, _, 2*unit]) rotate([90, 0, 0])
                                cyl(d=hole_d*3, h=t, $fn=16, chamfer=chamfer);
                    }
        }
        xcopies(n=2, l=l) yflip_copy()
            move([0, spacing+bearing_t/2+spool_w/2, 0])
                rotate([90, 0, 0]) {
                    xcopies(n=2, l=6*unit)
                        move([0, _, 2*unit]) rotate([90, 0, 0])
                            cyl(d=hole_d+2*clearance, h=t+2*_, $fn=16, chamfer=-chamfer);
                }
        move([0, 0, _]) cuboid([l+unit*4, spool_w-4*unit, guide_t+2*_], anchor=TOP, chamfer=chamfer);
    }
}


/*
xcopies(n=2, l=l) yflip_copy()
    move([0, spacing+bearing_t/2+spool_w/2, 0])
        rotate([90, 0, 0]) holder();
*/
move([0, 0, -t]) hole_guide();
/*holder();*/
