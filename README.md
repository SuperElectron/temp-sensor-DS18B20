# temp-sensor-DS18B20

Uses the Dallas Temperature Control Library (1-wire) to read GPIO with the DS18B20 temperature sensor connected


---


# raspberry pi 


## Getting Started


## Changing Pi password

- https://www.raspberrypi-spy.co.uk/2014/08/how-to-reset-a-forgotten-raspberry-pi-password/


## Running the repo

## Streaming with gstreamer

- install f=gstreamer

```bash
# install a missing dependency
sudo apt-get install -y libx264-dev libjpeg-dev
# install the remaining plugins
sudo apt-get install -y libgstreamer1.0-dev \
     libgstreamer-plugins-base1.0-dev \
     libgstreamer-plugins-bad1.0-dev \
     gstreamer1.0-plugins-ugly \
     gstreamer1.0-tools \
     gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-pulseaudio

gstreamer1.0-qt5
```

- test correct installation

```bash
export DISPLAY=:0; gst-launch-1.0 -v videotestsrc pattern=snow ! video/x-raw,width=1280,height=720 ! autovideosink
gst-launch-1.0 -v v4l2src ! videorate ! video/x-raw,framerate=25/2 ! autovideosink

```

- ssh into the raspberry pi - `password: superelectron`
```bash
ssh pi@10.0.0.155
export STREAM_KEY=live_734199616_hmSqmq7oE2E1C8f3ZgAK8GmXnWf2OJ
gst-launch-1.0 -v v4l2src ! videorate ! video/x-raw,framerate=1/1 ! jpegdec ! nvvidconv ! nvv4l2h264enc ! h264parse ! queue ! flvmux name=mux streamable=true ! rtmpsink location=rtmp://sea.contribute.live-video.net/app/$STREAM_KEY &

```


# Nvidia jetson

## connections
- data (UART Tx=pin8, Rx=pin10)
- 3v3 power (pin1)
- ground (pin6)
**The data line is split and fed to both the Tx and Rx on the jetson**

## Getting started

```bash
python3 -m pip install pydigitemp Jetson.GPIO
```

- stopping service

```bash
sudo systemctl stop nvgetty 
sudo systemctl disable nvgetty

sudo /opt/nvidia/jetson-io/jetson-io.py

```

- set up VNC server on jetson for headless display

```bash
sudo apt-get update -y && sudo ap-get install -y vino
# Configure the VNC server
gsettings set org.gnome.Vino prompt-enabled false
gsettings set org.gnome.Vino require-encryption false

# Set a password to access the VNC server
# Replace thepassword with your desired password
gsettings set org.gnome.Vino authentication-methods "['vnc']"


sudo vim /etc/gdm3/custom.conf

AutomaticLoginEnable = true
AutomaticLogin=<username>

sudo vim /etc/rc.local


#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
/usr/bin/jetson_clocks
/usr/sbin/nvpmodel -d cool
exit 0

```


```bash
# STEPS TAKEN
# ~/.profile ~/.bashrc
# /etc/rc.local

systemctl --user start vino-server


# remove duplicates
# $ ls -al /usr/lib/systemd/user/graphical-session.target.wants/vino-server.service
# xxxx /usr/lib/systemd/user/graphical-session.target.wants/vino-server.service /usr/lib/systemd/user/vino-server.service

# $ cat 
# $ cat /usr/lib/systemd/user/vino-server.service
```bash
[Unit]
Description=Vino VNC server

[Service]
Type=dbus
BusName=org.gnome.Vino
ExecStart=/usr/lib/vino/vino-server
Restart=on-failure
```
- remove it

- add this

```bash
sudo vim /etc/systemd/system/vino-server.service
[Unit]
Description = Vino Server to enable VNC remote login
After = network.target
[Service]
ExecStart = /usr/lib/vino/vino-server
[Install]
WantedBy = multi-user.target
```

- create simlink for new configuration
```bash
ls -sf <link_path> <file_to_create>

ln -sf /etc/systemd/system/vino-server.service /etc/systemd/system/multi-user.target.wants/vino-server.service

ls -al /etc/systemd/system/multi-user.target.wants/vino-server.service
lrwxrwxrwx 1 root root 39 Oct 21 15:23 /etc/systemd/system/multi-user.target.wants/vino-server.service -> /etc/systemd/system/vino-server.service


gsettings set org.gnome.Vino vnc-password $(echo -n 'nvidia'|base64)

