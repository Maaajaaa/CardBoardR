/* This is a library for the generation of cardboard mounts for replacing areas of plastic in 3D-printed parts with cardboard.*/

module linearCardBoardMount(length, height, base_height, depth, cardPer_thickness, align = "xcenter")
{
    if(align == "xcenter" || align == "X")
    {
        difference(){
        translate([-depth/2, 0, 0])cube([depth ,length , height]);
        translate([-cardPer_thickness/2, -0.05, base_height])cube([cardPer_thickness , length+1, height+1]);
        }
    }

    if(align == "xycenter" || align == "XY")
    {
        difference(){
        translate([-depth/2, -length/2, 0])cube([depth ,length , height]);
        translate([-cardPer_thickness/2, (-length/2)-0.5, base_height])cube([cardPer_thickness , length+1, height+1]);
        }
    }

    if(align == "center" || align == "XYZ")
    {
        difference(){
        translate([-depth/2, -length/2, -height/2])cube([depth ,length , height]);
        translate([-cardPer_thickness/2, (-length/2)-0.5, ( -height/2)+base_height])cube([cardPer_thickness , length+1, height+1]);}
    }

    if(align == "nocenter" || align == "")
    {
        difference(){
        cube([depth ,length , height]);
        translate([(-cardPer_thickness/2)+width/2, -0.5, base_height])cube([cardPer_thickness , length+1, height+1]);
        }
    }
}

module UShapeCardPer(height, width, depth, u_depth, mount_depth, cardPer_thickness, top_fix_length, radius_outer, radius_inner, backpart=false, round_main_cardPer=false, frontback_full=false)
{
    radius_middle=(radius_outer+radius_inner)/2;
    //front part
    difference()
    {
        //outer frame
        UShape(height, width, u_depth, u_depth+mount_depth, radius_outer, radius_inner,true,frontback_full);
        //cardper part
        if(round_main_cardPer)
          translate([0,0,u_depth])UShape(height-top_fix_length-u_depth, width-2*u_depth, cardPer_thickness, mount_depth*2, radius_inner, radius_inner/1.6);
        else
          translate([-width/2+radius_outer,0,u_depth])cube([width-2*u_depth, cardPer_thickness, height-top_fix_length-u_depth]);
    }
    //middle part
    difference()
    {
        //outer frame
        translate([0,depth/2+u_depth/2+0.00001,0])UShape(height, width, depth, u_depth, radius_outer, radius_inner);
        //cardper part
        mount_pitch = u_depth/2-cardPer_thickness/2;
        if(round_main_cardPer)
          translate([0,depth/2+u_depth/2+0.0001,mount_pitch])UShape(height-mount_pitch-top_fix_length, width-2*mount_pitch, depth, cardPer_thickness, radius_outer, radius_inner);
        else
        {
          translate([-width/2+u_depth/2-cardPer_thickness/2, u_depth/2, mount_pitch+radius_outer])cube([cardPer_thickness,depth,height-radius_outer-mount_pitch-top_fix_length]);
          translate([width/2-u_depth/2-cardPer_thickness/2, u_depth/2, mount_pitch+radius_outer])cube([cardPer_thickness,depth,height-radius_outer-mount_pitch-top_fix_length]);
          translate([-width/2+radius_outer, u_depth/2, u_depth/2-cardPer_thickness/2])cube([width-2*radius_outer,depth,cardPer_thickness]);
        }
    }
    //backpart
    if (backpart)
    {
        translate([0,depth+u_depth,0])rotate([0,0,180])difference()
        {
        //outer frame
        UShape(height, width, u_depth, u_depth+mount_depth, radius_outer, radius_inner,true,frontback_full);
        //cardper part
        if(round_main_cardPer)
          translate([0,0,u_depth])UShape(height-top_fix_length-u_depth, width-2*u_depth, cardPer_thickness, mount_depth*2, radius_inner, radius_inner/1.6);
        else
          translate([0,0,u_depth])UShape(height-top_fix_length-u_depth, width-2*u_depth, cardPer_thickness, mount_depth*2, radius_inner, radius_inner/1.6,false);
        }
    }
}

module UShape(height, width, u_depth, u_width, radius_outer, radius_inner, round=true, inner_part = true)
{
    difference()
    {
        //outer part
        minkowski()
        {
            translate([-width/2+radius_outer,-u_depth/2,radius_outer])cube([width-radius_outer*2,u_depth-0.00001,height]);
            if(round)
              rotate([90,0,0])cylinder(0.00001,r=radius_outer);
            else
              cube([radius_outer*2,0.00001,radius_outer*2],center=true);
        }
        //inner part
        if(inner_part)
        {
          translate([0,0,u_width])minkowski()
          {
              translate([(width-2*u_width)/-2+radius_inner,-u_depth/2+0.5,radius_inner])cube([width-u_width*2-radius_inner*2,u_depth,height*1.5]);
              if(round)
                rotate([90,0,0])cylinder(1,r=radius_inner);
              else
                cube([radius_outer*2,0.00001,0.00001],center=true);
          }
        }
        //cut of the too long top at height
        translate([-width/2-.1,-u_depth/2-.1,height])cube([width+.2,u_depth+.2,height]);

    }
}
