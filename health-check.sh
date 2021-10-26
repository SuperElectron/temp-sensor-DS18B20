#!/bin/bash

# Example usage: sudo -H ./health-check.sh

# Script setup
export NAME="[health-check.sh] "
export INSTRUCTIONS="--(INSTRUCTIONS)--"
export DEBUG="--(DEBUG)--"
export ERROR="--(ERROR)--"

echo "${NAME} Starting "

# Load modules
echo "${NAME} STEP 1: set up modules with 'modprobe' "
modprobe w1-gpio
modprobe w1-therm


# Check sensor readings
echo "${NAME} STEP 2: View readings to ensure correct configuration "

# command to grab the correct folder name
#cd /sys/bus/w1/devices
#ls -al | grep "28*"
#cd 28-xxxxxx
#export SENSORS=$(cat w1_master_slaves | grep "28*")
#echo "${DEBUG} Sensors found: ${SENSORS}"
cd /sys/bus/w1_bus_master1
# assumes only one sensor is connected ...
export SENSOR="$(find . -name 'w1_slave')"
echo "${DEBUG} Sensors found: ${SENSORS}"
cat "${SENSOR}"

export HEALTH_CHECK=$(head -n 1 "${SENSOR}" | grep "YES")

echo "${DEBUG} the 'first reading' from the temperature sensor will have a YES at the end if it is configured ..."
echo "${DEBUG} first reading: ${CMD}"

# Quick test to show user if things are set up correctly
test_results=CMD | grep "28*" | cut -d '2' -f1

echo "${NAME} Finished "
