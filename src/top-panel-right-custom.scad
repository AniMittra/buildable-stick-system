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

buttonsOffset=[-panel_x/2+(24/2)+12,-panel_y/2-(24/2)-24,0];

buttonPlacements = [
    //from psd
    // punches
    [25.9-5, 155+6],
    [50.2, 165.39],
    [76.89+2, 161.1],
    [102.19+4, 149.5],
    // kicks
    [20.9-5, 125.99+6],
    [44.8, 136.39],
    [71.8+2, 132.1],
    [97.19+4, 120.19],
    // thumb
    [10.1, 94.8],
    [37.9, 104.69],
    // dual direction
    [30.79-5, 182.1+6],
    [55.09, 192.49],
    [81.8+2, 188.2]
    
];

switchPlateHoles = [
    [panel_to_frame_point_x, panel_to_frame_point_y, 0],
    [-panel_to_frame_point_x, panel_to_frame_point_y, 0],
    [panel_to_frame_point_x, -panel_to_frame_point_y, 0],
    [-panel_to_frame_point_x, -panel_to_frame_point_y, 0],
    
];

module switch_plate(depth=1.3, underside=0) {
    diff("remove") 
    {
        tag("switch_plate_top") cube([panel_x-switch_plate_offset*2, panel_y-switch_plate_offset*2, depth], anchor=BOTTOM);
        tag("switch_plate_underside") cube([panel_x-switch_plate_offset*2, panel_y-switch_plate_offset*2, underside], anchor=TOP) 
        {
            // corner cutouts
            *tag("remove") align(CENTER, [RIGHT+FRONT, LEFT+FRONT, RIGHT+BACK, LEFT+BACK]) cube([frame_mount_column_width-panel_support_width,frame_mount_column_width-panel_support_width,50], anchor=CENTER);
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

module top_panel_right_switch_plate(references=false) {
    tag("switch_plate") 
    {    
        down(switchPlateZ+panel_z*1.5) 
        {
            difference() 
            {
                tag("plate") color("blue", 1) switch_plate(switchPlateZ);
                
                tag("switch_holes") translate(buttonsOffset)
                fwd(buttonPlacementAdjustment)
                for (i = [ 0 : len(buttonPlacements) - 1 ]) 
                {
                    point=buttonPlacements[i];
                    translate([point[0],point[1],0])
                    {
                        cuboid([17.8,17.8,50]);
                    }
                }
            }
        }
        
        translate(buttonsOffset) 
        fwd(buttonPlacementAdjustment)
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


module top_panel_right_custom() {
    tag("top_panel")
    {
        difference() 
        {
            panel_with_raised_overhang();
            translate(buttonsOffset) 
            fwd(buttonPlacementAdjustment)
            {            
                for (i = [ 0 : len(buttonPlacements) - 1 ]) 
                {
                    point=buttonPlacements[i];
                    translate([point[0],point[1],0])
                    {
                        *button_24mm_hole();
                        button_24mm_keycap_hole();

                    }
                }
            }
            side_chopper();
        }
        //translate([0, 0, -panel_z/2]) zflip() color("blue") switch_plate_mount();
    }
}

top_panel_right_custom();
*top_panel_right_switch_plate(references=false);
