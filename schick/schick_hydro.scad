include <BOSL2/std.scad>

_ = 0.01;

module head() {
    move([0, 0, -3])
        union() {
            import("import/v6_Schick_Razor_Flamingo_Adapter.STL", convexity=10);
            cuboid(p1=[12, 2.5, 13.2], p2=[25, 7.5, 0]);
        };
}

union() {
    top_half() head();
    hull() {
        linear_extrude(height=0.1, center=true, convexity=5, slices=2, scale=1)
            projection(cut=true) head();
        move([18, 5, -15])
            linear_extrude(height=0.1, center=true, convexity=5, slices=2, scale=1)
            hexagon(ir=5);
    }
    move([18, 5, -55])
            linear_extrude(height=80, center=true, convexity=5, slices=2, scale=1)
            hexagon(ir=5);
    move([18, 5, -96]) zflip()
            linear_extrude(height=2, center=true, convexity=5, slices=4, scale=0.5)
            hexagon(ir=5);
}
