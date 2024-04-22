/*
 * SPDX-FileCopyrightText: © 2023 Brian S. Stephan <bss@incorporeal.org>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

include <parameters.scad>
include <components.scad>

module top_panel_middle_custom() {
    difference() {
		middle_panel_with_raised_overhang();
		//dir_arc_w_30mm();
        translate([29.5, 0, 0]) button_24mm_hole();
        translate([0, 0, 0]) button_24mm_hole();
        translate([-29.5, 0, 0]) button_24mm_hole();

        
        translate([0,75,0]) {
            oled_ssd1306_mount_cutout();
            oled_ssd1306_mount();
        }
		rotate([0, 0, 180]) mid_side_chopper();
		mid_side_chopper();
	}
	translate([0, -40, -(panel_z/2) - 3]) pcb_mount();
}

top_panel_middle_custom();
