$fn=60;

//hotswap
tolerance=0.1;

cyl_h=10.05;
cyl_d=3;

base_x=4.75;
base_x_sum=9.55;
base_y=4.65;
base_y_sum=6.85;
base_z=1.8;

clip_x=1.68;
clip_y=(13.15-9.95)/2;
clip_z=1.85;

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
            cylinder(h=3,d=3.8);
            
            translate([0,+5.5,0])
            cylinder(h=3,d=1.9);
            translate([0,-5.5,0])
            cylinder(h=3,d=1.9);
            
            //contacts
            translate([-5.9,0,0])
            cylinder(h=3,d=1.2);
            translate([-3.8,-5,0])
            cylinder(h=3,d=1.2);
        }
    }
}

//based on:
//https://www.kailhswitch.com/Content/upload/pdf/202115927/CPG135001S30-data-sheet.pdf
module kailh_hot_swap_choc(extend_cables=0){
    mirror([0,0,1]) rotate([180,0,0])
    //rotate([180,0,0])
    //fuck
    union(){
    //plastic
    color("red"){
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

module kailh_choc_single_plate() {
    switch_frame_x=17.8;
    switch_frame_y=17.8;
    switch_frame_z=4.85;
    switch_recess_x=13.8;
    switch_recess_y=13.8;
    switch_recess_z=2.2;
    switch_x=15;
    switch_y=15;
    switch_z=5.8+2.2+2.65;
    plastic_pin_z=2.65;
    metal_pin_z=3;
    switch_upper_lip_z=0.80;
    switch_lower_lip_x=14.5;
    switch_lower_lip_y=switch_recess_y;
    switch_lower_lip_z=0.90;


    difference(){
    // main cube frame
    translate([-switch_frame_x/2, -switch_frame_y/2, 0]) color("blue", 0.5)
    cube([switch_frame_x,switch_frame_y,switch_frame_z]);
    // recess from the top so keyswitch can sit in
    translate([-switch_recess_x/2, -switch_recess_y/2, plastic_pin_z]) cube([switch_recess_x,switch_recess_y,switch_recess_z]);
    // create space for the bottom lip to clip in to
    translate([-switch_lower_lip_x/2, -switch_lower_lip_y/2, plastic_pin_z]) cube([switch_lower_lip_x,switch_lower_lip_y,switch_lower_lip_z]);

    // subtract the keyswitch holes
    translate([-switch_x/2,-switch_y/2,switch_frame_z+switch_upper_lip_z]) kailh_choc_switch();
    // subtract the hotswap holes and recess
    
    //translate([-switch_frame_x/2+3.8-base_y/2-0,-base_x/2+0.9,0]);
    translate([-base_x/2-5,base_y/2-3.8,0])
    kailh_hot_swap_choc(10);
    }
}

//kailh_choc_switch();
//translate([0,0,2.2+0.8/2]) rotate([0,0,180]) import("F:/Custom Controller/SW_Kailh_Choc_V1.stl");
//kailh_choc_single_plate();
//#kailh_hot_swap_choc(0);