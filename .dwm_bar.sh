#!/bin/bash
#
# ~/bin/dwm-statusbar
# Adapted from w0ng status bar: https://github.com/w0ng/bin

# Colour codes from dwm/config.h
color0="\x01" # normal  
color1="\x02" # selected
color2="\x03" # red alert
color3="\x04" # bright green on gray
color4="\x05" # red
color5="\x06" # orange
color6="\x07" # yellow
color7="\x08" # green
color8="\x09" # ocean green
color9="\x0a" # blue
color10="\x0b" # indigo
color11="\x0c" # violet
color12="\x0d" # bright green on light gray

# Icon glyphs are from font Tamsynmod. make sure to set your locale to an ISO8559 one, else icons won't show. 

#---separator                              
sp="$(echo -ne "${color3} ")" 

#---not currently in use
print_song_info() {
  song_info="$(ncmpcpp --now-playing '{{{{%a - }%t}}|{%f}}' | head -c 75)"
  if [[ ! $song_info ]]; then
    song_info=""
    fi
  echo -ne "${color4}ê${color12}${song_info}"
}

print_power() {
  status="$(cat /sys/class/power_supply/ACAD/online)"
  battery="$(cat /sys/class/power_supply/BAT1/capacity)"
  if [ "${status}" == 1 ]; then
    echo -ne "${color5}µ${color12}on"
  else
    echo -ne "${color4}ð${color12}${battery}%"
  fi
}

print_wifiqual() {
  wifiqual="$(cat /proc/net/wireless | awk 'FNR == 3 {print $3}' | tr -d [:punct:])"
  echo -ne "${color7}¤${color12}${wifiqual}%"
}

print_uptime() {
  uptime="$(uptime | awk '{print $3}' | tr -d [=,=])"
  echo -ne "${color6}È${color12}${uptime}"
}

print_hddfree() {
  hddfree="$(df -Ph /dev/sda4 | awk '$3 ~ /[0-9]+/ {print $4}')"
  echo -ne "${color8}¨${color12}${hddfree}"
}

print_mem_used() {
  mem_used="$(free -m | awk 'NR==3 {print $3}')"
  echo -ne "${color9}×${color12}${mem_used}M"
}

print_volume() {
  volume="$(amixer get PCM | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')"
  echo -ne "${color11}í${color12}${volume}%"
}

print_datetime() {
  datetime="$(date "+%a %d %b %H:%M")"
  echo -ne "${color4}É${color12}${datetime}"
}

# cpu (from: https://bbs.archlinux.org/viewtopic.php?pid=661641#p661641)

while true; do
  # get new cpu idle and total usage
  eval $(awk '/^cpu /{print "cpu_idle_now=" $5 "; cpu_total_now=" $2+$3+$4+$5 }' /proc/stat)
  cpu_interval=$((cpu_total_now-${cpu_total_old:-0}))
  # calculate cpu usage (%)
  let cpu_used="100 * ($cpu_interval - ($cpu_idle_now-${cpu_idle_old:-0})) / $cpu_interval"

  # output vars
print_cpu_used() {
  printf "%-1b" "${color10}Ñ${color12}${cpu_used}%"
#"%-10b" "${color7}CPU:${cpu_used}%"
}
 
  # Pipe to status bar, not indented due to printing extra spaces/tabs
  xsetroot -name "$(print_power)${sp}$(print_uptime)${sp}$(print_wifiqual)${sp}$(print_hddfree)${sp}$(print_mem_used)${sp}$(print_cpu_used)${sp}$(print_volume)${sp}$(print_datetime)"

  # reset old rates
  cpu_idle_old=$cpu_idle_now
  cpu_total_old=$cpu_total_now
  # loop stats every 1 second
  sleep 1 
 done
