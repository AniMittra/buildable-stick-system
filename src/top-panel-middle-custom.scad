/*
 * SPDX-FileCopyrightText: © 2023 Brian S. Stephan <bss@incorporeal.org>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

include <parameters.scad>
include <components.scad>
include <kailhsocket.scad>


switchPlateDepth=-6.8;
buttonsOffset=[-mid_panel_x/2+(24/2)-12,-panel_y/2,0];


buttonPlacements = [    
    [mid_panel_x/2-43,panel_y/2-20],
    [mid_panel_x/2-43,panel_y/2+30],

    [mid_panel_x/2+43,panel_y/2-20],
];


switchPlateHoles = [
    [mid_panel_to_frame_point_x, panel_to_frame_point_y, 0],
    [-mid_panel_to_frame_point_x, panel_to_frame_point_y, 0],
    [mid_panel_to_frame_point_x, -panel_to_frame_point_y, 0],
    [-mid_panel_to_frame_point_x, -panel_to_frame_point_y, 0],
];

module middle_switch_plate(depth=1.3, underside=0) {
    diff("remove") 
    {
        tag("switch_plate_top") cube([mid_panel_x-switch_plate_offset*2, panel_y-switch_plate_offset*2, depth], anchor=BOTTOM);
        tag("switch_plate_underside") cube([mid_panel_x-switch_plate_offset*2, panel_y-switch_plate_offset*2, underside], anchor=TOP) 
        {
            // corner holes
            tag("remove") 
            for (i = [ 0 : len(switchPlateHoles) - 1 ]) 
            {
                point=switchPlateHoles[i];
                translate([point[0],point[1],point[2]])
                {
                    m4_hole();
                }
            }
        }
    }
}

module top_panel_middle_switch_plate(references=false) {
    tag("switch_plate") 
    {    
        down(switchPlateZ+panel_z*1.5) 
        {
            difference() 
            {
                tag("plate") color("blue", 1) middle_switch_plate(switchPlateZ);
                
                tag("switch_holes") translate(buttonsOffset)
                for (i = [ 0 : len(buttonPlacements) - 1 ]) 
                {
                    point=buttonPlacements[i];
                    translate([point[0],point[1],0])
                    {
                        cuboid([17.8,17.8,50]);
                    }
                }
                
                tag("pcb_cutout") {
                    translate([0, 0, -(panel_z/2) - 3])
                    cuboid([60,120,50]);
                }
                
                tag("oled_cutout") {
                    translate([42,panel_y/2-50,0]) 
                    cuboid([36,34,50]);
                }
            }
        }
        
        translate(buttonsOffset) 
        {    
            tag("single_switch_frames") translate([0, 0, 0]) 
            {
                for (i = [ 0 : len(buttonPlacements) - 1 ]) 
                {
                    point=buttonPlacements[i];
                    translate([point[0],point[1], -4.85-2.2])
                    {
                        kailh_choc_single_frame(false, 2.5);
                        down(0.45) 
                        diff() prismoid(size1=[25,25], size2=[20,20], h=2.5+0.45, anchor=BOTTOM) {
                            // cutout
                            tag("remove") cube([17.8,17.8,10], anchor=CENTER);
                            }
                    }
                    
                    if(i==0 && references==true) tag("references") 
                    {
                        translate([point[0],point[1],2.2+switchPlateDepth]) yflip() xflip()  import("F:/Custom Controller/SW_Kailh_Choc_V1.stl");
                        
                       
                        *translate([point[0]-11.25, point[1]-11.25, -switchPlateDepth]) xrot(-90) import ("F:/Custom Controller/choc_v1_22.5mm_v2.stl");
                        
                        
                       translate([point[0],point[1],-switchPlateDepth]) zflip() import ("F:/Custom Controller/slimbox-2040-stickless-all-button-low-profile-fightstick-model_files/Buttons/KailhKeycap.stl");
                    }
                }
            }
        }
    }
}


module top_panel_middle_custom() {
    difference() {
//		middle_panel();
        middle_panel_with_raised_overhang();
        
        translate(buttonsOffset)
        for (i = [ 0 : len(buttonPlacements) - 1 ]) 
        {
            point=buttonPlacements[i];
            translate([point[0],point[1],0])
            {
                button_24mm_hole();        
            }
        }
        
        translate([42,panel_y/2-50,0]) {
            oled_sh1106_mount_cutout();
        }

		rotate([0, 0, 180]) mid_side_chopper();
		mid_side_chopper();
	}
    translate([42,panel_y/2-50,0]) {
        oled_sh1106_mount();
        *translate([-35.4/2,-33.5/2,-5]) import ("F:/Custom Controller/graphical-oled-display-128x64-1.stl");
        }
	
    tag("pcb") fwd(0) right(0) zrot(90){
        translate([0, 0, -(panel_z/2) - 3]) pcb_mount();
        
       * yflip() translate([-48, -22, -10]) zflip()  
        import ("F:/Custom Controller/RP2040 Advanced Breakout Board - Version 5.stl");
    }
    
    tag("middle_panel_height_extension") {
        down(switchPlateZ) intersection() {
            middle_panel_with_raised_overhang();
            down(5+2.5) cube([200, 200, switchPlateZ], anchor=BOTTOM);
        }
    }
}

top_panel_middle_custom();
*top_panel_middle_switch_plate(references=false);

