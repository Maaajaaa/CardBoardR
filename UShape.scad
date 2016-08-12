include <CardBoardLibrary.scad>
use <obiscad/bevel.scad>

//height, width, depth, u_depth, radius_outer, radius_inner
dimensions = [25, 25, 25, 2, 2, 2/1.62];
//thickness of paper/cardboard, mount_depth, top_fix_lenght
cardPer = [0.9, 2, 0.5];

//left 'n right, front/back, base (at least 2 required)
//first ammount of pillars, then width (order on line above)
pillars = [[0,0,2], [3,3,2]];

//resoultion and size of the butresses on the base and the sides
bevel_resolution = 0;
bevel_size = 2;

//sides to use (see CardBoardLibrary.scad for details)
///TODO: IMPLEMENT DIFFERENCE BETWEEN LEFT AND RIGHT
cardPerSides = [true,true,true,true,true];

ReadyToUseUShape(dimensions, cardPer, pillars, bevel_size, bevel_resolution, 4, cardPerSides);

module ReadyToUseUShape(dimensions, cardPer, pillars, bevel_size, bevel_resolution, corner_resolution, cardPerSides = [true,true,true,true,true])
{
  $fn=corner_resolution;
  depth = dimensions[2] - 2*dimensions[3];
  translate([0,dimensions[3]/2,0])difference()
  {
    if(pillars[0][1] == 0)
      UShapeCardPer(dimensions[0], dimensions[1], depth, dimensions[3], cardPer[1], cardPer[0], cardPer[2],
      dimensions[4], dimensions[5], true, false, cardPerSides);
    else
      UShapeCardPer(dimensions[0], dimensions[1], depth, dimensions[3], cardPer[1], cardPer[0], cardPer[2],
      dimensions[4], dimensions[5], true);

    //side pillars and bevels
    if(pillars[0][0]*pillars[1][0] < dimensions[0]-dimensions[4]-cardPer[1] && cardPerSides[1] && cardPerSides[3])
    {
        leftright_pillar_space = ((dimensions[0]-dimensions[4]-cardPer[1]-cardPer[2])
        -pillars[0][0]*pillars[1][0])/pillars[0][0];
        first_frontBackPillar = dimensions[4]+cardPer[1];


        cube_size = [dimensions[1]+1, depth - cardPer[1], leftright_pillar_space];

        edge_tl = [ [cube_size[0]/2, cube_size[1], cube_size[2]], [1,0,0], 0];
        normal_tl = [ cube_size[0],                    [1,1,1], 0];

        edge_tr = [ [cube_size[0]/2, 0, cube_size[2]], [1,0,0], 0];
        normal_tr = [ edge_tr[0],                    [0,-1,1], 0];

        edge_bl = [ [cube_size[0]/2, cube_size[1],0], [1,0,0], 0];
        normal_bl = [ edge_bl[0],                    [0,1,-1], 0];

        edge_br = [ [cube_size[0]/2, 0, 0], [1,0,0], 0];
        normal_br = [ edge_tr[0],                    [0,-1,-1], 0];

        if(pillars[0][0] == 0)
        {
          cube_size = [dimensions[1]+1, depth - cardPer[1]*2, dimensions[0]+1];

          edge_bl = [ [cube_size[0]/2, cube_size[1],0], [1,0,0], 0];
          normal_bl = [ edge_bl[0],                    [0,1,-1], 0];

          edge_br = [ [cube_size[0]/2, 0, 0], [1,0,0], 0];
          normal_br = [ edge_tr[0],                    [0,-1,-1], 0];

          translate([-dimensions[1]/2-0.5,dimensions[3]/2+cardPer[1], dimensions[4]+cardPer[1]])difference()
          {
              cube(cube_size);
              //Bottom-left, Bottom-right
              bevel(edge_bl, normal_bl, cr=bevel_size, cres=bevel_resolution, l=cube_size[0]+2);
              bevel(edge_br, normal_br, cr=bevel_size, cres=bevel_resolution, l=cube_size[0]+2);
          }
        }
        else
        {
          for(i=[0:pillars[0][0]-1])
          {
            translate([-dimensions[1]/2-0.5,dimensions[3]/2+cardPer[1], first_frontBackPillar
            +i*leftright_pillar_space+i*pillars[1][0]])difference()
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
    else if(pillars[0][0] > 0)
        echo("<b>ERROR</b> too many or too high left / right pillars");

    //base pillars and bevels
    if(pillars[0][2]*pillars[1][2] < dimensions[0]-dimensions[4]*2-cardPer[1]*2 && cardPerSides[0])
    {
      if(pillars[0][2] == 1)
      ;
      else
      {
        base_pillar_cuts = pillars[0][2] - 1;
        base_pillar_space = ((dimensions[1]-2*dimensions[4]-2*cardPer[1])
        -base_pillar_cuts*pillars[1][2])/(base_pillar_cuts);
        first_base_pillar_x = -(dimensions[1]/2) + cardPer[1] + dimensions[4] + pillars[1][2]/2;

        cube_size = [base_pillar_space, depth - cardPer[1]*2, dimensions[3]+1];

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
          i*pillars[1][2]+i*base_pillar_space,
          dimensions[3]/2+cardPer[1],-0.5])difference()
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

    //front and back pillars and bevels
    if(pillars[0][1] > 0 && pillars[0][1]*pillars[1][1] < dimensions[0]-dimensions[4]*2-cardPer[1]*2)
    {
        frontback_pillar_cuts = pillars[0][1];
        frontback_pillar_space = ((dimensions[0]-dimensions[3]-cardPer[1]*2-cardPer[2])
        -(frontback_pillar_cuts-1)*pillars[1][1])/(frontback_pillar_cuts);
        first_leftRightPillars = dimensions[3] + cardPer[1];

        cube_size = [dimensions[1]-2*dimensions[3]-2*cardPer[1], depth+dimensions[3]*2+0.002, frontback_pillar_space];

        edge_tl = [ [0, cube_size[0]-dimensions[3], cube_size[2]], [0,1,0], 0];
        normal_tl = [ cube_size[0],                    [-1,0,1], 0];

        edge_tr = [ [cube_size[0], cube_size[0]-dimensions[3], cube_size[2]], [0,1,0], 0];
        normal_tr = [ cube_size[0],                    [1,0,1], 0];

        edge_bl = [ [0, cube_size[0]-dimensions[3], 0], [0,1,0], 0];
        normal_bl = [ edge_bl[0],                    [-1,0,-1], 0];

        edge_br = [ [cube_size[0], cube_size[0]-dimensions[3], 0], [0,1,0], 0];
        normal_br = [ edge_bl[0],                    [1,0,-1], 0];

        for(i=[0:pillars[0][1]-1])
        {
          translate([-dimensions[1]/2+dimensions[3]+cardPer[1],-dimensions[3]/2-0.001, first_leftRightPillars
          +i*frontback_pillar_space+i*pillars[1][1]])difference()
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
      else if(pillars[0][1] > 0)
        echo("<b>ERROR</b> too many or too wide front / back pillars");
  }

  //print required paper sizes
  echo("You'll need two Cardboards in the size of: (WxH) ", dimensions[1]-2*dimensions[3], "x",  dimensions[0]-cardPer[2]-dimensions[3], "(for the front and the back)");
  echo("You'll need two more Cardboards sized: (WxH) ", depth, "x", dimensions[0]-dimensions[4]-dimensions[3]/2-cardPer[0]/2-cardPer[2], "(for the sides)" );
  echo("You'll also need one more Cardboard in the following dimensions: (WxH)", dimensions[1]-2*dimensions[3], "x", depth, "for the base" );
}
