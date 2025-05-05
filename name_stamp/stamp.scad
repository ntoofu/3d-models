include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <./name.scad>

res = 50;
l = 10.0;
delta_max = 6.5;
t = name;
font = "MigMix 2P:style=Bold";
size = 8;
spacing = 1.0;
base_d = 7.0;

width = 70.0;

intersection() {
    union() {
        for(i=[0:res]) {
            move([0, 0, l*i/res]) linear_extrude(l/res) offset(delta=delta_max*i/res) text(text=t, font=font, size=size);
        }
    }
    move([-spacing, -spacing, 0]) cuboid([width+2*spacing, size+2*spacing, l], anchor=BOTTOM+LEFT+FRONT);
}
move([-spacing, -spacing, l]) cuboid([width+2*spacing, size+2*spacing, base_d], anchor=BOTTOM+LEFT+FRONT);
