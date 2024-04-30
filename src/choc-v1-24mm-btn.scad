include <BOSL2/constants.scad>
use <BOSL2/masks3d.scad>
include <BOSL2/std.scad>
use <BOSL2/transforms.scad>
include <BOSL2/threading.scad>
include <BOSL2/screws.scad>


include <parameters.scad>
include <components.scad>
include <kailhsocket.scad>

*translate([0,0,0])rotate([0,0,0])import ("F:/Custom Controller/BUTTAFINGA+ROUND+ARCADE+STICK+BUTTONS/BF24flat.stl");
*translate([0,0,0])rotate([0,0,0])import ("F:/Custom Controller/BUTTAFINGA+ROUND+ARCADE+STICK+BUTTONS/BF24ring.stl");
*translate([0,0,0])rotate([0,0,0])import ("F:/Custom Controller/BUTTAFINGA+ROUND+ARCADE+STICK+BUTTONS/24mm_housing.stl");
$fa=0.1;
$fs=0.1;
housing_radius=24/2;
housing_inner_radius=20/2;
housing_chamfer=25;
housing_height=12.0;
housing_thickness=2;
thread_distance=1.2;
housing_lip_radius=27.3/2;
housing_lip_chamfer=25;
housing_lip_height=2.1;
housing_feet_radius=4/2;
housing_feet_height=0.7;
housing_feet_inner_radius=1.43/2;
switch_x=13.8;
switch_y=13.8;
switch_housing_relief=1.6;
switch_base_height=2.2;

module choc_v1_24mm_housing() {
    switch_frame_x=17.8;
    switch_frame_y=17.8;
    switch_frame_z=4.85;
    switch_upper_x=15;
    switch_upper_y=15;
    switch_upper_z=5.8;
    switch_hole_x=13.8;
    switch_hole_y=13.8;
    switch_z=5.8+2.2+2.65;
    plastic_pin_z=2.65;
    metal_pin_z=3;
    switch_upper_lip_z=0.80;
    switch_lower_lip_x=14.5;
    switch_lower_lip_y=13.8;
    switch_lower_lip_z=0.90;
    
    
    *translate([0,0,2.2+0.8/2]) import("F:/Custom Controller/SW_Kailh_Choc_V1.stl");
    *kailh_choc_single_plate();
    // subtract the keyswitch holes
    *translate([-switch_x/2,-switch_y/2,switch_frame_z+switch_upper_lip_z]) kailh_choc_switch();
    // subtract the hotswap holes and recess
    *translate([-base_x/2-5,base_y/2-3.8,0]) kailh_hot_swap_choc(10);
            
    
    diff(){
        tag("body") union()
        {
            // main thread body
             up(housing_feet_height){
                *tag("housing") cyl(r=housing_inner_radius+housing_thickness, h=housing_height, center=false);
                tag("thread") up(housing_height/2) threaded_rod(d=24, height=housing_height, pitch=3);
                *tag("screw") up(housing_height/2) screw("M24", head="none",length=housing_height, atype="screw", bevel=false, blunt_start2=false);
                screw=screw_info("M24");
                thread=thread_specification(screw);
                echo(thread);
                // switch base is right underneath the upper lip (2.2mm from where pins start)
                up(switch_base_height) 
                {
                    // housing relief
                    tag("relief") 
                    {
                        tag("remove") zrot(45) cuboid([25, switch_housing_relief, housing_height-switch_base_height-1], rounding=switch_housing_relief/2, anchor=BOTTOM); 
                        tag("remove") zrot(-45) cuboid([25, switch_housing_relief, housing_height-switch_base_height-1], rounding=switch_housing_relief/2, anchor=BOTTOM); 
                        // square switch cutout
                        *tag("remove") cube([13.8, 13.8, 50], center=true); 
                        *translate([-18/2,-18/2,0]) cube([18, 18, 15], center=false); 
                        // 13.8 hole through the whole button
                        *tag("remove")  cuboid([13.8, 13.8, 50], anchor=CENTER); 
                        // switch clip frame
                        *tag("remove") cuboid([15.25, 15.25, housing_height-switch_base_height-1], anchor=BOTTOM); 
                        *tag("remove") down(1.3) cuboid([14.5, 13.8, 0.9], anchor=TOP); 
                     }                    
                        // 
                     tag("frame") 
                     {
                        // cylinder hole
                        tag("remove") up(switch_upper_lip_z) cyl(r=housing_inner_radius, h=housing_height, center=false);
                        // create space for the upper part of the switch (above upper lip)
                        tag("remove") cuboid([switch_upper_x,switch_upper_y,switch_upper_z], anchor=BOTTOM);
                        // create space for the bottom lip to clip in to
                        tag("remove") down(switch_base_height-switch_lower_lip_z) cuboid([switch_lower_lip_x,switch_lower_lip_y,switch_lower_lip_z+1], anchor=TOP);
                    }
                    
                // switch hole
                tag("remove") cuboid([switch_hole_x, switch_hole_y, 50], anchor=CENTER); 
                }
            }

            // lip
            tag("lip") up(12.6) cyl(center=false, l=housing_lip_height, r=housing_lip_radius, chamfer2=0.6, chamfang2=45, from_end2=true);  // Default chamfang=45
            // lip hole
            tag("remove") up(12.6) cyl(center=false, l=housing_lip_height, r=housing_inner_radius);  // Default chamfang=45

            // feet
            tag("keep") move([9,1.63,0])difference(){
                cyl(center=false, l=housing_feet_height, r=housing_feet_radius);
                cyl(center=false, l=housing_feet_height, r=housing_feet_inner_radius);
            }
            tag("keep") move([-9,-1.63,0]) difference(){
                cyl(center=false, l=housing_feet_height, r=housing_feet_radius);
                cyl(center=false, l=housing_feet_height, r=housing_feet_inner_radius);
            }
            
        }
    }
}

choc_v1_24mm_housing();