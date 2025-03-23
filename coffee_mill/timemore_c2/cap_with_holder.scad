include <BOSL2/std.scad>

wall_t = 1.5;
ceil_t = 2.0;
cap_id = 52.0;
cap_h = 12.0;
shaft_mount_d_min = 10.0;
shaft_mount_d_max = 20.0;
shaft_mount_h = 7.0;
shaft_od = 6.0 + 0.3;
shaft_head_room = 1.5;
brush_holder_id_max = 10.0;
brush_holder_id_min = 9.5;
brush_holder_h = 10.0;
brush_holder_top_z = 40.0;
brush_holder_t = 1.0;
handle_holder_id = 6.0;
handle_holder_t = 1.2;
handle_holder_l = cap_h;
handle_holder_base_l = 1.0;
handle_holder_path_ang1 = 15;
handle_holder_path_ang2 = 135;
chamfer = 0.5;
_ = 0.1;


cap_od = cap_id + 2 * wall_t;
brush_holder_id_z0 = brush_holder_id_min + (brush_holder_id_max - brush_holder_id_min) / brush_holder_h * brush_holder_top_z;
brush_holder_od_z0 = brush_holder_id_z0 + brush_holder_t * 2;
brush_holder_hull_offset = cap_od / 2 * sqrt(1 - ((cap_od - brush_holder_od_z0) / (cap_od + brush_holder_od_z0)) ^ 2);
handle_holder_path_d = handle_holder_id + handle_holder_t;
handle_holder_path = [
	[handle_holder_path_d / 2 * sin(handle_holder_path_ang1), 0],
	each move([0, handle_holder_base_l + handle_holder_path_d / 2 * cos(handle_holder_path_ang1)], p=rot(-90, p=arc(d=handle_holder_path_d, angle=[handle_holder_path_ang1, handle_holder_path_ang2], n=10)))
];

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
		move([0, 0, shaft_mount_h+_]) cyl(d=shaft_od, chamfer1=chamfer, chamfer2=-chamfer, h=shaft_mount_h + shaft_head_room, anchor=TOP, $fn=6);
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
	rotate([0, 0, 90]) move([0, cap_od / 2, -ceil_t]) xflip_copy() 
		linear_extrude(handle_holder_l)
			stroke(width=handle_holder_t, handle_holder_path);
}

union() {
	cap();
	brush_holder();
	handle_holder();
}


