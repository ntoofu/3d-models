include <BOSL2/std.scad>

t = 7.0;
cs_t = 13.0;
inner_wall_t = 2.0;
id = 50.0;
trench_w = 5.5;
trench_h = 12.0;
lock_hole_d = 5.0;
cut_off = 2.0;
clearance = 0.2;

od = id + t * 2;

module bottom_part() {
	difference() {
	    bottom_half() difference() {
		spheroid(d=od, style="icosa");
		intersection() {
		spheroid(d=id, style="icosa");
		cyl(d=id-(cs_t-t)*2, h=id);
		}
	    }
	    rotate_extrude(angle=360, convexity=2) {
		move([od/2-cs_t+inner_wall_t-clearance/2, 0]) union() {
		    rect([inner_wall_t, (trench_h-lock_hole_d)/2], anchor=RIGHT+TOP);
		    rect([trench_w+clearance, trench_h+clearance], anchor=LEFT+TOP);
		    move([trench_w+clearance, -trench_h/2]) teardrop2d(d=lock_hole_d, ang=45, $fn=16);
		}
	    }
	    move([0, 0, -od/2]) cuboid([od, od, cut_off], anchor=BOTTOM);
	}
}

module top_part() {
	union() {
	    top_half() difference() {
		spheroid(d=od, style="icosa");
		intersection() {
		spheroid(d=id, style="icosa");
		cyl(d=id-(cs_t-t)*2, h=id);
		}
	    }
	    rotate_extrude(angle=360, convexity=2) {
		move([od/2-cs_t+inner_wall_t+clearance/2, 0]) difference() {
		    rect([trench_w-clearance, trench_h-clearance], anchor=LEFT+TOP);
		    move([trench_w-clearance, -trench_h/2]) rotate(180) teardrop2d(d=lock_hole_d, ang=45, $fn=16);
		}
	    }
	}
}

zflip() top_part();
// bottom_part();
