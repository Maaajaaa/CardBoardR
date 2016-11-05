/*

Customizable drawer box
Gian Pablo Villamil
August 4, 2014

v1 first iteration
v2 added drawer handle
v3 added full fillets, tweaked wall thickness and corner handling
v4 added text label
v5 added hex patterning on the sides
v6 added dimple stop to drawers and box

*/

use<Write.scad>;
use<../UShape.scad>;
use<../CardBoardLibrary.scad>

/* [Global] */

// Which one would you like to see?
part = "drawer"; // [drawer, separators, drawerbox:drawer housing]

/* [Basic] */

// How many drawers?
NUM_DRAWERS = 10;

// How high?
DRAWER_HEIGHT = 15;

// How deep?
DRAWER_DEPTH = 72;

// How wide?
DRAWER_WIDTH = 160;

// space between separators (the last one, starting on the left going right)
separatorPostions = [15.85,15.85,15.85,15.65,15.65,15.65,15.85, 15.85];

// Label on the drawer
MESSAGE = "";

// Text height
TEXT_HEIGHT = 6;

//do you want to save a lot of filament?
MATTIS_IMPROVEMENT = true;

/* [Pattern] */

india = 6 ;
spacing = 1.2;
dia = india + (spacing * 2);



hoff = india+spacing;
voff = sqrt(pow(hoff,2)-pow(hoff/2,2));


/* [Advanced] */

// Handle size?
HANDLE_SIZE = 10;

// Corner radius?
DRAWER_CORNER_RAD = 2;

// Clearance
CLEARANCE = 0.25;

// Wall thickness
WALL_THICK = 1.6;

// Floor thickness
FLOOR_THICK = 1.2;

// Rounded fillets?
FILLETS = false;

//MESSAGE="hello world";

extrusionWidth = 0.46;    //get this from your slicing settings
paperMountingShells = 1;  //the ammount of shells that hold the cardboard or paper wall
separatorMountingShells = 1;
//thickness of paper/cardboard, mount_depth, top_fix_depth
cardPer = [0.9, 2, 0.5];
//height, width, depth, u_depth, radius_outer, radius_inner
//dimensions = [50, 50, 50, cardPer[0]+paperMountingShells*2*extrusionWidth, 2, 2/1.62];

//left 'n right, front/back, base
//first ammount of pillars, then width (order on line above) of the horizontal ones then again the same for the vertical ones
pillars = [[0,0,2], [3,5,4], [1,2,0], [3,3,3]];

//resoultion and size of the butresses on the base and the sides
bevel_resolution = 0;
bevel_size = 2;

/* [Hidden] */

$fn = 6;
NOFILLETS = !FILLETS;
WALL_WIDTH = WALL_THICK + 0.001; // Hack to trick Makerware into making the right number of filament widths
INNER_FILLET = DRAWER_CORNER_RAD-(WALL_WIDTH/1.25);

BOX_HEIGHT = NUM_DRAWERS*(DRAWER_HEIGHT+CLEARANCE*2+WALL_WIDTH)+WALL_WIDTH;
BOX_WIDTH = DRAWER_WIDTH+CLEARANCE*2+WALL_WIDTH*2;
BOX_DEPTH = DRAWER_DEPTH+CLEARANCE+WALL_WIDTH;

thick = WALL_THICK + 0.2;
bumprad = 1;

earthick = 0.6;
earrad = 10 ;

//
print_part();

module print_part() {
	if (part == "drawer") {
		drawer();
	} else if (part == "separators"){
		separators();
	} else if (part == "drawerbox"){
		drawerbox();
	}
}


