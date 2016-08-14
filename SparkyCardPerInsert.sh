#!/bin/bash
if [ "$1" != "" ]; then

	if [ "$1" == "--help" ]; then
		echo "./SparkyCardPerInsert.sh <path_to_G-Code-file>"
		exit
	else
		echo "Welcome to SparkyCardPerInsert"
		#echo $1
	fi
else
	echo "Welcome to SparkyColorPrint"
	read -e -p "enter the path to the G-CODE file: " response
        if [ "$1" != "" ]; then
            echo "please enter a file name"
        fi
fi
echo -n "height before the closing: " 
read height
awk '/Z'$height'/{print"G0 X0 Y190\nM300\nM0\nG28 X Y"}1' $1 > tmp && mv tmp $1


