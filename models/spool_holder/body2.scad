include <BOSL2/std.scad>

bearing_t = 7.0;
bearing_id = 8.0;
bearing_id2 = 10.0;
roller_d = 35.0;
hole_d = 3.0;
tapping_d = 2.7;

chamfer = 0.5;
unit = 5.0;
l = 120.0;
h = 25.0;
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
            move([0, h, 0]) xcopies(n=2, spacing=l) bearing_holder(bearing_id, bearing_id2, bearing_t, spacing);
	    move([0, h, 0]) cuboid([l + bearing_id2 + chamfer * 2, bearing_id2 + chamfer * 2, t], chamfer=chamfer, anchor=TOP);
	    xflip_copy() move([(l + bearing_id2) / 2 + chamfer, 0, 0]) union() {
                move([0, t, 0]) cuboid([0.2 * l, h - t, t], anchor=TOP+RIGHT+FRONT, chamfer=chamfer, edges=[TOP+LEFT,TOP+RIGHT,BOTTOM+LEFT,BOTTOM+RIGHT]);
		move([0, t, -t]) rotate([45, 0, 0]) cuboid([0.2 * l, t, 2 * sqrt(2) * t], anchor=FRONT+RIGHT+BOTTOM, chamfer=chamfer, edges=[FRONT+LEFT,FRONT+RIGHT,BACK+LEFT,BACK+RIGHT]);
		difference() {
		    move([0, 0, t]) cuboid([0.2 * l, t, h - t], anchor=BACK+RIGHT+BOTTOM, chamfer=chamfer, edges=[TOP+FRONT,TOP+BACK,TOP+RIGHT,TOP+LEFT,FRONT+RIGHT,FRONT+LEFT,BACK+RIGHT,BACK+LEFT]);
		    move([-0.1 * l, _, 0.6 * h]) rotate([90, 0, 0]) hex_pillar(id=tapping_d, h=t+2*_);
		}
	    }
    
        }
        move([0, h, -t/2]) 
        xcopies(n=2, l=6*unit) {
            for ( z = [ unit : unit : 3*unit ] ) {
                move([0, _, z]) rotate([90, 0, 0])
                    hex_pillar(id=tapping_d, h=t+2*_);
            }
        }
    }
}

holder();
