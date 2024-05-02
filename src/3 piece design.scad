/*
 * SPDX-FileCopyrightText: © 2023 Brian S. Stephan <bss@incorporeal.org>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

include <parameters.scad>
include <components.scad>

use <frame-piece-bottom-left-or-right.scad>
// x2 side pieces
use <frame-piece-side.scad>
// x2 interconnects
use <frame-piece-interconnect.scad>
//use <frame-piece-top-left-or-right.scad>
// 1 of each of these top pieces
use <frame-piece-top-left.scad>
use <frame-piece-top-middle.scad>
use <frame-piece-top-right.scad>
// x2 of these bottom pieces
use <frame-piece-bottom-left-or-right.scad>
// x1 of these bottom middle piece
use <frame-piece-bottom-middle.scad>


use <top-panel-left-custom.scad>
use <top-panel-middle-custom.scad>
use <top-panel-right-custom.scad>

use <bottom-panel-overhang-left.scad>
use <bottom-panel-overhang-middle-custom.scad>
use <bottom-panel-overhang-right.scad>

tag("top_panel") {
    color("brown") translate([-panel_x/2-mid_panel_x/2,0,frame_z/2]) top_panel_left_custom();
    color("brown") translate([0,0,frame_z/2]) top_panel_middle_custom();
    color("brown") translate([panel_x/2+mid_panel_x/2,0,frame_z/2]) top_panel_right_custom();
}

*tag("top_frame") {
    color("red") translate([-panel_x/2-mid_panel_x/2, 0, ]) top_left_frame_piece();
    color("red")translate([0, 0, 0]) top_middle_frame_piece();
    color("red")translate([panel_x/2+mid_panel_x/2, 0, 0]) top_right_frame_piece();
}

*tag("bottom_frame") {
    color("blue")translate([-panel_x/2-mid_panel_x/2, 0, 0]) bottom_left_or_right_frame_piece();
    color("blue")translate([0, 0, 0]) bottom_middle_frame_piece();
    color("blue")translate([panel_x/2+mid_panel_x/2, 0, 0]) bottom_left_or_right_frame_piece();
}

*tag("side_frame") {
    color("green") translate([-panel_x/2-mid_panel_x/2, 0, 0]) side_frame_piece();
    color("green") translate([panel_x/2+mid_panel_x/2, 0, 0]) rotate([0, 0, 180]) side_frame_piece();

    color("pink")translate([-mid_panel_x/2, 0, 0]) interconnect_frame_piece();
    color("pink")translate([mid_panel_x/2, 0, 0]) interconnect_frame_piece();
}

*tag("bottom_panel") {
    color("yellow") translate([-panel_x/2-mid_panel_x/2, 0, -frame_z/2]) bottom_panel_left();
    color("yellow") translate([0, 0, -frame_z/2]) bottom_panel_middle_custom();
    color("yellow") translate([panel_x/2+mid_panel_x/2, 0, -frame_z/2]) bottom_panel_right();
}
