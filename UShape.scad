include <CardBoardLibrary.scad>
use <obiscad/obiscad/bevel.scad>

/*SLICING NOTES:
  -disable thin wall detection
  -set XY-compensation to 0, at least for this part (the UShape)
  -check the extrusionWidth variable (leave in the sclicer, adapt below)
*/
extrusionWidth = 0.45;    //get this from your slicing settings
paperMountingShells = 1;  //the ammount of shells that hold the cardboard or paper wall

//thickness of paper/cardboard, mount_depth, top_fix_depth
cardPer = [0.9, 2, 0.5];
//height, width, depth, u_depth, radius_outer, radius_inner
dimensions = [50, 50, 50, cardPer[0]+paperMountingShells*2*extrusionWidth, 2, 2/1.62];

//echo(str("U_DEPTH = ", dimensions[3]));
//left 'n right, front/back, base (at least 2 required)
//first ammount of pillars, then width (order on line above) of the horizontal ones then again the same for the vertical ones
pillars = [[0,0,0], [3,5,2], [0,0,0], [3,0,0]];

//resoultion and size of the butresses on the base and the sides
bevel_resolution = 0;
bevel_size = 2;

//sides to use (see CardBoardLibrary.scad for details)
///TODO: IMPLEMENT DIFFERENCE BETWEEN LEFT AND RIGHT
cardPerSides = [true,true,true,true,true];

ReadyToUseUShape(dimensions, cardPer, pillars, bevel_size, bevel_resolution, 4, cardPerSides);

module ReadyToUseUShape(dimensions, cardPer, pillars, bevel_size, bevel_resolution, corner_resolution, cardPerSides = [true,true,true,true,true])
{
  height = dimensions[0];
  width = dimensions[1];
  u_depth = dimensions[3];
  radius_outer = dimensions[4];
  toplessHeight = height + 1;

  $fn=corner_resolution;
  depth = dimensions[2] - 2*u_depth;
  translate([0,u_depth/2,0])difference()
  {
    if(pillars[0][1] == 0 )
      UShapeCardPer(height, width, depth, u_depth, cardPer[1], cardPer[0], cardPer[2],
      radius_outer, dimensions[5], true, false, false, cardPerSides);
    else
      UShapeCardPer(height, width, depth, u_depth, cardPer[1], cardPer[0], cardPer[2],
      radius_outer, dimensions[5], true, false, false);

    horizontalPillarsHeight = height-u_depth-cardPer[2]-cardPer[1]*2;
    verticalPillarsWidth = depth-cardPer[1]*2-u_depth*2;

    //SIDE pillars and bevels
    if(pillars[0][0]*pillars[1][0] <= horizontalPillarsHeight && //horizontal pillars are OK
      pillars[2][0]*pillars[3][0] <= verticalPillarsWidth  &&   //vertical pillars are OK
      cardPerSides[1] && cardPerSides[3])
    {
      CutCube = [width+1, depth - cardPer[1]*2, horizontalPillarsHeight];
      translate([CutCube[0]/2,u_depth/2+cardPer[1], u_depth + cardPer[1]])rotate([0,0,90])
      if(pillars[0][0] == 0 && pillars[2][0] == 0)
        pillarCutter([CutCube[1],CutCube[0],toplessHeight], [pillars[0][0], pillars[1][0]], [pillars[2][0], pillars[3][0]], [bevel_size,bevel_resolution]);
      else
        pillarCutter([CutCube[1],CutCube[0],CutCube[2]], [pillars[0][0], pillars[1][0]], [pillars[2][0], pillars[3][0]], [bevel_size,bevel_resolution]);
    }
    else if(pillars[0][0] > 0 || pillars[2][0] > 0)
        echo("<b>ERROR</b> too many or too high left / right pillars");

    //BASE pillars and bevels
    if(pillars[0][2]*pillars[1][2] < width-radius_outer*2-cardPer[1]*2 && cardPerSides[0])
    {
      first_base_pillar_x = (width/2) - 2*cardPer[1] - radius_outer;
      CutCube = [width-2*radius_outer-4*cardPer[1], depth - cardPer[1]*2, u_depth+2];
      translate([-first_base_pillar_x,u_depth/2+cardPer[1], -1])rotate([90,0,90])
        pillarCutter([CutCube[1],CutCube[2],CutCube[0]], [pillars[0][2], pillars[1][2]], [pillars[2][2], pillars[3][2]], [bevel_size,bevel_resolution]);
    }
    else
        echo("<b>ERROR</b> too many or too wide base pillars");

    //FRONT and BACK pillars and bevels
    if(pillars[0][1]*pillars[1][1] < height-radius_outer*2-cardPer[1]*2)
    {
        CutCube = [width - cardPer[1]*2 - u_depth*2, depth+2+2*u_depth, horizontalPillarsHeight];
        translate([-CutCube[0]/2,-1, u_depth + cardPer[1]])
        if(pillars[0][1] == 0 && pillars[2][1] == 0)
          pillarCutter([CutCube[0],CutCube[1],toplessHeight], [pillars[0][1], pillars[1][1]], [pillars[2][1], pillars[3][1]], [bevel_size,bevel_resolution]);
        else
          pillarCutter([CutCube[0],CutCube[1],CutCube[2]], [pillars[0][1], pillars[1][1]], [pillars[2][1], pillars[3][1]], [bevel_size,bevel_resolution]);
      }
      else if(pillars[0][1] > 0)
        echo("<b>ERROR</b> too many or too wide front / back pillars");
  }

  //print required paper sizes
  echo("You'll need two Cardboards in the size of: (WxH) ", width-2*u_depth, "x",  height-cardPer[2]-u_depth, "(for the front and the back)");
  echo("You'll need two more Cardboards sized: (WxH) ", depth, "x", height-radius_outer-u_depth/2-cardPer[0]/2-cardPer[2], "(for the sides)" );
  echo("You'll also need one more Cardboard in the following dimensions: (WxH)", width-2*u_depth, "x", depth, "for the base" );
}

//space[x,y,z]
//horizontalPillars[amount, width]
//verticalPillars[amount, width]
//bevels[size,resoultion]
