# Change this according to your device
################
# Variables
################

# Keyboard input name
keyboard_input_name="1:1:AT_Translated_Set_2_keyboard"

# Date and time
date_and_time=$(date "+%Y-%m-%d %X")

#############
# Commands
#############

# Battery or charger
battery_charge=$(upower --show-info $(upower --enumerate | grep 'BAT0') | egrep "percentage" | awk '{print $2}')
battery_status=$(upower --show-info $(upower --enumerate | grep 'BAT0') | egrep "state" | awk '{print $2}')

# Audio and multimedia
audio_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -n1 | sed 's/%//')
audio_is_muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

# Network
wifi=$(nmcli -t -f active,ssid dev wifi | grep ^yes | cut -d: -f2)

# Others
language=$(swaymsg -r -t get_inputs | awk '/1:1:AT_Translated_Set_2_keyboard/;/xkb_active_layout_name/' | grep -A1 '\b1:1:AT_Translated_Set_2_keyboard\b' | grep "xkb_active_layout_name" | awk -F '"' '{print $4}')

# Removed weather because we are requesting it too many times to have a proper
# refresh on the bar
#weather=$(curl -Ss 'https://wttr.in/Pontevedra?0&T&Q&format=1')

if [ $battery_status = "charging" ];
then
    battery_pluggedin='󰂄 '
else
    battery_pluggedin='󰁹 '
fi

if [ $audio_is_muted = "yes" ]
then
    audio_active='󰖁 '
else
    audio_active='󰕾 '
fi

# battery_info=$(if [ "$battery_status" == "charging" ]; then echo "$battery_pluggedin"; fi)
audio_info=$(if [ "$audio_is_muted" == "no" ]; then echo "$audio_volume%"; fi) 

echo "⌨ $language | $wifi | $audio_active$audio_info| $date_and_time | $battery_pluggedin$battery_charge |" 

