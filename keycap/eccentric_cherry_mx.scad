include <BOSL2/std.scad>

eccentricity = 0.25;
stem_holder_d = 5.5;
stem_holder_h = 7.5;
stem_l = 3.6;
stem_t1 = 1.1;
stem_t2 = 1.3;
stem_w = 4.1;
cap_top_size = [15.0, 15.0];
cap_bottom_width = 18.1;
key_pitch = 19.05;
hole_space = 0.2;
chamfer = 0.2;
cap_top_t = 2.0;
cap_side_t = 1.0;
cap_chamfer = 0.5;
top_room_h = stem_holder_h - stem_l;
top_rounding = 1.5;
cap_top_r = 25;

module stem() {
    difference() {
        cyl(h=stem_holder_h, d=stem_holder_d, chamfer1=chamfer, $fn=64, anchor=BOTTOM);
        cuboid([stem_t1+hole_space, stem_w+hole_space, stem_l+chamfer+hole_space], chamfer=-chamfer, edges=[BOTTOM], anchor=BOTTOM);
        cuboid([stem_w+hole_space, stem_t2+hole_space, stem_l+chamfer+hole_space], chamfer=-chamfer, edges=[BOTTOM], anchor=BOTTOM);
    }
}

// stem
move([0, key_pitch * eccentricity, 0]) stem();

xflip_copy()
    skew(sxz=(cap_top_size[0]-cap_bottom_width)/2/stem_holder_h)
        union() {
            // X-axis beam
            move([0, key_pitch * eccentricity - key_pitch / 2, 0]) 
                cuboid([cap_bottom_width/2, cap_side_t, stem_holder_h], chamfer=cap_chamfer, except_edges=[TOP, LEFT], anchor=LEFT+BOTTOM);
            // side walls
            move([cap_bottom_width/2, 0, 0])
                cuboid([cap_side_t, cap_top_size[1], stem_holder_h], chamfer=cap_chamfer, except_edges=[TOP, LEFT], anchor=RIGHT+BOTTOM);
            // top inner chamfer
            move([cap_bottom_width/2-cap_side_t, 0, stem_holder_h])
                zflip()
                    prismoid(size1=[top_room_h, cap_top_size[1]], size2=[0, cap_top_size[1]], shift=[top_room_h/2, 0], h=top_room_h, anchor=RIGHT+BOTTOM);
    }

// key top
move([0, 0, stem_holder_h]) 
difference() {
    cuboid([cap_top_size[0], cap_top_size[1], cap_top_t], rounding=top_rounding, except_edges=[BOTTOM], anchor=BOTTOM, $fn=32);
    move([0, 0, cap_top_r+cap_top_t/2]) sphere(r=cap_top_r, $fn=64);
}