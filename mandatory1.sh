#!/bin/bash

echo "Do you want source code or from dpkg/rpm? (enter: source, dpkg, aur og rpm)"
read installtype
echo "What package do you want to install?"
read package
echo "Enter install link"
read URL

if [ "$(stat -c '%a' /usr/local/src)" == "777" ]
then
  echo "you have permission"
else
  echo "you dont have permission"
  # get permissions to folder read, write and execute
  sudo chmod 777 /usr/local/src

fi

# Downloads package to folder
wget -O /usr/local/src/$package $URL

# Install the package
echo $installtype
if [ $installtype == "source" ]
then
    echo "Install type = Source"
    tar -xzvf $package
    makepkg -p /usr/local/src/$package
else
    echo "Install type does not eaqual source"
    # Install the package
    $installtype -i /usr/local/src/$package

fi
