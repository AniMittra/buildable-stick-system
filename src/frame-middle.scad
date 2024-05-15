/*
 * SPDX-FileCopyrightText: © 2023 Brian S. Stephan <bss@incorporeal.org>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

include <parameters.scad>
include <components.scad>

module frame_connection_holes() {
	translate([frame_x/2, (frame_y/4)+5, (frame_z/4)]) rotate([0, 90, 0]) m4_hole();
	translate([frame_x/2, (frame_y/4)+5, -(frame_z/4)]) rotate([0, 90, 0]) m4_hole();
	translate([frame_x/2, (frame_y/4)-15, (frame_z/4)]) rotate([0, 90, 0]) m4_hole();
	translate([frame_x/2, (frame_y/4)-15, -(frame_z/4)]) rotate([0, 90, 0]) m4_hole();

	translate([frame_x/2, -((frame_y/4)+5), (frame_z/4)]) rotate([0, 90, 0]) m4_hole();
	translate([frame_x/2, -((frame_y/4)+5), -(frame_z/4)]) rotate([0, 90, 0]) m4_hole();
	translate([frame_x/2, -((frame_y/4)-15), (frame_z/4)]) rotate([0, 90, 0]) m4_hole();
	translate([frame_x/2, -((frame_y/4)-15), -(frame_z/4)]) rotate([0, 90, 0]) m4_hole();
}

module base_middle_frame() {
	difference() {
		mid_frame();
		// chop the left and right edge off
		mid_side_chopper();
		mirror([1, 0, 0]) mid_side_chopper();
	}
}

module middle_frame() {
	difference() {
		base_middle_frame();
		// connection holes to other frames
		frame_connection_holes();
		mirror([1, 0, 0]) frame_connection_holes();

		// cable routing holes
		translate([-30,0,0]) frame_cable_routing_hole();
		translate([30,0,0]) mirror([1, 0, 0]) frame_cable_routing_hole();

		// neutrik mounts for connector, switches
		translate([20, (frame_y/2)-neutrik_panel_thickness, 0]) rotate([90, 0, 0]) neutrik_d_mount();
		translate([20, (frame_y/2)-neutrik_panel_thickness-4, 0]) frame_cutout();
		
        translate([-20, (frame_y/2)-neutrik_panel_thickness, 0]) rotate([90, 0, 0]) neutrik_d_mount();
		translate([-20, (frame_y/2)-neutrik_panel_thickness-4, 0]) frame_cutout();
		
        //translate([40, (frame_y/2)-neutrik_panel_thickness, 0]) rotate([90, 0, 0]) neutrik_d_mount();
		//translate([40, (frame_y/2)-neutrik_panel_thickness-4, 0]) frame_cutout();
	}
}

middle_frame();
