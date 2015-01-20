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

module holder(channel_rad, gap, length) {
	holder_rad = channel_rad + wall_thickness;
	translate([0, -holder_rad, 0]) // set origin
	difference () {
		union () {
			// upper cylinder
			cylinder(r=channel_rad + wall_thickness, h=clip_depth);

			// bottom rectangle
			translate([-holder_rad,0,0]) cube([holder_rad*2, holder_rad, length]);
		}
		// channel
		translate([0,0,-1]) cylinder(r=channel_rad, h=length+2);
		// gap
		translate([0, -(channel_rad+1), length/2]) cube([gap/2, wall_thickness+2, length+2], center=true);
	}
}

holder((cable_diameter+1)/2, cable_diameter-1, clip_depth);
