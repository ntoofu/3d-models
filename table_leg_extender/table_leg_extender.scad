include <BOSL2/std.scad>

table_leg_width = 30.4;
extension_length = 35.0;
wall_height = 5.0;
wall_min_width = 4.0;
hw_ratio = 0.75;
clearance = 0.8;

_ = 0.01;


module extender() {
    pocket_width = table_leg_width + 2 * clearance;
    top_width = pocket_width + 2 * wall_min_width;
    height = extension_length + wall_height;
    bottom_width = top_width + height * hw_ratio;
    difference() {
        prismoid(size1=[bottom_width, bottom_width], size2=[top_width, top_width], h=height);
        move([0, 0, height + _]) cuboid([pocket_width, pocket_width, wall_height + _], anchor=TOP);
    }
}

extender();