# Add start up when you ssh into the device
sudo vim ~/.bashrc

/usr/lib/vino/vino-server --display :0 --sm-disable >/dev/null 2>&1 &
```

```bash
nvidia@nvidia:~$ sudo find / -name "vino*"
[sudo] password for nvidia: 
/etc/systemd/system/vino-server.service

/usr/share/doc/vino
/usr/share/applications/vino-server.desktop
/usr/lib/vino
/usr/lib/vino/vino-server
/var/cache/apt/archives/vino_3.22.0-3ubuntu1.2_arm64.deb
/var/lib/dpkg/info/vino.md5sums
/var/lib/dpkg/info/vino.list
/media/nvidia/7b605255-a155-4813-8b04-ab53005f7e5e/usr/lib/systemd/user/vino-server.service
/media/nvidia/7b605255-a155-4813-8b04-ab53005f7e5e/usr/lib/vino
/media/nvidia/7b605255-a155-4813-8b04-ab53005f7e5e/usr/lib/vino/vino-server
/media/nvidia/7b605255-a155-4813-8b04-ab53005f7e5e/usr/share/applications/vino-server.desktop
/media/nvidia/7b605255-a155-4813-8b04-ab53005f7e5e/usr/share/doc/vino
/media/nvidia/7b605255-a155-4813-8b04-ab53005f7e5e/var/lib/dpkg/info/vino.md5sums
/media/nvidia/7b605255-a155-4813-8b04-ab53005f7e5e/var/lib/dpkg/info/vino.list



nvidia@nvidia:/usr/lib$ ps -efj
UID        PID  PPID  PGID   SID  C STIME TTY          TIME CMD

nvidia@nvidia:/usr/lib$ ps -efj | grep vino-server
UID        PID  PPID  PGID   SID  C STIME TTY          TIME CMD
nvidia    9802  8960  9801  8960  0 16:07 pts/0    00:00:00 grep --color=auto vino-server

nvidia@nvidia:/usr/lib$ ps -efj | grep vino-server
UID        PID  PPID  PGID   SID  C STIME TTY          TIME CMD
nvidia    9805  8960  9804  8960  0 16:07 pts/0    00:00:00 grep --color=auto vino-server

nvidia@nvidia:/usr/lib$ ps -efj | grep vino-server
UID        PID  PPID  PGID   SID  C STIME TTY          TIME CMD
nvidia    9807  8960  9806  8960  0 16:07 pts/0    00:00:00 grep --color=auto vino-server

nvidia@nvidia:/usr/lib$ ps -efj | grep vino-server
UID        PID  PPID  PGID   SID  C STIME TTY          TIME CMD
nvidia    9809  8960  9808  8960  0 16:07 pts/0    00:00:00 grep --color=auto vino-server

nvidia@nvidia:/usr/lib$ ps -efj | grep 8960
UID        PID  PPID  PGID   SID  C STIME TTY          TIME CMD
nvidia    8960  8959  8960  8960  0 15:54 pts/0    00:00:00 -bash
nvidia    9810  8960  9810  8960  0 16:08 pts/0    00:00:00 ps -efj
nvidia    9811  8960  9810  8960  0 16:08 pts/0    00:00:00 grep --color=auto 8960

nvidia@nvidia:~$ ps -efj | grep vino-server
UID        PID  PPID  PGID   SID  C STIME TTY          TIME CMD
nvidia    9995  9881  9994  9881  0 16:11 pts/0    00:00:00 grep --color=auto vino-server

ps -Flww -p 9881

UID        PID  PPID  PGID   SID  C STIME TTY          TIME CMD
nvidia   10159  9881 10158  9881  0 16:20 pts/0    00:00:00 grep --color=auto /usr/lib/vino/vino-server
nvidia   10057  9939 10056  9939  0 16:49 pts/0    00:00:00 grep --color=auto vino-server




1.
/media/nvidia/7b605255-a155-4813-8b04-ab53005f7e5e/usr/lib/vino/vino-server
2.
/media/nvidia/7b605255-a155-4813-8b04-ab53005f7e5e/usr/share/doc/vino
nvidia@nvidia:~$ ls -al /media/nvidia/7b605255-a155-4813-8b04-ab53005f7e5e/usr/lib

```


#systemctl start vinostartup.service
# systemctl --user start vino-server.service
# /usr/lib/vino/vino-server &
# systemctl --user start vino-server

```
---

fin!
