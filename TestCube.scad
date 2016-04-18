cube_length = 20;

//mountParts settings
mount_height = 2;
base_height = 1;
length = cube_length-2;
space_width0 = 0.6; //front
space_width1 = 0.65; //left
space_width2 = 0.7; //right
space_width3 = 0.75; //back
space_width4 = 0.8; //bottom
outer_width = 1.6;
offset_width = (outer_width-base_height)/2;

include<CardBoardLibrary.scad>

//front
frame(cube_length, cube_length, mount_height, base_height, space_width0, outer_width);
//left
translate([offset_width,-offset_width,0])rotate([0,0,-90])color("blue")frame(cube_length, cube_length, mount_height, base_height, space_width1, outer_width);
//right
translate([offset_width,cube_length-base_height+offset_width,0])rotate([0,0,-90])color("blue")frame(cube_length, cube_length, mount_height, base_height, space_width2, outer_width);
//back
translate([cube_length-base_height+2*offset_width,0,0])frame(cube_length, cube_length, mount_height, base_height, space_width3, outer_width);
//bottom
translate([-offset_width,-offset_width*4,-space_width4/2])rotate([-90,-90,0])color("red")frame(cube_length+offset_width, cube_length+4*offset_width, mount_height, base_height, space_width4, outer_width);


module frame(frame_height,frame_length, mount_height, base_height, space_width, thickness)
{
    translate([0,base_height-base_height/2,0])linearCardBoardMount(frame_length-2*base_height, mount_height+base_height, base_height, thickness, space_width,"X");
    translate([0,-base_height/2,base_height])rotate([90,0,180])linearCardBoardMount(frame_height, mount_height+base_height, base_height, thickness, space_width,"X");
    translate([0,frame_length-base_height/2,base_height])rotate([90,0,0])linearCardBoardMount(frame_height, mount_height+base_height, base_height, thickness, space_width,"X");
}