module drawerbox() {
	translate([-BOX_WIDTH/2,-BOX_DEPTH/2,0])
	union () {
		difference () {
			cube([BOX_WIDTH,BOX_DEPTH,BOX_HEIGHT]);
			for (i=[0:NUM_DRAWERS-1]) {
				translate([WALL_WIDTH,-1,i*(DRAWER_HEIGHT+CLEARANCE*2+WALL_WIDTH)+WALL_WIDTH])
        	cube([DRAWER_WIDTH+CLEARANCE*2,DRAWER_DEPTH+CLEARANCE+1,DRAWER_HEIGHT+CLEARANCE*2]);

                if(MATTIS_IMPROVEMENT)
                {
				translate([WALL_WIDTH + 10,-1,i*(DRAWER_HEIGHT+CLEARANCE*2)-WALL_WIDTH])
					cube([DRAWER_WIDTH+CLEARANCE*2-20,DRAWER_DEPTH+CLEARANCE+1,20]);
                }
			}
		translate([0,BOX_DEPTH+0.1,0])
		holes(BOX_WIDTH,BOX_HEIGHT);
		rotate([0,0,90]) translate([hoff/2,0.1,0]) holes(BOX_DEPTH,BOX_HEIGHT);
		rotate([0,0,90]) translate([hoff/2,-BOX_WIDTH+WALL_WIDTH+0.1,0]) holes(BOX_DEPTH,BOX_HEIGHT);
		}
		for (i=[0:NUM_DRAWERS-1]) {
			if(!MATTIS_IMPROVEMENT)
                translate([BOX_WIDTH/2,DRAWER_CORNER_RAD*2,i*(DRAWER_HEIGHT+CLEARANCE*2+WALL_WIDTH)+WALL_WIDTH-0.1])
                {
				scale([1,1,0.9]) half_sphere(bumprad);
				translate([0,0,DRAWER_HEIGHT+CLEARANCE*2+0.2]) rotate([180,0,0]) scale([1,1,0.9]) half_sphere(bumprad);
                }
            else
            {
                //translate([-DRAWER_WIDTH/2+4,DRAWER_DEPTH/2-DRAWER_CORNER_RAD*2,-DRAWER_HEIGHT/2]) scale([1.2,1.2,1.]) sphere(bumprad);
                translate([BOX_WIDTH/2-DRAWER_WIDTH/2+4,DRAWER_DEPTH-DRAWER_CORNER_RAD*2,i*(DRAWER_HEIGHT+CLEARANCE*2+WALL_WIDTH)+WALL_WIDTH-0.1]) scale([1,1,0.9]) half_sphere(bumprad);
                translate([BOX_WIDTH/2+DRAWER_WIDTH/2-4,DRAWER_DEPTH-DRAWER_CORNER_RAD*2,i*(DRAWER_HEIGHT+CLEARANCE*2+WALL_WIDTH)+WALL_WIDTH-0.1]) scale([1,1,0.9]) half_sphere(bumprad);
            }

		}

// mouse ears
/*translate([-earrad/2,BOX_DEPTH,-earrad/2]) rotate([90,0,0]) cylinder(r=earrad,h=earthick);
translate([BOX_WIDTH+earrad/2,BOX_DEPTH,-earrad/2]) rotate([90,0,0]) cylinder(r=earrad,h=earthick);
translate([-earrad/2,BOX_DEPTH,BOX_HEIGHT+earrad/2]) rotate([90,0,0]) cylinder(r=earrad,h=earthick);
translate([BOX_WIDTH+earrad/2,BOX_DEPTH,BOX_HEIGHT+earrad/2]) rotate([90,0,0]) cylinder(r=earrad,earthick);*/

	}
};

module drawer() {
	u_depth = cardPer[0]+paperMountingShells*2*extrusionWidth;
	drawerbase();
	echo("<b>TODO: MAKE INSIDE WALLS BETTER</b>");
};

module separators() {
	u_depth = cardPer[0]+paperMountingShells*2*extrusionWidth;
	separatorHeight = DRAWER_HEIGHT;//DRAWER_HEIGHT;
	separatorExtrusionWidth = 0.35;
	separatorUDepth = cardPer[0]+separatorMountingShells*2*separatorExtrusionWidth;
	mountDepths = [2, 1.9, 1.8, 1.7, 1.6, 1.5, 1.4, 1.3];
	sideReduction = separatorUDepth-separatorMountingShells*extrusionWidth;
	baseReduction = separatorUDepth-0.4;
	separatorPaperThickness = 0.8;
	difference()
	{
		for(i = [0:len(separatorPostions)-1])
		{
			translate([-DRAWER_WIDTH/2+u_depth+separatorUDepth+ sumv(separatorPostions, i)+i*separatorUDepth, -DRAWER_DEPTH/2+u_depth-extrusionWidth, -DRAWER_HEIGHT/2+cardPer[0]+paperMountingShells*extrusionWidth])
		CardPerWall(separatorHeight, DRAWER_DEPTH-u_depth*2+extrusionWidth*2, separatorUDepth, mountDepths[i]/2, separatorPaperThickness, 0, sideReduction, baseReduction);
		}
	  drawerbase();
	}
}

module drawerbase() {
	union() {
		difference() {
			translate([0,0,DRAWER_CORNER_RAD/2])roundedBox([DRAWER_WIDTH,DRAWER_DEPTH,DRAWER_HEIGHT+DRAWER_CORNER_RAD],DRAWER_CORNER_RAD,NOFILLETS);
			//translate([0,0,DRAWER_HEIGHT]) cube([DRAWER_WIDTH+1, DRAWER_DEPTH+1,DRAWER_HEIGHT],center=true);
			if(!MATTIS_IMPROVEMENT)translate([0,-DRAWER_DEPTH/2+DRAWER_CORNER_RAD*2,-DRAWER_HEIGHT/2]) scale([1.2,1.2,1.]) sphere(bumprad,$fn = 20);
			if(!MATTIS_IMPROVEMENT)translate([0,DRAWER_DEPTH/2-DRAWER_CORNER_RAD*2,-DRAWER_HEIGHT/2]) scale([1.2,1.2,1.]) sphere(bumprad,$fn = 20);
            if(MATTIS_IMPROVEMENT)translate([-DRAWER_WIDTH/2+4,DRAWER_DEPTH/2-DRAWER_CORNER_RAD*2,-DRAWER_HEIGHT/2]) scale([1.2,1.2,1.]) sphere(bumprad,$fn = 20);
            if(MATTIS_IMPROVEMENT)translate([DRAWER_WIDTH/2-4,DRAWER_DEPTH/2-DRAWER_CORNER_RAD*2,-DRAWER_HEIGHT/2]) scale([1.2,1.2,1.]) sphere(bumprad,$fn = 20);
	}
	translate([0,-DRAWER_DEPTH/2,-DRAWER_HEIGHT/2+FLOOR_THICK])
	handle();

