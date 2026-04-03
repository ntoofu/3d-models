#include <BOSL2/std.scad>

mounter_trench_w = 9.4 + 0.2;
mounter_trench_h = 2.5 + 0.5;
mounter_magnet_d = 23.0 + 0.2;
mounter_magnet_t = 2.5 + 0.2;
holder_magnet_d = 13.0 + 0.2;
holder_magnet_t = 2.5 + 0.2;
cup_d = 50.0;
holder_spacing = 1.0;
holder_d = 70.0;
holder_wall_t = 2.0;
holder_magnet_notch_w = 2.0;
holder_magnet_notch_l = 1.0;
total_h = mounter_trench_h + mounter_magnet_t + holder_magnet_t + holder_wall_t;

chamfer = 0.5;
_ = 0.1;


difference() {
	cyl(d=holder_d, h=total_h, chamfer=chamfer, anchor=BOTTOM, $fn=64);
	move([0, 0, -_]) cuboid([holder_d, mounter_trench_w, mounter_trench_h+2*_], chamfer=-chamfer, edges=[BOTTOM], anchor=BOTTOM);
	move([0, 0, mounter_trench_h]) {
		cyl(d=mounter_magnet_d, h=mounter_magnet_t+holder_magnet_t, chamfer2=-chamfer, anchor=BOTTOM);
		move([0, 0, mounter_magnet_t]) {
			zrot_copies(n=6) {
				move([cup_d/2, 0, 0]) {
					cyl(d=holder_magnet_d, h=holder_magnet_t, anchor=BOTTOM);
					rotate([0, 90, 0]) cuboid([holder_magnet_t, holder_magnet_d, (holder_d-cup_d)/2], edges=[TOP], chamfer=-chamfer, anchor=RIGHT+BOTTOM);
					cuboid([holder_magnet_d/2+holder_magnet_notch_l, holder_magnet_notch_w, holder_magnet_t], anchor=BOTTOM+RIGHT);
				}
			}
			move([0, 0, holder_magnet_t-_]) {
				cyl(d=cup_d+2*holder_spacing, h=holder_wall_t+2*_, chamfer2=-chamfer, anchor=BOTTOM);
			}
		}
	}
}
