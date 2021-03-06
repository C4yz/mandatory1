#!/bin/bash
echo "Press 1 to install from tar, and press 2 to install with dpkg"
read installtype
echo "Enter full name of the pacakge you want to install"
read package
echo "Enter install link"
read link
if [ $installtype == "dpkg" ]
then
	wget -O /usr/local/src/$package "$link"
	sudo dpkg --install /usr/local/src/$package
fi

