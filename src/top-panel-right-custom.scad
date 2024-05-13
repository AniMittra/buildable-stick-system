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
    //from psd
    // punches
    [25.9, 155],
    [50.2, 165.39],
    [76.89, 161.1],
    [102.19, 149.5],
    // kicks
    [20.9, 125.99],
    [44.8, 136.39],
    [71.8, 132.1],
    [97.19, 120.19],
    // thumb
    [10.1, 94.8],
    [37.9, 104.69],
    // dual direction
    [30.79, 182.1],
    [55.09, 192.49],
    [81.8, 188.2]
    
];


module top_panel_right_custom() {
    tag("top_panel")
    {
        difference() 
        {
            panel();
            translate([-panel_x/2+(24/2),-panel_y/2-(24/2),0]) 
            fwd(buttonPlacementAdjustment)
            {            
                for (i = [ 0 : len(buttonPlacements) - 1 ]) 
                {
                    point=buttonPlacements[i];
                    translate([point[0],point[1],0])
                    {
                        button_24mm_hole();
                    }
                }
            }
            side_chopper();
        }
        //translate([0, 0, -panel_z/2]) zflip() color("blue") switch_plate_mount();
    }
}

top_panel_right_custom();
