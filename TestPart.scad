//Defaults
/*total_height = 4;
base_height = 1;
length = 3;
space_width = 0.6;
outer_width = space_width + 1;*/

total_height = 6;
base_height = 1;
length = 10;
space_width = 0.6;
outer_width = space_width + 1.5;

include<CardBoardLibrary.scad>

linearCardBoardMount(length, total_height, base_height, outer_width, space_width,"XY");