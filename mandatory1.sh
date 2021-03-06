#!/bin/bash

echo "Do you want source code or from dpkg/rpm? (enter: source, dpkg, aur og rpm)"
read installtype
echo "What package do you want to install?"
read package
echo "Enter install link"
read URL

if [ "$(stat -c '%a' /usr/local/src)" == "777" ]
then
 	echo "working lol" 
else
  echo "Creating permessions"
  # get permissions to folder read, write and execute
  sudo chmod 777 /usr/local/src

fi

# Downloads package to folder
wget -O /usr/local/src/$package "$URL"

# Install the package
echo $installtype
if [ $installtype == "source" ]
then
    echo "Install type = Source"
    tar -xzvf $package
    makepkg -p /usr/local/src/$package
fi

if [ $installtype == "dpkg" ]
then
	#checking dependensies
	echo "debbing this bitch"
	dpkg-deb -I /usr/local/src/ncat.deb | grep Depends | sed 's/Depends: //' | tr "," "\n" | awk -F '\(' '{print $1}' > depends.txt	
	rm dependsinstalled.txt
	for line in $(cat depends.txt); do
		dpkg -l | grep $line | awk '{print $2}' | cut -d ':' -f 1 >> dependsinstalled.txt
	done
	for linje in $(diff depends.txt dependsinstalled.txt | awk '{print $2}'); do
		echo "You seem to be missing dependency $linje do you want to install it Y/N?"
		read answer
		if [[ $answer == "Y" || "y" || "yes" ]]
		then
			sudo apt install -y $linje
		else
		       echo "ABANDON SHIP!"
	       		exit
		fi
	done

	echo "LOL"	
	sudo dpkg --install /usr/local/src/$package
	pckName=$(dpkg-deb -I /usr/local/src/$package | grep 'Package' | tr ":" "\n" | sed -n 2p)
	if dpkg-l $pckName >/dev/null && test ! -z $pckName 
	then 
		echo "Grats man installed correctly"
	else
		echo "SHIP ABANDONED"
	fi
fi
