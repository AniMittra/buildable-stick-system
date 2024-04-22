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
        translate([0,44,0]) {
            translate([29.5/2, 0, 0]) button_24mm_hole();
            //translate([0, -29.5, 0]) button_24mm_hole();
            translate([-29.5/2, 0, 0]) button_24mm_hole();
        }
        
        translate([0,77.5,0]) {
            oled_ssd1306_mount_cutout();
            oled_ssd1306_mount();
        }
		rotate([0, 0, 180]) mid_side_chopper();
		mid_side_chopper();
	}
	translate([0, -25, -(panel_z/2) - 3]) rotate([0,0,90]) pcb_mount();
}

top_panel_middle_custom();
