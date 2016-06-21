include <CardBoardLibrary.scad>
use <obiscad/bevel.scad>
$fn=20;
height = 25;
width = 25;
depth = 25;
u_depth = 2;
mount_depth = 2;
cardPer_thickness = 0.9;
radius_outer = 2;
radius_inner = 2/1.62;
backpart = true;
closed_top_y = true;

//new option for better continuing
top_fix_length = 0.5;

vertical_pillars = 1;
vertical_pillar_height = 3;
vertical_pillar_offset = 1.5;

horizontal_pillars = 2;
horizontal_pillar_width = 2;
horizontal_pillar_offset = 1;

slide_in_width = 2;

bevel_resolution = 20;
bevel_size = 2;

if(part == "main")
{
  //translate([0,height/2,u_depth/2])rotate([90,0,0])
  difference()
  {
    UShapeCardPer(height, width, depth, u_depth, mount_depth, cardPer_thickness, top_fix_length,
      radius_outer, radius_inner, backpart);

    if(vertical_pillars*vertical_pillar_height < height-radius_outer-vertical_pillar_offset)
    {
        vertical_pillar_space = ((height-radius_outer-vertical_pillar_offset)
        -vertical_pillars*vertical_pillar_height)/vertical_pillars;
        first_vertical_pillar_height = radius_outer+vertical_pillar_offset;

        for(i=[0:vertical_pillars-1])
        {
          cube_size = [width+1, depth - slide_in_width, vertical_pillar_space];

          edge_tl = [ [cube_size[0]/2, cube_size[1], cube_size[2]], [1,0,0], 0];
          normal_tl = [ cube_size[0],                    [1,1,1], 0];

          edge_tr = [ [cube_size[0]/2, 0, cube_size[2]], [1,0,0], 0];
          normal_tr = [ edge_tr[0],                    [0,-1,1], 0];

          edge_bl = [ [cube_size[0]/2, cube_size[1],0], [1,0,0], 0];
          normal_bl = [ edge_bl[0],                    [0,1,-1], 0];

          edge_br = [ [cube_size[0]/2, 0, 0], [1,0,0], 0];
          normal_br = [ edge_tr[0],                    [0,-1,-1], 0];

          translate([-width/2-0.5,u_depth/2+slide_in_width/2, first_vertical_pillar_height
          +i*vertical_pillar_space+i*vertical_pillar_height])difference()
          {
              cube(cube_size);
              //Top-left, Top-right, Bottom-left, Bottom-right
              bevel(edge_tl, normal_tl, cr=bevel_size, cres=bevel_resolution, l=cube_size[0]+2);
              bevel(edge_tr, normal_tr, cr=bevel_size, cres=bevel_resolution, l=cube_size[0]+2);
              bevel(edge_bl, normal_bl, cr=bevel_size, cres=bevel_resolution, l=cube_size[0]+2);
              bevel(edge_br, normal_br, cr=bevel_size, cres=bevel_resolution, l=cube_size[0]+2);
          }
        }
    }
    else
        echo("<b>ERROR</b> too many or too high vertical pillars");

    if(horizontal_pillars*horizontal_pillar_width < height-radius_outer*2-horizontal_pillar_offset*2)
    {
      if(horizontal_pillars == 1)
      ;
      else
      {
        horizontal_pillar_cuts = horizontal_pillars - 1;
        horizontal_pillar_space = ((width-2*radius_outer-2*horizontal_pillar_offset)
        -horizontal_pillar_cuts*horizontal_pillar_width)/(horizontal_pillar_cuts);
        first_horizontal_pillar_x = -(width/2) + horizontal_pillar_offset + radius_outer + horizontal_pillar_width/2;
        for(i=[0:horizontal_pillar_cuts-1])
        {
          cube_size = [horizontal_pillar_space, depth - slide_in_width, u_depth+1];

          edge_tl = [ [0, cube_size[1], cube_size[2]/2], [0,0,1], 0];
          normal_tl = [ edge_tl[0],                    [-1,1,0], 0];

          edge_tr = [ [cube_size[0], cube_size[1], cube_size[2]/2], [0,0,1], 0];
          normal_tr = [ edge_tr[0],                    [1,1,0], 0];

          edge_bl = [ [0, 0, cube_size[2]/2], [0,0,1], 0];
          normal_bl = [ edge_bl[0],                    [-1,-1,0], 0];

          edge_br = [ [cube_size[0], 0, cube_size[2]/2], [0,0,1], 0];
          normal_br = [ edge_tr[0],                    [1,-1,0], 0];

          translate([first_horizontal_pillar_x +
          i*horizontal_pillar_width+i*horizontal_pillar_space,
          u_depth/2+slide_in_width/2,-0.5])difference()
          {
              cube(cube_size);
              //Top-left, Top-right, Bottom-left, Bottom-right
              bevel(edge_tl, normal_tl, cr=bevel_size, cres=bevel_resolution, l=cube_size[2]+2);
              bevel(edge_tr, normal_tr, cr=bevel_size, cres=bevel_resolution, l=cube_size[2]+2);
              bevel(edge_bl, normal_bl, cr=bevel_size, cres=bevel_resolution, l=cube_size[2]+2);
              bevel(edge_br, normal_br, cr=bevel_size, cres=bevel_resolution, l=cube_size[2]+2);
          }
        }
      }
    }
    else
        echo("<b>ERROR</b> too many or too wide horizontal pillars");
  }
}
else
{
  //svg for cutting cardboard
}

//for(a=vertical_pillars) {echo(a);}
