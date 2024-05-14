/*
 * SPDX-FileCopyrightText: © 2023 Brian S. Stephan <bss@incorporeal.org>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

include <parameters.scad>
include <components.scad>



module top_panel_middle_custom() {
    difference() {
		middle_panel();
		//dir_arc_w_30mm();
        translate([0,panel_y/2-75,0]) {
        xcopies(29.5, n=3) button_24mm_hole();
//            left(29.5/2) button_24mm_hole();
            //translate([0, -29.5, 0]) button_24mm_hole();
//            right(29.5/2) button_24mm_hole();
        }
        
        translate([0,panel_y/2-35,0]) {
            oled_sh1106_mount_cutout();
        }

		rotate([0, 0, 180]) mid_side_chopper();
		mid_side_chopper();
	}
    translate([0,panel_y/2-35,0]) {
        oled_sh1106_mount();
        *translate([-35.4/2,-33.5/2,-20]) import ("F:/Custom Controller/graphical-oled-display-128x64-1.stl");
        }
	translate([0, -panel_y/2+45, -(panel_z/2) - 3]) rotate([0,0,0]) pcb_mount();
}

top_panel_middle_custom();
