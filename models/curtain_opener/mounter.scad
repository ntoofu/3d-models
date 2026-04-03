include <BOSL2/std.scad>

$fn = 32;

rail_d = 50.0;
rail_w = 20.6;
rail_h = 10.6;
pole_d = 17.0;
gap = 5.2;
tapping_d = 2.7;
no_tapping_d = 3.3;
shaft_d = 3.0;
chamfer_size = 1.0;
wall_t = 7.0;
l = 20.0;
motor_shaft_x = 16.5;
motor_shaft_y = 22.0;
motor_shaft_hole_x = motor_shaft_x - (rail_d - rail_w - wall_t) / 2;
motor_shaft_hole_y = motor_shaft_y + l / 2;
motor_d = 30.0;

clearance = 0.2;
layer_d = 0.2;

_ = 0.01;


module hex_pillar(id, h) {
    extrude_from_to([0, 0, -h/2], [0, 0, h/2])
        hexagon(id=id, realign=false);
}

module holding_part() {
    difference() {
        union() {
            move([rail_w/2, 0, 0]) cuboid([wall_t, l, rail_h+wall_t+gap], anchor=LEFT+TOP, chamfer=chamfer_size, edges=[TOP,FRONT+RIGHT,FRONT+LEFT,BACK+RIGHT,BACK+LEFT]);
            move([-rail_w/2, 0, motor_d]) cuboid([wall_t, l, rail_h+wall_t+motor_d], anchor=RIGHT+TOP, chamfer=chamfer_size);
            cuboid([rail_w+wall_t*2, l, wall_t], anchor=TOP, chamfer=chamfer_size);
        }
        move([0, 0, -wall_t/2]) hex_pillar(id=tapping_d, h=wall_t+_);
        move([(rail_w+wall_t)/2, 0, -(wall_t+rail_h+gap)]) hex_pillar(id=tapping_d, h=gap*2);
        move([-(rail_w+wall_t)/2, 0, -wall_t/2]) rotate([90, 0, 0]) cyl(d=tapping_d, h=l+_);
        move([-(rail_w+wall_t)/2, -l/2-_, -wall_t/2]) cuboid([wall_t/2, layer_d+_, layer_d*2], anchor=RIGHT+FRONT);
        move([-(rail_w+wall_t)/2, 0, motor_d-wall_t/2]) rotate([90, 0, 0]) cyl(d=tapping_d, h=l+_);
        move([-(rail_w+wall_t)/2, -l/2-_, motor_d+_]) cuboid([layer_d*2, layer_d+_, wall_t/2+_], anchor=TOP+FRONT);
    }
}

module top_half() {
    difference() {
        union() {
            xflip_copy(offset=rail_d/2) holding_part();
            move([0, 0, motor_d]) cuboid([rail_d-rail_w-wall_t*2+chamfer_size*2, l, wall_t], anchor=TOP, chamfer=chamfer_size, edges=[TOP+FRONT,TOP+BACK,BOTTOM+FRONT,BOTTOM+BACK]);
            move([0, 0, -rail_h]) cuboid([rail_d-rail_w, l, wall_t], anchor=TOP, chamfer=chamfer_size);
        }
        move([0, 0, -rail_h-wall_t/2]) hex_pillar(id=shaft_d, h=wall_t+_);
        move([0, -l/2-_, -rail_h+_]) cuboid([layer_d*2, layer_d+_, wall_t+_*2], anchor=TOP+FRONT);
    }
}

module bottom_half() {
    move([0, 0, -(wall_t+rail_h+gap)])
        difference() {
            union() {
                cuboid([rail_d+rail_w+2*wall_t, l, wall_t], anchor=TOP, chamfer=chamfer_size, edges=[BOTTOM,FRONT+RIGHT,FRONT+LEFT,BACK+RIGHT,BACK+LEFT]);
                cuboid([motor_shaft_hole_x*2+wall_t, motor_shaft_hole_y+wall_t/2, wall_t], anchor=TOP+FRONT, chamfer=chamfer_size, edges=[BOTTOM,FRONT+RIGHT,FRONT+LEFT,BACK+RIGHT,BACK+LEFT]);
            }
            move([0, 0, _]) cyl(d=shaft_d, h=0.6*wall_t+_, anchor=TOP);
            xcopies(n=3, spacing=(rail_d+rail_w+wall_t)/2)
                move([0, 0, _]) cuboid([layer_d*2, l/2, layer_d+_], anchor=TOP+BACK);
            move([0, 0, _]) xcopies(n=2, spacing=(rail_d+rail_w+wall_t))
                cyl(d=no_tapping_d, h=wall_t+2*_, anchor=TOP);
            move([0, 0, -wall_t-_]) xcopies(n=2, spacing=(rail_d+rail_w+wall_t))
                cuboid([no_tapping_d*2.5, no_tapping_d*2.5, wall_t*0.5+_], anchor=BOTTOM);
            xcopies(n=2, spacing=motor_shaft_hole_x*2) {
                move([0, motor_shaft_hole_y, _]) cyl(d=shaft_d, h=wall_t+_*2, anchor=TOP);
                move([0, motor_shaft_hole_y, _]) cuboid([layer_d*2, wall_t/2+_, layer_d+_], anchor=TOP+FRONT);
            }
        }
}

echo("Shaft Distance: ", norm([motor_shaft_hole_x,motor_shaft_hole_y]));

/* top_half(); */
bottom_half();
