include <parameters.scad>
include <components.scad>

$fn=60;

//hotswap
$slop=0.0;

cyl_h=10.05;
cyl_d=3+$slop;

choc_hole_h=3;
choc_main_hole_d=3.8+$slop;
choc_side_hole_d=1.9+$slop;
choc_contact_hole_d=1.2+$slop;

base_x=4.75+$slop;
base_x_sum=9.55+$slop;
base_y=4.65+$slop;
base_y_sum=6.85+$slop;
base_z=1.8+$slop;

clip_x=1.68+$slop;
clip_y=(13.15-9.95)/2+$slop*2;
clip_z=1.85+$slop;

switch_x=15;
switch_y=15;
switch_z=5.8+2.2+2.65;
plastic_pin_z=2.65;
metal_pin_z=3;
switch_upper_lip_z=0.80;

switch_frame_x=17.8;
switch_frame_y=17.8;
switch_frame_z=4.85;
switch_frame_inner_x=switch_x+0.25+$slop;
switch_frame_inner_y=switch_y+0.25+$slop;
switch_frame_inner_z=switch_upper_lip_z+0.25+$slop;

switch_recess_x=13.8+$slop;
switch_recess_y=13.8+$slop;
switch_recess_z=2.2;
switch_lower_lip_x=14.5+$slop;
switch_lower_lip_y=switch_recess_y;
switch_lower_lip_z=0.90+$slop;



//based on:
//https://www.kailhswitch.com/Content/upload/pdf/201915927/CPG135001D03_-_White_Clicky_Choc.pdf  
module kailh_choc_switch(){
    rotate([0,180,-90])

    color("orange")
    union(){
        cube([15,15,0.8]);
        translate([0.6,0.7,0.8])
        cube([13.8,13.6,2.2]);
        
        translate([7.5,7.5,3]){
            cylinder(h=choc_hole_h,d=choc_main_hole_d);
            
            translate([0,+5.5,0])
            cylinder(h=choc_hole_h,d=choc_side_hole_d);
            translate([0,-5.5,0])
            cylinder(h=choc_hole_h,d=choc_side_hole_d);
            
            //contacts
            translate([-5.9,0,0])
            cylinder(h=choc_hole_h,d=choc_contact_hole_d);
            translate([-3.8,-5,0])
            cylinder(h=choc_hole_h,d=choc_contact_hole_d);
        }
    }
}

//based on:
//https://www.kailhswitch.com/Content/upload/pdf/202115927/CPG135001S30-data-sheet.pdf
module kailh_hot_swap_choc(extend_cables=0){
    translate([-base_x/2-5,base_y/2-3.8,0])
    mirror([0,0,1]) rotate([180,0,0]) union()
    {
        //plastic
        color("pink"){
            cube([base_x,base_y,base_z]);
            
            translate([base_x_sum-base_x,base_y_sum-base_y,0])
            cube([base_x,base_y,base_z]);
            
            translate([base_x/2,base_y/2,0]){
                cylinder(h=cyl_h,d=cyl_d);
                translate([5,2.2,0])
                cylinder(h=cyl_h,d=cyl_d);
            }
            translate([base_x,0,0])
            rotate([0,0,45])
            cube([base_x,base_y,base_z]);
        }
    
        //metal
        color("gray"){
            translate([-clip_x-extend_cables,base_y/2-clip_y/2,0])
            cube([clip_x+base_y/2+extend_cables, clip_y, clip_z]);
            translate([base_x_sum-base_y/2,base_y_sum-base_y/2-clip_y/2,0])
            cube([clip_x+base_y/2+extend_cables, clip_y, clip_z]);
        }
    }
}

module kailh_choc_single_plate(showFeet=false) {
    diff("remove"){
        tag("switch-housing") attachable() {            
            // main cube box
//            translate([-switch_frame_x/2, -switch_frame_y/2, 0])
            tag("main-housing")  color("blue", 0.5)
            cube([switch_frame_x,switch_frame_y,switch_frame_z], anchor=BOTTOM)
            if(showFeet)
            {
                diff("text")
                attach([LEFT,RIGHT],BACK,align=TOP)
                cube([switch_frame_x,5,10])
                up(2) xflip() attach(FRONT, TOP, inside=true) 
                tag("text") linear_extrude(1.2) 
                {
                    text(
                        text=format_fixed($slop,2),
                        size=5,
                        halign="center",
                        valign="center"
                        );
                }
            }            
        
            

            
            // framing border 
            union() {
                tag("switch-framing") up(switch_frame_z) color("orange", 0.5)
                difference() {
                    cuboid([switch_frame_x,switch_frame_y,switch_frame_inner_z], anchor=BOTTOM);
                    cuboid([switch_frame_inner_x,switch_frame_inner_y,10], anchor=BOTTOM);
                }
                
            }
        }
        // recess from the top so keyswitch can sit in
        tag("remove") translate([-switch_recess_x/2, -switch_recess_y/2, plastic_pin_z]) cube([switch_recess_x,switch_recess_y,switch_recess_z]);
        // create space for the bottom lip to clip in to
        tag("remove") translate([-switch_lower_lip_x/2, -switch_lower_lip_y/2, plastic_pin_z]) cube([switch_lower_lip_x,switch_lower_lip_y,switch_lower_lip_z]);

        // subtract the keyswitch holes
        tag("remove") translate([-switch_x/2,-switch_y/2,switch_frame_z+switch_upper_lip_z]) kailh_choc_switch();
        // subtract the hotswap holes and recess
        tag("remove") kailh_hot_swap_choc(0);
        // let's not leave room for 3d print issue with hot swap edge
        tag("remove") {
            translate([0,-2.5,0]) cuboid([switch_frame_x,switch_frame_y/2,clip_z], anchor=BOTTOM+BACK);
        }
        

    }
}

//kailh_choc_switch();
*translate([0,0,2.2+0.8/2]) rotate([0,0,180]) import("F:/Custom Controller/SW_Kailh_Choc_V1.stl");
kailh_choc_single_plate(showFeet=true);
//#kailh_hot_swap_choc(0);