	translate([-DRAWER_WIDTH/2+DRAWER_CORNER_RAD,-DRAWER_DEPTH/2+0.5,-DRAWER_HEIGHT/4+DRAWER_CORNER_RAD/2]) rotate([90,0,0])
	write(MESSAGE,h=TEXT_HEIGHT,font="Orbitron.dxf");
	};
};

module handle() {

	difference() {
		roundedBox([DRAWER_WIDTH/4,HANDLE_SIZE*2,FLOOR_THICK*2],2,true,true);
		translate([0,HANDLE_SIZE,0]) cube([DRAWER_WIDTH/4+1,HANDLE_SIZE*2,FLOOR_THICK*2+1],center=true);
	};

	difference() {
		translate([0,-DRAWER_CORNER_RAD/2,FLOOR_THICK+DRAWER_CORNER_RAD/2])
			cube([DRAWER_WIDTH/4,DRAWER_CORNER_RAD,DRAWER_CORNER_RAD],center=true);
		translate([-DRAWER_WIDTH/8-1,-DRAWER_CORNER_RAD,FLOOR_THICK+DRAWER_CORNER_RAD]) rotate([0,90,0])
			cylinder(h=DRAWER_WIDTH/4+2,r=DRAWER_CORNER_RAD);
		};

	difference() {
		translate([-DRAWER_WIDTH/8,0,-FLOOR_THICK])
			cube([DRAWER_WIDTH/4,DRAWER_CORNER_RAD,DRAWER_CORNER_RAD],center=false);
		translate([-DRAWER_WIDTH/8-1,DRAWER_CORNER_RAD,-FLOOR_THICK+DRAWER_CORNER_RAD]) rotate([0,90,0])
			cylinder(h=DRAWER_WIDTH/4+2,r=DRAWER_CORNER_RAD);
		};
};

module holes(width,height) {
	cols = width / hoff - DRAWER_CORNER_RAD;
	rows = height / voff - DRAWER_CORNER_RAD;

	translate([hoff*1.3,0,voff*2])
	for (i=[0:rows-1]) {
		for (j=[0:cols-1]){
			#translate([j*hoff+i%2*(hoff/2),0,i*voff])
			rotate([90,90,0]) rotate([0,0,0]) cylinder(h=thick,r=india/2,$fn=6);
		}
	}
}

module half_sphere(rad) {
	difference() {
		sphere(rad,$fn=20);
		translate([-rad,-rad,-rad])
		cube([rad*2,rad*2,rad]);
	}
}

// Library: boxes.scad
// Version: 1.0
// Author: Marius Kintel, modified by Mattis Männel in 2016
// Copyright: 2010
// License: BSD

// roundedBox([width, height, depth], float radius, bool sidesonly);
// size is a vector [w, h, d]
module roundedBox(size, radius, sidesonly, full = false)
{
  rot = [ [0,0,0], [90,0,90], [90,90,0] ];
  if (sidesonly) {
		if(!full)
		{
			//height, width, depth, u_depth, radius_outer, radius_inner
			dimensions = [size[2], size[0], size[1], cardPer[0]+paperMountingShells*2*extrusionWidth, 2, 2/1.62];
			translate([0,-size[1]/2,-size[2]/2])ReadyToUseUShape(dimensions, cardPer, pillars, bevel_size, bevel_resolution, 4);
		}
		else
		{
	    cube(size - [2*radius,0,0], true);
	    cube(size - [0,2*radius,0], true);
	    for (x = [radius-size[0]/2, -radius+size[0]/2],
	           y = [radius-size[1]/2, -radius+size[1]/2]) {
	      translate([x,y,0]) cylinder(r=radius, h=size[2], center=true);
	    }
		}
  }
  else {
    cube([size[0], size[1]-radius*2, size[2]-radius*2], center=true);
    cube([size[0]-radius*2, size[1], size[2]-radius*2], center=true);
    cube([size[0]-radius*2, size[1]-radius*2, size[2]], center=true);

    for (axis = [0:2]) {
      for (x = [radius-size[axis]/2, -radius+size[axis]/2],
             y = [radius-size[(axis+1)%3]/2, -radius+size[(axis+1)%3]/2]) {
        rotate(rot[axis])
          translate([x,y,0])
          cylinder(h=size[(axis+2)%3]-2*radius, r=radius, center=true);
      }
    }
    for (x = [radius-size[0]/2, -radius+size[0]/2],
           y = [radius-size[1]/2, -radius+size[1]/2],
           z = [radius-size[2]/2, -radius+size[2]/2]) {
      translate([x,y,z]) sphere(radius, $fn=20);
    }
  }
}

function sumv(v,i,s=0) = (i==s ? v[i] : v[i] + sumv(v,i-1,s));
