include <BOSL2/std.scad>

t = 2.0;
leg_height = 2.0;
clearance = 0.4;
key_gap_h = 4.0;
key_gap_v = 3.0;
key_pitch_h = 19.0;
key_pitch_v = 18.0;
base_d = 5 * key_pitch_v - key_gap_v;
slit = 0.20;
init_layer_h = 0.20;

_ = 0.01;


module stick() {
    edges_without_bottom = [TOP, LEFT+FRONT, LEFT+BACK, RIGHT+FRONT, RIGHT+BACK];
    width = key_pitch_h-key_gap_h+clearance;
    difference() {
        union() {
            cuboid([width, base_d, t], anchor=BOTTOM);
            move([0, base_d/2, 0]) cuboid([width, key_gap_v-clearance, t+leg_height], anchor=BOTTOM+FRONT);

            move([0, base_d/2-key_pitch_v,   t]) cuboid([0.5*key_pitch_h, key_gap_v-clearance, leg_height], anchor=BOTTOM+FRONT, chamfer=clearance, edges=edges_without_bottom);
            move([0, base_d/2-2*key_pitch_v, t]) cuboid([0.5*key_pitch_h, key_gap_v-clearance, leg_height], anchor=BOTTOM+FRONT, chamfer=clearance, edges=edges_without_bottom);

            move([key_pitch_h/2,  -base_d/2, 0]) cuboid([key_gap_h-clearance, 2*key_pitch_v, t+leg_height], anchor=BOTTOM+FRONT);
            move([-key_pitch_h/2, -base_d/2, 0]) cuboid([key_gap_h-clearance, 2*key_pitch_v, t+leg_height], anchor=BOTTOM+FRONT);

            move([key_pitch_h/2,  -base_d/2+2*key_pitch_v, 0]) cuboid([key_gap_h-clearance, key_pitch_v-key_gap_v-clearance, t], anchor=BOTTOM+FRONT);
            move([-key_pitch_h/2, -base_d/2+2*key_pitch_v, 0]) cuboid([key_gap_h-clearance, key_pitch_v-key_gap_v-clearance, t], anchor=BOTTOM+FRONT);

        }

        move([0, -base_d/2+key_pitch_v+clearance/2,   t+_]) cuboid([0.5*key_pitch_h+clearance, key_gap_v, leg_height+clearance+_], anchor=TOP+BACK);
        move([0, -base_d/2+2*key_pitch_v+clearance/2, t+_]) cuboid([0.5*key_pitch_h+clearance, key_gap_v, leg_height+clearance+_], anchor=TOP+BACK);

        move([0, -base_d/2-_, -_]) cuboid([slit, 2*key_pitch_v, 0.6*init_layer_h+_], anchor=BOTTOM+FRONT);

    }
}

stick();
