/*
 * SPDX-FileCopyrightText: © 2023 Brian S. Stephan <bss@incorporeal.org>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

include <parameters.scad>
include <components.scad>

module bottom_panel_middle_custom() {
	difference() {
		rotate([180, 0, 0]) middle_base_panel_with_raised_overhang();
		rotate([180, 0, 0]) mid_panel_holes();
        // chop the right edge off
		mid_side_chopper();
        rotate([0, 0, 180]) mid_side_chopper();

	}
}

bottom_panel_middle_custom();
