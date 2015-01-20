shelf_thickness = 17;
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
clip(cable_diameter, clip_depth, shelf_thickness+0.1, wall_thickness);

module squared_cylinder(r1, r2, h) {
	cylinder(r1=r1, r2=r2, h=h);
	intersection() {
	rotate([0,0,45]) scale([sqrt(2),sqrt(2),1])
		cylinder(r1=r1, r2=r2, h=h, $fn=4);
		translate([-(r1+r2),0,-1])
			cube([(r1+r2)*2,(r1+r2)*2,h+2]);
	}
}

module holder(channel_rad, gap, length) {
	holder_rad = channel_rad + wall_thickness;
	translate([0, -holder_rad, 0]) // set origin
	difference () {
		intersection() {
			union () {
				
				// upper cylinder
				scale([1, 1 - wall_thickness/holder_rad/2, 1])
				cylinder(r=channel_rad + wall_thickness, h=length);

				// bottom rectangle
				translate([-holder_rad,0,0]) cube([holder_rad*2, holder_rad, length]);
			}

			translate([0, 0, length/2])
			scale([1, (holder_rad*2-wall_thickness) / length*2, 1])
			translate([-(holder_rad+1),holder_rad,0])
			rotate([0, 90, 0])
				squared_cylinder(r1=length/2, r2=length/2, h=holder_rad*2+2);
		}
		// channel
		translate([0,0,-1]) cylinder(r=channel_rad, h=length+2);

		// gap
		translate([0, -(channel_rad+1), length/2]) cube([gap, wall_thickness+2, length+2], center=true);
	}
}

holder(cable_diameter/2 +1, cable_diameter-0.5, clip_depth+wall_thickness);

// cable
%translate([0, -(cable_diameter/2 + 1 + wall_thickness),-clip_depth/2]) cylinder(r=cable_diameter/2, h=clip_depth*2);
