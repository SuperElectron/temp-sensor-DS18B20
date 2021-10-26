#!/bin/bash


# Example usage: sudo -H ./setup.sh

# Script setup
export NAME="[setup.sh] "
export INSTRUCTIONS="--(INSTRUCTIONS)--"
export DEBUG="--(DEBUG)--"
export ERROR="--(ERROR)--"

# Go
echo "${NAME} Starting "

echo "${NAME} STEP 1: Confirm sensor configuration"
echo "${DEBUG} Do the following .. "
echo "${INSTRUCTIONS} The DS18B20 sensor requires a 4.7kOhm resistor connected across the sensor's power input (red) and data (yellow)"


echo "${NAME} STEP 2: Enable 1-wire on the raspberry pi "
echo "${DEBUG} the 1-wire bus driver can be used on GPIO4 as data if in/out is enabled"
echo "${DEBUG} Do the following .. "
echo "${INSTRUCTIONS} Interfacing Options -> 1-wire"
sudo raspi-config

echo "${NAME} STEP 3: Modify boot configs"

echo "${DEBUG} Adding gpio configs on boot (auto sets on boot, not necessary)"
echo "dtoverlay=w1-gpio" >> /boot/config.txt

echo "${DEBUG} the device will now reboot with the set configurations"
echo "${NAME} Finished "

sudo reboot
