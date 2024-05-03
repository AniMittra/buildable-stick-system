/*
 * SPDX-FileCopyrightText: © 2023 Brian S. Stephan <bss@incorporeal.org>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

include <parameters.scad>
include <components.scad>
include <kailhsocket.scad>

switchPlateDepth=-6.8;
switchPlateZ=1.3;
switchPlateMountOffset1=25;
switchPlateMountOffset2=12.5;


buttonPlacements = [
    [0,0,0],
    [29.5, 0, 0],
    [29.5+26.3, -12.9, 0],
    [-29.5, -8, 0],
    [36, 28, 0],
    [29.5+26.3+15.5, -65.2, 0],
    [26.3+15.5, -65.2+8, 0]
];

insertPlacements = [
    //[panel_x/2, panel_y/2, 0],
    //[panel_x/2-switch_plate_offset, panel_y/2-switch_plate_offset, 0],
    //[panel_x/2-switch_plate_offset, -panel_y/2+switch_plate_offset, 0],
    //[-panel_x/2+switch_plate_offset, panel_y/2-switch_plate_offset, 0],
    //[-panel_x/2+switch_plate_offset, -panel_y/2+switch_plate_offset, 0]
    [panel_x/2-switchPlateMountOffset1, panel_y/2-switchPlateMountOffset2, 0],
    [panel_x/2-switchPlateMountOffset2, panel_y/2-switchPlateMountOffset1, 0],

    [panel_x/2-switchPlateMountOffset1, -panel_y/2+switchPlateMountOffset2, 0],
    [panel_x/2-switchPlateMountOffset2, -panel_y/2+switchPlateMountOffset1, 0],

    [-panel_x/2+switchPlateMountOffset1, panel_y/2-switchPlateMountOffset2, 0],
    [-panel_x/2+switchPlateMountOffset2, panel_y/2-switchPlateMountOffset1, 0],

    [-panel_x/2+switchPlateMountOffset1, -panel_y/2+switchPlateMountOffset2, 0],
    [-panel_x/2+switchPlateMountOffset2, -panel_y/2+switchPlateMountOffset1, 0],
    
    
];

module button_24mm_hole() {
	cylinder(r=small_button_radius, h=100, $fn=50, center=true);
	// carve out space for snap-ins, leave 3mm
	// slagcoin has screw-in nut diameter at 29.5mm, so radius+3 to leave some space
	// translation is to leave 3mm thickness in the plate without recentering anything
	translate([0, 0, -25]) cylinder(r=small_button_radius+3, h=49, $fn=50, center=true);
	// space for decorative button surround stuff
	translate([0, 0, 50]) cylinder(r=small_button_radius*decorative_radius_scale, h=20, $fn=50, center=true);
	translate([0, 0, 70]) cylinder(r=small_button_radius*jumbo_decorative_radius_scale, h=20, $fn=50, center=true);
}

module switch_plate_mount() {
    
    for (i = [ 0 : len(insertPlacements) - 1 ]) 
    {
        point=insertPlacements[i];
        translate([point[0],point[1],point[2]])
        {
            insert_boss(CNCKM3, panel_z, wall = 3 * extrusion_width);
 
        }
    }
}

module switch_plate() {
    translate([-(panel_x-switch_plate_offset*2+10)/2,-(panel_y-switch_plate_offset*2+10)/2,0]) cube([panel_x-switch_plate_offset*2+10, panel_y-switch_plate_offset*2+10, switchPlateZ], center=false);
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
    tag("top_panel"){
        difference() {
            *panel_with_raised_overhang();
            panel();

            
            translate([-20, panel_y/6,0]) {
            
                for (i = [ 0 : len(buttonPlacements) - 1 ]) 
                {
                      point=buttonPlacements[i];
                      translate([point[0],point[1],point[2]])
                      {
                          button_24mm_hole();
                      }
                }
            }
            side_chopper();
        }

        translate([0, 0, -panel_z/2]) zflip() color("blue") switch_plate_mount();
        
    }
}

module top_panel_left_switch_plate() {
    tag("switch_plate") {
        
        translate([0, 0, switchPlateDepth+4.85/2-switchPlateZ/2]) {
            difference() {
            #color("blue", 0.2) switch_plate();
            translate([-20, panel_y/6,0])
            for (i = [ 0 : len(buttonPlacements) - 1 ]) 
            {
                  point=buttonPlacements[i];
                  translate([point[0],point[1],point[2]])
                  {
                      cuboid([17.0,17.0,50]);
                  }
            }
            }
        }
        translate([-20, panel_y/6,0]) 
            {
                yflip() xflip() translate([0,0,-2.2-1.2-2]) import("F:/Custom Controller/SW_Kailh_Choc_V1.stl");
                *translate([0,0,6.8-2])rotate([180,0,0])import ("F:/Custom Controller/slimbox-2040-stickless-all-button-low-profile-fightstick-model_files/Buttons/KailhKeycap.stl");
                *translate([0,0,6.8])rotate([-90,0,0])import ("F:/Custom Controller/choc_v1_22.5mm_v2.stl");

                translate([0, 0, switchPlateDepth]) {
                    
                    for (i = [ 0 : len(buttonPlacements) - 1 ]) 
                    {
                          point=buttonPlacements[i];
                          translate([point[0],point[1],point[2]])
                          {
                              kailh_choc_single_plate();
                          }
                    }
                }
            }
        }
}



top_panel_left_custom();
top_panel_left_switch_plate();

*intersection(){
top_panel_left_custom();
top_panel_left_switch_plate();
}