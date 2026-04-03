include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

module stamp(l1, l2, ratio=0.5, layer_d=0.2, spacing=1.0, top_d=1.0) {
    delta_max = l1 * ratio;
    intersection() {
        union() {
            res = ceil(l1 / layer_d);
            for(i=[0:res]) {
                move([0, 0, l1*i/res]) linear_extrude(l1/res) offset(delta=delta_max*i/res) children();
            }
        }
        hull() linear_extrude(l1) offset(delta=spacing) children();
    }
    difference() {
        move([0, 0, l1]) hull() linear_extrude(l2) offset(delta=spacing) children();
        move([0, 0, l1+l2-top_d]) linear_extrude(top_d) children();
    }
}