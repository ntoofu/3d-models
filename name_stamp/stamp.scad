include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <./name.scad>

res = 25;
l = 2.5;
delta_max = 1;
t = name;
font = "MigMix 2P:style=Bold";
size = 10;
spacing = 2;

zflip() union() {
    for(i=[0:res]) {
        move([0, 0, l*i/res]) #linear_extrude(l/res) offset(delta=delta_max*i/res) text(text=t, font=font, size=size);
    }
    move([-delta_max-spacing, -delta_max-spacing, l]) cuboid([93, size+2*delta_max+2*spacing, 5], anchor=BOTTOM+LEFT+FRONT);
}
