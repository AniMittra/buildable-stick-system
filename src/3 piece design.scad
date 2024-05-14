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

use <bottom-panel-inset.scad>
use <bottom-panel-inset-middle-custom.scad>



//hide("middle")
//hide("right")

//xrot(45) yrot(-90)
tag("3-panel-design") {
    #tag("top_panel") color("brown") {
        tag("left") translate([-panel_x/2-mid_panel_x/2,0,frame_z/2-panel_z/2+switchPlateZ]) top_panel_left_custom();
        *tag("middle") translate([0,0,frame_z/2-panel_z/2]) top_panel_middle_custom();
        *tag("right") translate([panel_x/2+mid_panel_x/2,0,frame_z/2-panel_z/2]) top_panel_right_custom();
    }

    tag("top_switch_plates") color("orange") {
        tag("left") translate([-panel_x/2-mid_panel_x/2,0,frame_z/2-panel_z/2+switchPlateZ]) top_panel_left_switch_plate();
        //tag("middle") translate([0,0,frame_z/2-panel_z/2]) top_panel_middle_custom();
        //tag("right") translate([panel_x/2+mid_panel_x/2,0,frame_z/2-panel_z/2]) top_panel_right_custom();
    }

    tag("top_frame") color("black") {
        tag("left") translate([-panel_x/2-mid_panel_x/2, 0, ]) top_left_frame_piece();
        *tag("middle") translate([0, 0, 0]) top_middle_frame_piece();
        *tag("right") translate([panel_x/2+mid_panel_x/2, 0, 0]) top_right_frame_piece();
    }

    tag("bottom_frame") color("blue") {
        tag("left") translate([-panel_x/2-mid_panel_x/2, 0, 0]) bottom_left_or_right_frame_piece();
        *tag("middle") translate([0, 0, 0]) bottom_middle_frame_piece();
        *tag("right") translate([panel_x/2+mid_panel_x/2, 0, 0]) bottom_left_or_right_frame_piece();
    }

    tag("side_frame") color("green") {
        tag("left") translate([-panel_x/2-mid_panel_x/2, 0, 0]) side_frame_piece();
        *tag("right") translate([panel_x/2+mid_panel_x/2, 0, 0]) rotate([0, 0, 180]) side_frame_piece();

        tag("middle") translate([-mid_panel_x/2, 0, 0]) interconnect_frame_piece();
        *tag("middle") translate([mid_panel_x/2, 0, 0]) interconnect_frame_piece();
    }

    *tag("bottom_panel") color("yellow") {
        tag("left") translate([-panel_x/2-mid_panel_x/2, 0, -frame_z/2+panel_z/2]) bottom_panel();
        tag("middle") translate([0, 0, -frame_z/2+panel_z/2]) middle_bottom_panel();
        tag("right") translate([panel_x/2+mid_panel_x/2, 0, -frame_z/2+panel_z/2]) bottom_panel();
    }
}
