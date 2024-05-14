/*
 * SPDX-FileCopyrightText: © 2023 Brian S. Stephan <bss@incorporeal.org>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

include <parameters.scad>
include <components.scad>
include <kailhsocket.scad>

switchPlateDepth=-6.8;
switchPlateMountOffset1=27.5;
switchPlateMountOffset2=15.0;

buttonsOffset=[-panel_x/2+(24/2)-12,-panel_y/2-(24/2)-24,0];

buttonPlacements = [    
    //from psd
    // directions
    [88.8, 180.49],
    [56.4, 155],
    [83.4, 154.69],
    [108.4, 144.1],
    // pinky
    [30.99, 150.1],
    // thumb
    [125.49, 94.8],
    [97.69, 104.69]
];

insertPlacements = [
    [panel_x/2-switchPlateMountOffset1, panel_y/2-switchPlateMountOffset2, 0],
    [panel_x/2-switchPlateMountOffset2, panel_y/2-switchPlateMountOffset1, 0],

    [panel_x/2-switchPlateMountOffset1, -panel_y/2+switchPlateMountOffset2, 0],
    [panel_x/2-switchPlateMountOffset2, -panel_y/2+switchPlateMountOffset1, 0],

    [-panel_x/2+switchPlateMountOffset1, panel_y/2-switchPlateMountOffset2, 0],
    [-panel_x/2+switchPlateMountOffset2, panel_y/2-switchPlateMountOffset1, 0],

    [-panel_x/2+switchPlateMountOffset1, -panel_y/2+switchPlateMountOffset2, 0],
    [-panel_x/2+switchPlateMountOffset2, -panel_y/2+switchPlateMountOffset1, 0],
    
    [panel_x/2-switchPlateMountOffset2, 5, 0],
    [panel_x/2-switchPlateMountOffset2, -5, 0],
    
    [-panel_x/2+switchPlateMountOffset2, 5, 0],
    [-panel_x/2+switchPlateMountOffset2, -5, 0],
    
    
];

switchPlateHoles = [
//		translate([panel_to_frame_point_x, panel_to_frame_point_y, 0]) frame_hex_bolt_hole();

    [panel_to_frame_point_x, panel_to_frame_point_y, 0],
    [-panel_to_frame_point_x, panel_to_frame_point_y, 0],
    [panel_to_frame_point_x, -panel_to_frame_point_y, 0],
    [-panel_to_frame_point_x, -panel_to_frame_point_y, 0],
    
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


module keyswitch_24mm_hole() {
    tag("choc_hole") cube([13.8, 13.8, 30], anchor=CENTER); 
    tag("choc_upper_base") up(switchPlateZ)  cube([15.25, 15.25, 15], anchor=BOTTOM); 
    difference () {
        tag("circle_frame") up(switchPlateZ) cylinder(r=big_button_radius, h=15, $fn=50, anchor=BOTTOM);
        tag("choc_frame") up(0) cube([18, 18, 15], anchor=BOTTOM); 

    }
    tag("choc_underside") cube([18, 18, 15], anchor=TOP);
}

module keyswitch_24mm() {
    translate([0,0,panel_z/2-3+0.2]){
        diff(){
            union()
            {
                translate([0,0,5]) cylinder(r=big_button_radius, h=24, $fn=50, center=false);
                translate([0,0,2])cylinder(r1=small_button_radius, r2=big_button_radius, h=3, $fn=50, center=false);
                translate([0,0,-1])cylinder(r=small_button_radius, h=3, $fn=50, center=false);
                tag("remove") cube([13.8, 13.8, 30], center=true);
                translate([-13.8/2,-50/2,-1-0.2])cube([13.8, 50, 0.2], center=false);
            }
        }
    }
}

module top_panel_left_custom() {
    tag("top_panel")
    {
        difference() 
        {
//            panel();
            panel_with_raised_overhang();
            
            translate(buttonsOffset) 
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
        *translate([0, 0, -panel_z/2]) zflip() color("blue") switch_plate_mount();
    }
}

module top_panel_left_switch_plate(references=false) {
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


module top_panel_left_switch_plate_cutout() {
    tag("switch_plate") 
    {    
         intersect("intersect_cutout")
         back_half(500) up(switchPlateDepth+4.85/2-switchPlateZ/2) 
        {
            diff("switch_holes") {
                tag("plate") color("blue", 1.0) {
                    #switch_plate(switchPlateZ+1,3);
                }
                
                translate([-panel_x/2+(24/2),-panel_y/2-(24/2),0]) 
                fwd(buttonPlacementAdjustment)
                for (i = [ 0 : len(buttonPlacements) - 1 ]) 
                {
                    point=buttonPlacements[i];
                    translate([point[0],point[1],0])
                    {
                         force_tag("switch_holes") up(0) keyswitch_24mm_hole();
                    }
                }
            }
            
            tag("intersect_cutout") {
                translate([-panel_x/2+(24/2),-panel_y/2-(24/2),0]) 
                fwd(buttonPlacementAdjustment)
                for (i = [ 0 : len(buttonPlacements) - 1 ]) 
                {
                    point=buttonPlacements[i];
                    translate([point[0],point[1],0])
                    {
                         up(0) cyl(d=30+5, h=50);
                    }
                }
            }
        }
    }
}

top_panel_left_custom();
top_panel_left_switch_plate(references=true);
*top_panel_left_switch_plate_cutout();

*intersection(){
top_panel_left_custom();
top_panel_left_switch_plate();
}