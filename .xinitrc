#!/bin/bash

xinput --set-prop 14 'libinput Accel Speed' -0.45
xinput --set-prop 12 'libinput Accel Speed' -0.45
pidof dwm > /dev/null ** xdotool key super+F12
xwallpaper --zoom ~/Pictures/nebula-5120x2880-space-stars-4k-6592.jpg
xcompmgr &

while true
do
	VOL="VOL: $(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/')"
	LOCALTIME=$(date "+%a %d %b %Y %I:%M:%S %p ")
	IP="IP: $(for i in `ip r`; do echo $i; done | grep -A 1 src | tail -n1)"
	TEMP="CPU: $(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))C"
	BAT="BAT: $(acpi -b | awk '{ print $4 }' | tr -d ',')"
	xsetroot -name "$BAT $VOL $LOCALTIME"
	sleep 1s
done &

google-chrome &

exec dwm
