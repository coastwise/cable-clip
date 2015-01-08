shelf_thickness = 5/8 * 25.4; // 5/8" to mm
wall_thickness = 2;
cable_diameter = 4;
clip_depth = shelf_thickness;

// shelf
% translate([-50,0,wall_thickness]) cube([100, shelf_thickness, 100]);

translate([-cable_diameter/2, 0, 0]){
	// back
	cube([cable_diameter, shelf_thickness, wall_thickness]);

	translate([0, shelf_thickness, 0]) {
		// bottom
		cube([cable_diameter, wall_thickness, clip_depth]);

		// tooth
		translate([cable_diameter/2, 0, clip_depth - wall_thickness/sqrt(2)])
			rotate([45,0,0])
			cube([cable_diameter, wall_thickness, wall_thickness], center=true);
	}
}

translate([0,-(cable_diameter/2+wall_thickness),0])
difference () {
	union () {
		translate([-(cable_diameter/2+wall_thickness),0,0]) cube([cable_diameter+wall_thickness*2, cable_diameter/2 + wall_thickness, clip_depth]);
		cylinder(r=cable_diameter/2 + wall_thickness, h=clip_depth);
	}
	translate([0,0,-1]) cylinder(r=cable_diameter/2, h=clip_depth+2);
	translate([0,-cable_diameter/2, clip_depth/2]) cube([cable_diameter/2, wall_thickness+2, clip_depth+2], center=true);
}
