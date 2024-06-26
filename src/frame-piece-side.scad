/*
 * SPDX-FileCopyrightText: © 2024 Brian S. Stephan <bss@incorporeal.org>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

include <parameters.scad>
include <components.scad>
use <frame-piece-top-left-or-right.scad>
use <frame-piece-bottom-left-or-right.scad>
use <frame-left.scad>


module side_frame_piece() {
	piece_width = panel_support_width+frame_wall+frame_mount_column_width;
	difference() {
		// side piece is left/right agnostic
		left_frame();
		// minus the top and bottom
		top_left_or_right_frame_piece();
		bottom_left_or_right_frame_piece();
		// and just chop out the rest of the frame
		translate([piece_width, 0, 0]) cube([frame_x, frame_y+1, frame_z+1], center=true);
        translate([frame_wall, 0, -frame_z/2+2]) cube([frame_x, frame_y+1, 10], anchor=TOP);
	}
}

side_frame_piece();
