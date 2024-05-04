

include <parameters.scad>
include <components.scad>
include <kailhsocket.scad>


$fa=0.1;
$fs=0.1;
housing_radius=24/2;
housing_inner_radius=20.25/2;
housing_chamfer=25;
housing_height=12.0;
housing_thickness=2;
thread_distance=1.2;
housing_lip_radius=27.3/2;
housing_lip_chamfer=25;
housing_lip_height=2.1;
housing_feet_radius=4/2;
housing_feet_height=0.8;
housing_feet_inner_radius=1.43/2;
switch_x=13.8;
switch_y=13.8;
switch_housing_relief=2;
switch_base_height=2.2;

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

plunger_radius=19.5/2;
plunger_height=housing_height;
choc_v1_stem_x=1.2;
choc_v1_stem_y=3.0;
choc_v1_stem_z=4;
choc_v1_stem_chamfer=0.2;
choc_v1_upper_z=5.8;
choc_v1_switch_z=3.0;
plunger_brace_x=8.9;
plunger_brace_y=1.5;
plunger_brace_z=0.70;


module references()
{
    *translate([0,0,housing_height+housing_feet_height])rotate([180,0,0])import ("F:/Custom Controller/slimbox-2040-stickless-all-button-low-profile-fightstick-model_files/Buttons/KailhKeycap.stl");
    
    *left(100) fwd(63) up(housing_feet_height) import ("F:/Custom Controller/Hardware/OSBMX/Other Configurations/OSBMX 24 - Single Housing.stl");
    
    *left(35.25*2) up(housing_feet_height) import ("F:/Custom Controller/OSBCH-main/OSBCH-main/STL Files/Body.stl");

    *left(236) fwd(190) down(5) import ("F:/Custom Controller/BUTTAFINGA+ROUND+ARCADE+STICK+BUTTONS/BF24ring.stl");
    
    *right(0) up(0) import ("F:/Custom Controller/BUTTAFINGA+ROUND+ARCADE+STICK+BUTTONS/24mm_housing.stl");
    
    *up(housing_feet_height+switch_base_height+5.8-3) import ("F:/Custom Controller/BUTTAFINGA+ROUND+ARCADE+STICK+BUTTONS/24mm_choc_v1_cap.stl");
    
    *up(housing_feet_height+5.2) import ("F:/Custom Controller/sanwa_24mm_plunger.stl");
    
    *left(35.25) up(10.0) zflip() import ("F:/Custom Controller/button_large.stl");
    
    *left(32.4) back(29) up(13.4) zflip() import ("F:/Custom Controller/choc_button_cap.stl");


    up(housing_feet_height) yflip() xflip() import("F:/Custom Controller/SW_Kailh_Choc_V1.stl");
}

module choc_v1_24mm_plunger() {
    tag("plunger"){
        tag("body") diff("remove")
        {
            up(housing_feet_height+switch_base_height)
            {
                up(choc_v1_upper_z-choc_v1_switch_z) tag("main") cyl(r=plunger_radius, h=plunger_height, anchor=BOTTOM, chamfer2=1);
                // cutout square shape
                tag("remove") up(choc_v1_upper_z+plunger_brace_z) cuboid([16,16,10], anchor=TOP);

            }
        }
        
        // choc v1 stem
        tag("stems") up(housing_feet_height+switch_base_height+choc_v1_upper_z)
        {
            up(plunger_brace_z){
            diff(){
                tag("stem") left(5.7/2) cuboid([choc_v1_stem_x,choc_v1_stem_y,choc_v1_stem_z], anchor=TOP, chamfer=choc_v1_stem_chamfer, edges=[BOTTOM]);
                tag("remove") left(5.7/2-choc_v1_stem_x+choc_v1_stem_chamfer) cuboid([choc_v1_stem_x,1.5,choc_v1_stem_z+1], anchor=TOP, chamfer=choc_v1_stem_chamfer);
                tag("remove") left(5.7/2+choc_v1_stem_x-choc_v1_stem_chamfer) cuboid([choc_v1_stem_x,1.5,choc_v1_stem_z+1], anchor=TOP, chamfer=choc_v1_stem_chamfer);


                
                tag("stem") right(5.7/2) cuboid([choc_v1_stem_x,choc_v1_stem_y,choc_v1_stem_z], anchor=TOP, chamfer=choc_v1_stem_chamfer, edges=[BOTTOM]);
                tag("remove") right(5.7/2-choc_v1_stem_x+choc_v1_stem_chamfer) cuboid([choc_v1_stem_x,1.5,choc_v1_stem_z+1], anchor=TOP, chamfer=choc_v1_stem_chamfer);
                tag("remove") right(5.7/2+choc_v1_stem_x-choc_v1_stem_chamfer) cuboid([choc_v1_stem_x,1.5,choc_v1_stem_z+1], anchor=TOP, chamfer=choc_v1_stem_chamfer);


                }
            // add a brace
            tag("brace") up() cuboid([plunger_brace_x,plunger_brace_y,plunger_brace_z], anchor=TOP);
            }
        }
    }
}

