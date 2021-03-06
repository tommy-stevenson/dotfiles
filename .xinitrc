#!/bin/bash

# Making tmpfs ramdisk for Brave
grep 'tmpfs /home/tommy/.cache/BraveSoftware tmpfs defaults,noatime,size=1024M,x-gvfs-show,mode=1777 0 0' /etc/fstab

if [ "$?" -ne "0" ]; then
  sudo bash -c "echo 'tmpfs /home/tommy/.cache/BraveSoftware tmpfs defaults,noatime,size=1024M,x-gvfs-show,mode=1777 0 0' >> /etc/fstab"
  mkdir -p /home/tommy/.cache/BraveSoftware
fi

sudo mount -a

grep 'vm.swappiness = 10' /etc/sysctl.conf

if [ "$?" -ne "0" ]; then
  sudo bash -c "echo 'vm.swappiness = 10' >> /etc/sysctl.conf"
  sudo sysctl -p
fi

# Set TrackPoint acceleration profile on SK-8855 keyboard
TRACKPOINT_ID=`xinput list|grep -m 1 'Lite-On'|grep id=|cut -f 2|cut -f 2 -d =`
xinput --set-prop $TRACKPOINT_ID 'libinput Accel Speed' -0.35

# Set TrackPoint acceleration profile on SK-8845 keyboard
TRACKPOINT_ID=`xinput list|grep 'TrackPoint (Stick)'|grep id=|cut -f 2|cut -f 2 -d =`
xinput --set-prop $TRACKPOINT_ID 'libinput Accel Speed' -0.57

# Disable touchpad on SK-8845 keyboard
TOUCHPAD_ID=`xinput list|grep '/ TrackPoint'|grep -v 'Stick'|grep id=|cut -f 2|cut -f 2 -d =`
xinput --disable $TOUCHPAD_ID

# Avoid screen tearing
nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"

# Prevent screen from dimming during inactivity
xset s off -dpms
xset s noblank

pidof dwm > /dev/null ** xdotool key super+F12
xwallpaper --zoom ~/Pictures/backgrounds/`ls ~/Pictures/backgrounds |shuf -n 1`
#xrdb ~/.Xresources
xcompmgr &

wmname LG3D

while true
do
	VOL="VOL: $(amixer -D pulse get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/')"
	LOCALTIME=$(date "+%a %d %b %Y %I:%M:%S %p ")
	IP="IP: $(for i in `ip r`; do echo $i; done | grep -A 1 src | tail -n1)"
	TEMP="CPU: $(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))C"
	
	if acpi -a | grep off-line > /dev/null
	then
		xsetroot -name "$VOL $LOCALTIME"
	else
	BAT="BAT: $(acpi -b | awk '{ print $4 }' | tr -d ',')"
	xsetroot -name "$BAT $VOL $LOCALTIME"
	fi
	sleep 0.3
done &

brave-browser &

PRIMARY_DISPLAY=`xrandr |grep " connected"|awk '{ print $1 }'|head -1`
SECONDARY_DISPLAY=`xrandr |grep " connected"|awk '{ print $1 }'|tail -1`
xrandr --output $SECONDARY_DISPLAY --auto --left-of $PRIMARY_DISPLAY &

pactl set-default-sink alsa_output.pci-0000_01_00.1.hdmi-stereo

exec dwm
