include <CardBoardLibrary.scad>

$fn=30;
height = 20;
width = 20;
depth = 20;
u_depth = 1;
mount_depth = 2;
cardPer_thickness = 0.5;
radius_outer = 2;
radius_inner = 2/1.62;
backpart = true;

vertical_pillars = 2;
vertical_pillar_height = 2;
vertical_pillar_offset = 1.5;

horizontal_pillars = 4;
horizontal_pillar_width = 2;
horizontal_pillar_offset = 2;

difference()
{
  UShapeCardPer(height, width, depth, u_depth, mount_depth, cardPer_thickness,
    radius_outer, radius_inner, backpart);
  //translate([-width/2-0.5,u_depth/2,radius_outer])cube([width+1, depth, height]);

  //UShapeCardPer(20,20, 20, 1, 2, 0.5, 2, 2/1.62, true);

  //from the UserManual of OpenSCAD
  //function sumv(v,i,s=0) = (i==s ? v[i] : v[i] + sumv(v,i-1,s));
  //echo("sum vec=", sumv(vertical_pillars,len(vertical_pillars)-1,0));

  if(vertical_pillars*vertical_pillar_height < height-radius_outer-vertical_pillar_offset)
  {
      vertical_pillar_space = ((height-radius_outer-vertical_pillar_offset)
      -vertical_pillars*vertical_pillar_height)/vertical_pillars;
      *echo (vertical_pillar_space);
      first_vertical_pillar_height = radius_outer+vertical_pillar_offset;
      for(i=[0:vertical_pillars-1])
      {
          translate([-width/2-0.5,u_depth/2, first_vertical_pillar_height
            +i*vertical_pillar_space+i*vertical_pillar_height])
            cube([width+1, depth, vertical_pillar_space]);

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
      echo (horizontal_pillar_space);
      first_horizontal_pillar_x = -(width/2) + horizontal_pillar_offset + radius_outer + horizontal_pillar_width/2;
      echo (first_horizontal_pillar_x);
      for(i=[0:horizontal_pillar_cuts-1])
      {
          translate([first_horizontal_pillar_x +
          i*horizontal_pillar_width+i*horizontal_pillar_space,u_depth/2,0])
            cube([horizontal_pillar_space, depth, height]);

      }
    }
  }
  else
      echo("<b>ERROR</b> too many or too wide horizontal pillars");
}
//for(a=vertical_pillars) {echo(a);}
