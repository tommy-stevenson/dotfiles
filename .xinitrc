#!/bin/bash

grep 'tmpfs /tmp/ramdisk tmpfs noexec,defaults,noatime,size=1024,x-gvfs-show,mode=1777 0 0' /etc/fstab

if [ "$?" -ne "0" ]; then
  sudo bash -c "echo 'tmpfs /tmp/ramdisk tmpfs noexec,defaults,noatime,size=1024,x-gvfs-show,mode=1777 0 0' >> /etc/fstab"
  sudo mount -a
fi

grep 'vm.swappiness = 10' /etc/sysctl.conf

if [ "$?" -ne "0" ]; then
  sudo bash -c "echo 'vm.swappiness = 10' >> /etc/sysctl.conf"
  sudo sysctl -p
fi

systemd-tmpfiles --user --create

ln -s /tmp/ramdisk/pycharm/caches ~/.cache/JetBrains/PyCharm2020.2/caches
ln -s /tmp/ramdisk/pycharm/index ~/.cache/JetBrains/PyCharm2020.2/index

# Set TrackPoint acceleration profile on SK-8855 keyboard
TRACKPOINT_ID=`xinput list|grep -m 1 'Lite-On'|grep id=|cut -f 2|cut -f 2 -d =`
xinput --set-prop $TRACKPOINT_ID 'libinput Accel Speed' -0.57

# Set TrackPoint acceleration profile on SK-8845 keyboard
TRACKPOINT_ID=`xinput list|grep 'TrackPoint (Stick)'|grep id=|cut -f 2|cut -f 2 -d =`
xinput --set-prop $TRACKPOINT_ID 'libinput Accel Speed' -0.57

# Disable touchpad on SK-8845 keyboard
TOUCHPAD_ID=`xinput list|grep '/ TrackPoint'|grep -v 'Stick'|grep id=|cut -f 2|cut -f 2 -d =`
xinput --disable $TOUCHPAD_ID

# Avoid screen tearing
nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"

# Prevent screen from dimming during inactivity
xset s off
xset -dmps

# TODO: figure out why keyboard becomes unusable after screensaver becomes active

pidof dwm > /dev/null ** xdotool key super+F12
xwallpaper --zoom ~/Pictures/nebula-5120x2880-space-stars-4k-6592.jpg
#xrdb ~/.Xresources
xcompmgr &

while true
do
	VOL="VOL: $(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/')"
	LOCALTIME=$(date "+%a %d %b %Y %I:%M:%S %p ")
	IP="IP: $(for i in `ip r`; do echo $i; done | grep -A 1 src | tail -n1)"
	TEMP="CPU: $(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))C"
	
	#if acpi -a | grep off-line > /dev/null
	#then
	#	xsetroot -name "$VOL $LOCALTIME"
	#else
	BAT="BAT: $(acpi -b | awk '{ print $4 }' | tr -d ',')"
	xsetroot -name "$BAT $VOL $LOCALTIME"
	#fi
	sleep 1s
done &

google-chrome &

exec dwm
