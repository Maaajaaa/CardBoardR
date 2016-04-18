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

module UShapeCardPer(height, width, depth, u_depth, mount_depth, cardPer_thickness, radius_outer, radius_inner)
{
    /*CardPer Window*//*
    radius_middle=(radius_outer+radius_inner)/2;
    radius_outerMiddle=(radius_outer+radius_middle)/2;
    difference()
    {
        //outer part
        UShape(height, width, depth, u_width, base_height, radius_outer, radius_inner);
        //cardper part
        translate([0,0,0])UShape(height+0.5, width-base_height, cardPer_thickness, width, base_height, radius_middle, radius_inner);
    }
    /*CardPer U-Slide
    #translate([0,u_width/2,0])UShape(height, width, u_width/2, u_width/4-cardPer_thickness/2, base_height/2-cardPer_thickness/2, radius_outer, radius_middle);
    translate([0,u_width/2,cardPer_thickness])
    UShape(height-cardPer_thickness*2, width-u_width/2-cardPer_thickness, u_width/2, u_width/4-cardPer_thickness/2, 
    base_height/2+cardPer_thickness/2, radius_middle, radius_middle);*/
    
    /*Window*/
    radius_middle=(radius_outer+radius_inner)/2;
    //inner part
    difference()
    {
        //outer frame
        UShape(height, width, u_depth, u_depth+mount_depth, radius_outer, radius_inner);
        //cardper part
        translate([0,0,u_depth])UShape(height, width-2*u_depth, cardPer_thickness, mount_depth*2, radius_inner, radius_inner/1.6);
    }
    
    difference()
    {
        //outer frame
        translate([0,depth/2+u_depth/2+0.00001,0])UShape(height, width, depth, u_depth, radius_outer, radius_inner);
        //cardper part
        mount_pitch = u_depth/2-cardPer_thickness/2;
        translate([0,depth/2+u_depth/2+0.0001,mount_pitch])UShape(height, width-2*mount_pitch, depth, cardPer_thickness, radius_outer, radius_inner);
    }
}

$fn=30;
//UShapeCardPer(height, width, depth, u_depth, mount_depth, cardPer_thickness, radius_outer, radius_inner)
UShapeCardPer(20,20, 2, 1, 2, 0.5, 2, 2/1.62);
//UShape(10, 10, 10, 2, 2, 2/1.62);
module UShape(height, width, u_depth, u_width, radius_outer, radius_inner)
{
    difference()
    {
        //outer part
        minkowski()
        {
            translate([-width/2+radius_outer,-u_depth/2,radius_outer])cube([width-radius_outer*2,u_depth-0.00001,height]);
            rotate([90,0,0])cylinder(0.00001,r=radius_outer);
        }
        //inner part
        translate([0,0,u_width])minkowski()
        {
            translate([(width-2*u_width)/-2+radius_inner,-u_depth/2+0.5,radius_inner])cube([width-u_width*2-radius_inner*2,u_depth,height*1.5]);
            rotate([90,0,0])cylinder(1,r=radius_inner);
        }
        //cut of the too long top at height
        translate([-width/2-.1,-u_depth/2-.1,height])cube([width+.2,u_depth+.2,height]);
        
    }
}

