/*
 * SPDX-FileCopyrightText: © 2023 Brian S. Stephan <bss@incorporeal.org>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

include <parameters.scad>
include <components.scad>
include <kailhsocket.scad>
//translate([0,0,-2.2-1.2]) import("F:/Custom Controller/SW_Kailh_Choc_V1.stl");
*translate([0,0,5.8])rotate([180,0,0])import ("F:/Custom Controller/slimbox-2040-stickless-all-button-low-profile-fightstick-model_files/Buttons/KailhKeycap.stl");

module switch_plate_mount() {
	translate([panel_x/2-switch_plate_offset, panel_y/2-switch_plate_offset, 0]) m3_mount_post();
	translate([panel_x/2-switch_plate_offset, -panel_y/2+switch_plate_offset, 0]) m3_mount_post();
	translate([-panel_x/2+switch_plate_offset, panel_y/2-switch_plate_offset, 0]) m3_mount_post();
	translate([-panel_x/2+switch_plate_offset, -panel_y/2+switch_plate_offset, 0]) m3_mount_post();
}

module switch_plate() {
    translate([-(panel_x-switch_plate_offset*2+10)/2,-(panel_y-switch_plate_offset*2+10)/2,0]) cube([panel_x-switch_plate_offset*2+10, panel_y-switch_plate_offset*2+10, 1.3+1], center=false);
}


module keyswitch_24mm_hole() {
    translate([-13.8/2,-13.8/2,-15]) cube([13.8, 13.8, 30], center=false); 
    translate([-15.25/2,-15.2/2,1.3])  cube([15.25, 15.25, 15], center=false); 
    difference () {
        translate([0,0,1]) cylinder(r=big_button_radius, h=15, $fn=50, center=false);
        translate([-18/2,-18/2,0]) cube([18, 18, 15], center=false); 

    }



}

module keyswitch_24mm() {
    translate([0,0,panel_z/2-3+0.2]){
        difference(){
            union()
            {
                translate([0,0,5]) cylinder(r=big_button_radius, h=24, $fn=50, center=false);
                translate([0,0,2])cylinder(r1=small_button_radius, r2=big_button_radius, h=3, $fn=50, center=false);
                translate([0,0,-1])cylinder(r=small_button_radius, h=3, $fn=50, center=false);
                cube([13.8, 13.8, 30], center=true);
                translate([-13.8/2,-50/2,-1-0.2])cube([13.8, 50, 0.2], center=false);
            }
        }
    }
}

module top_panel_left_custom() {

	difference() {
		panel_with_raised_overhang();

        //keyswitch_24mm();
        
        translate([-20, panel_y/6,0]) {
            button_24mm_hole();
            translate([29.5, 0, 0]) button_24mm_hole();
            translate([29.5+26.3, -12.9, 0]) button_24mm_hole();
            // pinky (touchpad) button
            translate([-29.5, -8, 0]) button_24mm_hole();
            // W up button
            translate([36, 28, 0]) button_24mm_hole();
            // thumb buttons
            translate([29.5+26.3+15.5, -65.2, 0]) button_24mm_hole();
            translate([26.3+15.5, -65.2+8, 0]) button_24mm_hole();
        }
		side_chopper();
	}

    //translate([-15, -40, -(panel_z/2) - 3]) rotate([0, 0, -45]) pcb_mount();
    //translate([0, 0, -(panel_z/2) - 3]) color("blue") switch_plate_mount();
    translate([0, 0, -(panel_z/2) - 3]) rotate([180,0,0]){
        //insert(CNCKM3);
        insert_boss(CNCKM3, 6, wall = 3 * extrusion_width);
    }

}

module top_panel_left_switch_plate() {
    translate([0, 0, 0]) {
        color("blue", 0.2) switch_plate();
    }
    translate([-20, panel_y/6,-4.85]) 
        {
            translate([0,0,2.2+0.8/2]) import("F:/Custom Controller/SW_Kailh_Choc_V1.stl");

            kailh_choc_single_plate();
            translate([29.5, 0, 0]) kailh_choc_single_plate();
            translate([29.5+26.3, -12.9, 0]) kailh_choc_single_plate();
            // pinky (touchpad) button
            translate([-29.5, -8, 0]) kailh_choc_single_plate();
            // W up button
            translate([36, 28, 0]) kailh_choc_single_plate();
            // thumb buttons
            translate([29.5+26.3+15.5, -65.2, 0]) kailh_choc_single_plate();
            translate([26.3+15.5, -65.2+8, 0]) kailh_choc_single_plate();
        }
}



top_panel_left_custom();
top_panel_left_switch_plate();

*intersection(){
top_panel_left_custom();
top_panel_left_switch_plate();
}