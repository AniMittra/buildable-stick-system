/*
 * SPDX-FileCopyrightText: © 2023 Brian S. Stephan <bss@incorporeal.org>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

include <parameters.scad>
include <components.scad>

module top_panel_left_custom() {
	difference() {
		panel_with_raised_overhang();
        //translate([-80.5, panel_y/6, 0])
        translate([0, panel_y/6,0]) {
            dir_arc_24mm_directionals();
            
            translate([36, 28, 0]) button_24mm_hole();
        }
        
		side_chopper();
	}
    translate([-15, -40, -(panel_z/2) - 3]) rotate([0, 0, -45]) pcb_mount();

}

top_panel_left_custom();
