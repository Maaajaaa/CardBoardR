include <CardBoardLibrary.scad>
use <obiscad/bevel.scad>
pi = 3.141592653589793238;

$fn=30;
height = 25;
width = 25;
depth = 25;
u_depth = 2;
mount_depth = 2;
cardPer_thickness = 0.9;
radius_outer = 2;
radius_inner = radius_outer/1.62;
backpart = true;
closed_top_y = true;

top_fix_length = 0.5;

leftright_pillars = 0;
leftright_pillar_height = 3;

base_pillars = 2;
base_pillar_width = 2;

frontback_pillars = 0;
frontback_pillar_height = 3;

bevel_resolution = 20;
bevel_size = 2;

part = "main";

if(part == "main")
{
  //translate([0,height/2,u_depth/2])rotate([90,0,0])
  difference()
  {
    if(frontback_pillars == 0)
      UShapeCardPer(height, width, depth, u_depth, mount_depth, cardPer_thickness, top_fix_length,
      radius_outer, radius_inner, backpart, false, true);
    else
      UShapeCardPer(height, width, depth, u_depth, mount_depth, cardPer_thickness, top_fix_length,
      radius_outer, radius_inner, backpart);

    if(leftright_pillars*leftright_pillar_height < height-radius_outer-mount_depth)
    {
        leftright_pillar_space = ((height-radius_outer-mount_depth-top_fix_length)
        -leftright_pillars*leftright_pillar_height)/leftright_pillars;
        first_leftright_pillar_height = radius_outer+mount_depth;


        cube_size = [width+1, depth - mount_depth, leftright_pillar_space];

        edge_tl = [ [cube_size[0]/2, cube_size[1], cube_size[2]], [1,0,0], 0];
        normal_tl = [ cube_size[0],                    [1,1,1], 0];

        edge_tr = [ [cube_size[0]/2, 0, cube_size[2]], [1,0,0], 0];
        normal_tr = [ edge_tr[0],                    [0,-1,1], 0];

        edge_bl = [ [cube_size[0]/2, cube_size[1],0], [1,0,0], 0];
        normal_bl = [ edge_bl[0],                    [0,1,-1], 0];

        edge_br = [ [cube_size[0]/2, 0, 0], [1,0,0], 0];
        normal_br = [ edge_tr[0],                    [0,-1,-1], 0];

        if(leftright_pillars == 0)
        {
          cube_size = [width+1, depth - mount_depth*2, height+1];

          edge_bl = [ [cube_size[0]/2, cube_size[1],0], [1,0,0], 0];
          normal_bl = [ edge_bl[0],                    [0,1,-1], 0];

          edge_br = [ [cube_size[0]/2, 0, 0], [1,0,0], 0];
          normal_br = [ edge_tr[0],                    [0,-1,-1], 0];

          translate([-width/2-0.5,u_depth/2+mount_depth, radius_outer+mount_depth])difference()
          {
              cube(cube_size);
              //Bottom-left, Bottom-right
              bevel(edge_bl, normal_bl, cr=bevel_size, cres=bevel_resolution, l=cube_size[0]+2);
              bevel(edge_br, normal_br, cr=bevel_size, cres=bevel_resolution, l=cube_size[0]+2);
          }
        }
        else
        {
          for(i=[0:leftright_pillars-1])
          {
            translate([-width/2-0.5,u_depth/2+mount_depth, first_leftright_pillar_height
            +i*leftright_pillar_space+i*leftright_pillar_height])difference()
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
    }
    else if(leftright_pillars > 0)
        echo("<b>ERROR</b> too many or too high left / right pillars");

    if(base_pillars*base_pillar_width < height-radius_outer*2-mount_depth*2)
    {
      if(base_pillars == 1)
      ;
      else
      {
        base_pillar_cuts = base_pillars - 1;
        base_pillar_space = ((width-2*radius_outer-2*mount_depth)
        -base_pillar_cuts*base_pillar_width)/(base_pillar_cuts);
        first_base_pillar_x = -(width/2) + mount_depth + radius_outer + base_pillar_width/2;

        cube_size = [base_pillar_space, depth - mount_depth*2, u_depth+1];

        edge_tl = [ [0, cube_size[1], cube_size[2]/2], [0,0,1], 0];
        normal_tl = [ edge_tl[0],                    [-1,1,0], 0];

        edge_tr = [ [cube_size[0], cube_size[1], cube_size[2]/2], [0,0,1], 0];
        normal_tr = [ edge_tr[0],                    [1,1,0], 0];

        edge_bl = [ [0, 0, cube_size[2]/2], [0,0,1], 0];
        normal_bl = [ edge_bl[0],                    [-1,-1,0], 0];

        edge_br = [ [cube_size[0], 0, cube_size[2]/2], [0,0,1], 0];
        normal_br = [ edge_tr[0],                    [1,-1,0], 0];

        for(i=[0:base_pillar_cuts-1])
        {
          translate([first_base_pillar_x +
          i*base_pillar_width+i*base_pillar_space,
          u_depth/2+mount_depth,-0.5])difference()
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
        echo("<b>ERROR</b> too many or too wide base pillars");

    if(frontback_pillars > 0 && frontback_pillars*frontback_pillar_height < height-radius_outer*2-mount_depth*2)
    {
        frontback_pillar_cuts = frontback_pillars;
        frontback_pillar_space = ((height-u_depth-mount_depth*2-top_fix_length)
        -(frontback_pillar_cuts-1)*frontback_pillar_height)/(frontback_pillar_cuts);
        first_frontback_pillar_height = u_depth + mount_depth;

        cube_size = [width-2*u_depth-2*mount_depth, depth+u_depth*2+0.002, frontback_pillar_space];

        edge_tl = [ [0, cube_size[0]-u_depth, cube_size[2]], [0,1,0], 0];
        normal_tl = [ cube_size[0],                    [-1,0,1], 0];

        edge_tr = [ [cube_size[0], cube_size[0]-u_depth, cube_size[2]], [0,1,0], 0];
        normal_tr = [ cube_size[0],                    [1,0,1], 0];

        edge_bl = [ [0, cube_size[0]-u_depth, 0], [0,1,0], 0];
        normal_bl = [ edge_bl[0],                    [-1,0,-1], 0];

        edge_br = [ [cube_size[0], cube_size[0]-u_depth, 0], [0,1,0], 0];
        normal_br = [ edge_bl[0],                    [1,0,-1], 0];

        for(i=[0:frontback_pillars-1])
        {
          translate([-width/2+u_depth+mount_depth,-u_depth/2-0.001, first_frontback_pillar_height
          +i*frontback_pillar_space+i*frontback_pillar_height])difference()
          {
              cube(cube_size);
              //Top-left, Top-right, Bottom-left, Bottom-right
              bevel(edge_tl, normal_tl, cr=bevel_size, cres=bevel_resolution, l=cube_size[1]+2);
              bevel(edge_tr, normal_tr, cr=bevel_size, cres=bevel_resolution, l=cube_size[1]+2);
              bevel(edge_bl, normal_bl, cr=bevel_size, cres=bevel_resolution, l=cube_size[1]+2);
              bevel(edge_br, normal_br, cr=bevel_size, cres=bevel_resolution, l=cube_size[1]+2);
          }
        }
      }
      else if(frontback_pillars > 0)
        echo("<b>ERROR</b> too many or too wide front / back pillars");
  }
}
else
{
  //svg for cutting cardboard
  main_width = depth;
  main_length = pi*(radius_inner + radius_outer)/2  +
                2*(height - top_fix_length - radius_inner - u_depth) +
                width-2*u_depth - 2* radius_outer;
  square([main_width, main_length]);
  echo(str("main_width = ", main_width));
  echo(str("main_length = ", main_length));
}

//for(a=leftright_pillars) {echo(a);}