module choc_v1_24mm_housing() {
    $slop=0.00;
    echo(get_slop());
    
    diff(){
        tag("body") union()
        {
            // main thread body
             up(housing_feet_height){
                *tag("trap-thread") up(housing_height/2) trapezoidal_threaded_rod(d=24, height=housing_height, pitch=4, thread_angle=115, thread_depth=1.27, spin=180, blunt_start=false);

             
                *tag("thread") up(housing_height/2) threaded_rod(d=24, height=housing_height, pitch=3);
                
                tag("bottle-thread") intersection() {
                    down(housing_height/2-1) generic_bottle_neck(pitch=3.2, neck_d=housing_inner_radius*2+1, id=0, thread_od=housing_radius*2, height=housing_height*1.5, support_d=0, spin=-16);
                    cyl(r=housing_radius+housing_thickness, h=housing_height, center=false);
                }
                
                // switch base is right underneath the upper lip (2.2mm from where pins start)
                up(switch_base_height) 
                {
                    // housing relief
                    tag("relief") 
                    {
                        tag("remove") zrot(45) cuboid([50, switch_housing_relief+$slop, housing_height-switch_base_height-1+$slop], rounding=switch_housing_relief/2, anchor=BOTTOM); 
                        tag("remove") zrot(-45) cuboid([50, switch_housing_relief+$slop, housing_height-switch_base_height-1+$slop], rounding=switch_housing_relief/2, anchor=BOTTOM); 
                       
                       }                    
                        // 
                     tag("frame") 
                     {
                        // cylinder hole
                        tag("remove") up(switch_upper_lip_z) cyl(r=housing_inner_radius+$slop, h=housing_height, center=false);
                        // create space for the upper part of the switch (above upper lip)
                        tag("remove") cuboid([switch_upper_x+$slop,switch_upper_y+$slop,switch_upper_z], anchor=BOTTOM);
                        // create space for the bottom lip to clip in to
                        tag("remove") down(switch_base_height-switch_lower_lip_z) cuboid([switch_lower_lip_x+$slop,switch_lower_lip_y+$slop,switch_lower_lip_z+1+$slop], anchor=TOP);
                    }
                    
                // switch hole
                tag("remove") cuboid([switch_hole_x+$slop, switch_hole_y+$slop, 50], anchor=CENTER); 
                }
                
                // lip
            *tag("lip") up(housing_height) cyl(center=false, l=housing_lip_height, r=housing_lip_radius, chamfer2=0.6, chamfang2=45, from_end2=true);
            // lip hole
            tag("remove") up(housing_height) cyl(center=false, l=housing_lip_height, r=housing_inner_radius+$slop);
            }

            

            // feet
            *tag("feet") 
            {
                move([9,1.63,0]) {
                    cyl(center=false, l=housing_feet_height, r=housing_feet_radius);
                    tag("remove") cyl(center=false, l=5, r=housing_feet_inner_radius);
                }
                move([-9,-1.63,0]) {
                    cyl(center=false, l=housing_feet_height, r=housing_feet_radius);
                    tag("remove") cyl(center=false, l=5, r=housing_feet_inner_radius);
                }
            }
            
        }
    }
}

