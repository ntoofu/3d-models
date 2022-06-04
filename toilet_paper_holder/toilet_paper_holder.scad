include <BOSL2/std.scad>

ring_ir = 12.0;
thickness = 5.0;
ring_r = ring_ir + thickness / 2;
width = 20.0;
arm_a_length = 70.0;
arm_b_length = 100.0;
link_length = 60.0;

_ = 0.01;
$fn = 64;

module partial_torus(ang) {
    zrot(ang)
    difference() {
        tube(ir = ring_ir, or = ring_ir + thickness, h = width);
        move(z=-_) pie_slice(ang = 360 - ang, h = width + 2 * _, r = ring_ir + thickness + _);
    }
}

module arm(l) {
    move(x = -ring_ir) cuboid([thickness, l, width], anchor = BACK+RIGHT+BOTTOM, edges=[FRONT+RIGHT, FRONT+LEFT], rounding = thickness / 2);
}

union() {
    partial_torus(180);
    arm(arm_a_length);
    yflip() zrot(180) arm(ring_ir * 0.5);
    zrot(-135) arm(arm_b_length);
}
