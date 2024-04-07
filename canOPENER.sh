#!/bin/bash

########################################################################
# Script to update seestar device
# Author: Apollo
# Version: Beta release 0001
# Date: 3-27-24
########################################################################

echo "Checking for rkdeveloptool..."
if command -v rkdeveloptool &> /dev/null; then
    echo "rkdeveloptool is already installed. Skipping installation."
else
    echo "rkdeveloptool not found. Proceeding with installation."
    sudo apt-get update
    sudo apt-get install -y python2 git libusb-1.0-0-dev libudev-dev pkg-config autoconf libtool build-essential

    if ! command -v python2 &> /dev/null; then
        echo "Python 2 could not be found. Please install Python 2."
        exit 1
    fi

    echo "Cloning rkdeveloptool repository..."
    if git clone https://github.com/rockchip-linux/rkdeveloptool.git; then
        cd rkdeveloptool || exit
        export PYTHON=$(which python2)

        echo "Using Python 2 for building..."
        autoreconf -i && ./configure CXXFLAGS="-Wno-error=format-truncation=" && make

        if [ $? -eq 0 ]; then
            sudo make install
            echo "rkdeveloptool installation complete."
        else
            echo "Building rkdeveloptool failed."
            exit 1
        fi
        cd - || exit
    else
        echo "Failed to clone rkdeveloptool repository."
        exit 1
    fi
fi

echo -e "\n\n\n"
echo -e "\n\n\n"
echo "Please follow the steps below to place your seestar into maskrom mode."
echo "1. Remove the battery from your seestar. Its cover is on the bottom. Two philips screws"
echo "2. Hold the reset button on the bottom of your seestar."
echo "3. While holding the reset button, plug the USB cable from your computer into the seestar."
echo "4. Keep holding the reset button for 5 seconds after plugging in the USB cable."
echo "5. No lights should come on if the device is successfully in maskrom mode."
echo "Proceed with the next steps only if the seestar is in maskrom mode."

read -p "Press Enter to continue if your seestar is in maskrom mode..."

# Test connection with rkdeveloptool
echo "Testing connection with rkdeveloptool..."
sudo rkdeveloptool ld

if [ $? -ne 0 ]; then
    echo "rkdeveloptool failed to connect. Please ensure your seestar is in maskrom mode and try again."
    exit 1
fi

echo "Connection successful. Proceeding with device ID retrieval..."
sudo rkdeveloptool rid

echo "Retrieving device information for backup creation..."
sudo rkdeveloptool rfi


    # Push the image onto the seestar
    echo "Restoring the seestar with the provided image. This might take a while..."
    sudo rkdeveloptool wl 0 dump_seestar.img
elif [ "$action" = "S" ] || [ "$action" = "s" ]; then
    echo "Attempting to create an image from the seestar. This process might take a while..."
    sudo rkdeveloptool rl 0 122159104 dump_seestar.img

    echo "If you see this message, the image has been successfully created."
    
    fdisk -l dump_seestar.img
    
    echo "Please verify the image and ensure there are no errors before proceeding to write the new image to the device."

    read -p "Press Enter to continue if you're ready to push the image onto the seestar..."

    # Push the image onto the seestar
    echo "Pushing the image onto the seestar. This might take a while..."
    sudo rkdeveloptool wl 0 seestarOS.img
  
else
    echo "Invalid option selected. Exiting."
    exit 1
fi

echo "The process is complete. You can now unplug the USB, replace the battery, and power on your seestar."
