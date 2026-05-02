include <BOSL2/std.scad>

id = 23.0;
od = 40.0;
wall = 10.0;
t = 10.0;
head_l = 12.0;
arm_l = 100.0;
_ = 0.1;

move([0, 0, arm_l])
    extrude_from_to([0, 0, 0], [0, 0, head_l])
        difference() {
            circle(d=od);
            hexagon(id=id, realign=false);
            rect([od/2, id], anchor=LEFT);
        }

difference() {
    cyl(d=od, h=arm_l, anchor=BOTTOM);
    cyl(d=id*2/sqrt(3), h=arm_l-id, anchor=BOTTOM);
    move([0, 0, arm_l-id]) cyl(d1=id*2/sqrt(3), d2=id, h=id, anchor=BOTTOM);
    cuboid([od/2, id, arm_l], anchor=LEFT+BOTTOM);
}

extrude_from_to([0, 0, 0], [0, 0, head_l])
    difference() {
        hexagon(id=od, realign=true);
        circle(d=od-_);
        rect([od/sqrt(3), id], anchor=LEFT);
    }