use <base.scad>
use <gear.scad>

track_circle_d = 50.0;
track_center_dist = 60.0;
base_t = 3.0;
gear_h = 7.0;
gear_shaft_d = 20.0;
horn_pocket_depth = 3.0;
horn_pocket_bottom_t = 1.0;
chamfer = 0.5;
clearance_hole_d = 3.2;

base(track_center_dist, base_t, gear_shaft_d, gear_h, clearance_hole_d, chamfer);
up(base_t) xcopies(spacing=track_center_dist, n=2) gear(gear_h, gear_shaft_d, track_circle_d, track_center_dist, horn_pocket_depth, horn_pocket_bottom_t, chamfer);