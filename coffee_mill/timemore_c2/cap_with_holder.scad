include <BOSL2/std.scad>

wall_t = 1.5;
ceil_t = 2.0;
cap_id = 52.0;
cap_h = 12.0;
shaft_od = 6.0;
shaft_mount_d_min = 10.0;
shaft_mount_d_max = 20.0;
shaft_mount_h = 7.0;
shaft_mount_hole_d = shaft_od + 0.3;
shaft_head_room = 1.5;
brush_holder_id_max = 10.0;
brush_holder_id_min = 9.5;
brush_holder_h = 10.0;
brush_holder_top_z = 40.0;
brush_holder_t = 1.0;
handle_d = 6.0;
handle_holder_w1 = 24.0;
handle_holder_w2 = handle_d + 0.1;
handle_holder_t = 3.0;
chamfer = 0.5;
_ = 0.1;


cap_od = cap_id + 2 * wall_t;
brush_holder_id_z0 = brush_holder_id_min + (brush_holder_id_max - brush_holder_id_min) / brush_holder_h * brush_holder_top_z;
brush_holder_od_z0 = brush_holder_id_z0 + brush_holder_t * 2;
brush_holder_hull_offset = cap_od / 2 * sqrt(1 - ((cap_od - brush_holder_od_z0) / (cap_od + brush_holder_od_z0)) ^ 2);

module base() {
	move([0, 0, -ceil_t]) cyl(d=cap_od, h=cap_h, chamfer=chamfer, anchor=BOTTOM, $fn=128);
}

module cap() {
	difference() {
		union() {
			difference() {
				base();
				cyl(d=cap_id, h=cap_h-ceil_t+_, chamfer2=-chamfer, anchor=BOTTOM, $fn=128);
			}
			cyl(d1=shaft_mount_d_max, d2=shaft_mount_d_min, h=shaft_mount_h, anchor=BOTTOM);
		}
		move([0, 0, shaft_mount_h+_]) cyl(d=shaft_mount_hole_d, chamfer1=chamfer, chamfer2=-chamfer, h=shaft_mount_h + shaft_head_room, anchor=TOP, $fn=6);
	}
}

module brush_holder() {
	difference() {
		hull() {
			right_half(x=brush_holder_hull_offset) base();
			move([(cap_od+brush_holder_od_z0)/2, 0, brush_holder_top_z]) cyl(d1=brush_holder_id_max + 2 * brush_holder_t, d2=brush_holder_id_min + 2 * brush_holder_t, h=brush_holder_h, anchor=TOP);
		}
		move([(cap_od+brush_holder_od_z0)/2, 0, brush_holder_top_z+_]) cyl(d1 = brush_holder_id_z0, d2 = brush_holder_id_min, h=brush_holder_top_z, anchor=TOP);
		cyl(d=cap_id, h=brush_holder_top_z, anchor=BOTTOM);
	}
}

module handle_holder() {
	difference() {
		union() {
			move([-cap_od/2+wall_t, 0, -ceil_t]) cuboid([handle_holder_w1 - handle_holder_w2 / 2, handle_holder_w2 + handle_holder_t * 2, cap_h], chamfer=chamfer, anchor=BOTTOM+RIGHT);
			move([-cap_od/2+wall_t-handle_holder_w1+handle_holder_w2/2, 0, -ceil_t]) cyl(d=handle_holder_w2+handle_holder_t*2, h=cap_h, chamfer=chamfer, anchor=BOTTOM);
		}
		move([-cap_od/2+wall_t, 0, -ceil_t]) cuboid([handle_holder_w1 - handle_holder_w2 / 2, handle_holder_w2, cap_h], chamfer=-chamfer, anchor=BOTTOM+RIGHT);
		move([-cap_od/2+wall_t-handle_holder_w1+handle_holder_w2/2, 0, -ceil_t]) cyl(d=handle_holder_w2, h=cap_h, chamfer=-chamfer, anchor=BOTTOM);
		move([-cap_od/2+wall_t, -handle_holder_w2/2, -ceil_t]) cuboid([handle_d * 2, handle_holder_t, cap_h], chamfer=-chamfer, anchor=BOTTOM+RIGHT+BACK);

	}
}

union() {
	cap();
	brush_holder();
	handle_holder();
}


