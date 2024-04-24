/*
 * SPDX-FileCopyrightText: © 2023 Brian S. Stephan <bss@incorporeal.org>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

include <parameters.scad>
include <components.scad>
translate([0,0,-2.2-1.2]) import("F:/Custom Controller/SW_Kailh_Choc_V1.stl");
translate([0,0,5.8])rotate([180,0,0])import ("F:/Custom Controller/slimbox-2040-stickless-all-button-low-profile-fightstick-model_files/Buttons/KailhKeycap.stl");

module keyswitch_24mm_hole() {
	cylinder(r=small_button_radius, h=100, $fn=50, center=true);
	// carve out space for snap-ins, leave 3mm
	// slagcoin has screw-in nut diameter at 29.5mm, so radius+3 to leave some space
	// translation is to leave 3mm thickness in the plate without recentering anything
	translate([0, 0, -25]) cylinder(r=small_button_radius+3, h=49, $fn=50, center=true);
	// space for decorative button surround stuff
	translate([0, 0, 50]) cylinder(r=small_button_radius*decorative_radius_scale, h=20, $fn=50, center=true);
	translate([0, 0, 70]) cylinder(r=small_button_radius*jumbo_decorative_radius_scale, h=20, $fn=50, center=true);
}

module keyswitch_24mm() {
    translate([0,0,panel_z/2-3+0.2]){
        difference(){
            union()
            {
                translate([0,0,5]) cylinder(r=big_button_radius, h=24, $fn=50, center=false);
                translate([0,0,2])cylinder(r1=small_button_radius, r2=big_button_radius, h=3, $fn=50, center=false);
                translate([0,0,-1])cylinder(r=small_button_radius, h=3, $fn=50, center=false);
                //translate([0,0,-1.2])cylinder(r=small_button_radius, h=1.2, $fn=50, center=false);

                cube([13.8, 13.8, 30], center=true);
                translate([-13.8/2,-50/2,-1-0.2])cube([13.8, 50, 0.2], center=false);

            }

        }
    }
}

module top_panel_left_custom() {

	difference() {
		panel_with_raised_overhang();

        keyswitch_24mm();
        //translate([-80.5, panel_y/6, 0])
        //keyswitch_24mm_hole();
        /*
        translate([-20, panel_y/6,0]) {
            //dir_arc_24mm_directionals();
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
        */
        
		side_chopper();
	}
    //translate([-15, -40, -(panel_z/2) - 3]) rotate([0, 0, -45]) pcb_mount();
     translate([0,0,0]) intersection(){
        //panel_with_raised_overhang();
        //translate([0,0,2.5])cylinder(r=small_button_radius, h=1, $fn=50, center=false);

        //keyswitch_24mm();
    }

}

top_panel_left_custom();
