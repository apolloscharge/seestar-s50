# seestar-s50
Replacement img for the Seestar S50Disclaimer: This guide is intended for educational purposes only. Flashing a new firmware image onto your Seestar device is risky and can potentially brick your device, making it inoperable. Please proceed with caution and understand that there is no guarantee of success, and reverting back to the original firmware may not be possible once you proceed. Always ensure you have a complete backup of your device's current state. We are not responsible for any damage to your device or loss of data that may occur from following this guide.

This process places a new img on the eMMC of the seestar. It overwrites everything. This image is ssh enabled, compatibilty for asiair app is enabled, and save all images is enabled. These settings are found in the ~/.ZWO/ASIAIR_imager.xml

Prerequisites: Install Necessary Dependencies
Before you start, ensure your system is up to date and has all the necessary dependencies installed. Open a terminal and execute the following commands:

sudo apt-get update

sudo apt-get install -y python2 git libusb-1.0-0-dev libudev-dev pkg-config autoconf libtool

git clone https://github.com/rockchip-linux/rkdeveloptool.git

cd rkdeveloptool

autoreconf -i && ./configure CXXFLAGS="-Wno-error=format-truncation=" && make

sudo make install


preparing the Seestar Device
To flash a new image, your Seestar must be in Maskrom mode. Follow these steps to prepare your device:

Remove the battery from the Seestar device. Located on the bottom of the seestar under a cover with two philip screws.
Hold the reset button located at the bottom of the device.
While holding the reset button, connect your device to your computer using a USB cable.
Continue holding the reset button for 5 seconds after the device is connected.
Ensure no lights are on on the device to confirm it's in Maskrom mode.
If the device does not connect, repeat the steps to ensure it enters Maskrom mode.

Verifying Connection in Maskrom Mode
To verify that your Seestar is connected and in the correct mode, use the following rkdeveloptool commands:

sudo rkdeveloptool ld  # Check if the device is in Maskrom mode
sudo rkdeveloptool rid # Get the device ID


Flashing the New Image

To flash the new image onto your Seestar device, use the following command. Be patient, as this process can take some time, over an hour and will show a progress dialog.

sudo rkdeveloptool wl 0 seestarOS.img


After the process completes:

Disconnect the USB cable from the device.
Reinstall the battery and power on your Seestar.
This method has been tested and confirmed to work, including app and firmware updates, but your results may vary depending on the specific firmware and device model.

Remember, this process is risky, and you should only proceed if you're comfortable with the potential outcomes, including the possibility of bricking your device.

