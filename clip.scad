shelf_thickness = 5/8 * 25.4; // 5/8" to mm
wall_thickness = 2;
cable_diameter = 4;
clip_depth = shelf_thickness;

$fa=0.5; // default minimum facet angle is now 0.5
$fs=0.5; // default minimum facet size is now 0.5 mm

// shelf
% translate([-50,0,wall_thickness]) cube([100, shelf_thickness, 100]);

module clip(width, depth, height, tooth) {
	// what we're clipping onto
	% cube([width, depth, height]);

	difference() {
		translate([0,-wall_thickness,-wall_thickness]) cube([width, depth+wall_thickness, height+wall_thickness]);
		translate([-1,0,0]) cube([width+2, depth+1, height+1]);
	}

	// tooth
	offset = tooth/sqrt(2);
	translate([width/2,depth-offset,0]) rotate([45,0,0])
		cube([width, tooth, tooth], center=true);
}

translate([0, shelf_thickness, 0])
translate([0, 0, wall_thickness])  // level with print bed
rotate([90,0,0])                   // lie on it's back
translate([-cable_diameter/2,0,0]) // center on x
clip(cable_diameter, clip_depth, shelf_thickness, wall_thickness);

// holder
translate([0,-(cable_diameter/2+wall_thickness),0])
difference () {
	union () {
		// bottom rectangle
		translate([-(cable_diameter/2+wall_thickness),0,0]) cube([cable_diameter+wall_thickness*2, cable_diameter/2 + wall_thickness, clip_depth]);
		// upper cylinder
		cylinder(r=cable_diameter/2 + wall_thickness, h=clip_depth);
	}
	// cable cylinder
	translate([0,0,-1]) cylinder(r=cable_diameter/2, h=clip_depth+2);
	// cable escape rectangle
	translate([0,-cable_diameter/2, clip_depth/2]) cube([cable_diameter/2, wall_thickness+2, clip_depth+2], center=true);
}