module choc_v1_24mm_nut() {
    $slop=0.30;
    echo(get_slop());
    24mm_nut_width=27.5;
    24mm_nut_inner_diameter=24.0;
    24mm_nut_height=9;
    24mm_nut_pitch=4;
    24mm_lip_height=1.2;
    24mm_lip_width=28.1;
    
    //trapezoidal_threaded_nut(nutwidth, id, h|height|thickness, pitch, [thread_angle=|flank_angle=], [thread_depth], ...) [ATTACHMENTS];

    tag("nut") union()
    {
        *tag("trap-nut") up(0) {
            //tag("trap-thread") up(housing_height/2) trapezoidal_threaded_rod(d=24, height=housing_height, pitch=4, thread_angle=115, thread_depth=1.27, blunt_start=false);

            intersection(){ 
                trapezoidal_threaded_nut(nutwidth=24mm_nut_width, id=24mm_nut_inner_diameter, height=24mm_nut_height, pitch=24mm_nut_pitch, thread_angle=115, thread_depth=1.27, blunt_start=false, bevel=true, ibevel=true, $slop=$slop, anchor=BOTTOM);
                generic_bottle_cap(texture="ribbed",neck_od=4, thread_depth=1, wall=24mm_nut_width/2-5, height=24mm_nut_height);
            }
            diff() {
                tag("lip") cyl(r=24mm_lip_width/2, h=24mm_lip_height, anchor=BOTTOM);
                tag("remove") down(5) cyl(r=24mm_nut_inner_diameter/2, h=10, anchor=BOTTOM);

            }
        }
         
        *tag("d24-p3-nut") up(0) {
         //tag("thread") up(housing_height/2) threaded_rod(d=24, height=housing_height, pitch=3);

            intersection(){ 
                threaded_nut(nutwidth=24mm_nut_width, id=24mm_nut_inner_diameter, h=24mm_nut_height, pitch=3, blunt_start=false, bevel=true, ibevel=true, $slop=$slop, anchor=BOTTOM);
                generic_bottle_cap(texture="knurled",neck_od=4, thread_depth=1, wall=24mm_nut_width/2-5, height=24mm_nut_height);
            }
            diff() {
                tag("lip") cyl(r=24mm_lip_width/2, h=24mm_lip_height, anchor=BOTTOM);
                tag("remove") down(5) cyl(r=24mm_nut_inner_diameter/2, h=10, anchor=BOTTOM);

            }
        }
        
        tag("bottle-nut") up(0) {
//            tag("bottle-thread") intersection() {
//                down(housing_height/2-1) generic_bottle_neck(neck_d=housing_inner_radius*2+1, id=0, thread_od=housing_radius*2, height=housing_height*1.5, support_d=0, spin=-16);
//                cyl(r=housing_radius+housing_thickness, h=housing_height, center=false);
//            }

            diff() {
                intersection() {
                    tag("cap") generic_bottle_cap(texture="none",pitch=3.2, neck_od=housing_inner_radius*2+1+$slop, thread_od=housing_radius*2+$slop, wall=1, height=24mm_nut_height*1.5, spin=180+45);
                    *tag("view-threads-helper") cyl(r=housing_radius, h=24mm_nut_height*1.5, anchor=BOTTOM);
                }
               

                tag("lip") cyl(r=24mm_lip_width/2, h=24mm_lip_height, anchor=BOTTOM);
                // lip hole
                tag("remove") down(-24mm_lip_height) cyl(r=(24mm_nut_inner_diameter/2)+$slop, h=24mm_lip_height*2, anchor=TOP);
                // cut off excess bottom
                tag("remove") up(24mm_nut_height) cyl(r=24mm_nut_width, h=24mm_nut_height*1, anchor=BOTTOM);

            }
            // custom knurling
            diff() {
                tag("knurling") zrot_copies([0, 45, 90, 135, 180, 225, 270, 315]) fwd(housing_radius+1.0) cylinder(h=24mm_nut_height, r=1);
                tag("remove") cyl(r=housing_radius+1, h=24mm_nut_height*1.5, anchor=BOTTOM);

            }
        }
    }
}


*references();
*choc_v1_24mm_housing();
*choc_v1_24mm_plunger();
choc_v1_24mm_nut();