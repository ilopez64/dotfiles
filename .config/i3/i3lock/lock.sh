#!/usr/bin/env bash

# What you need to modify if you want to use this script:

# Change the -i value to point to your wallpaper's path.

# Change the --indpos and --radius values, so that the unlock indicator is correctly aligned for the wallpaper you use and screen resolution. I did that with trial and error.

# You need to start compton with the --dbus flag to be able to control its settings from a script like I'm doing. On some drivers/compton versions, using the --dbus flag along with the -b flag may cause a segfault. In that case, use something like compton --dbus & instead of compton -b --dbus.

#####################################################################

# Custom result

# WALLPAPER
#
# See screenshot as wallpaper
# value: Boolean
use_screenshot=true
#
# If set $use_screenshot as false, have to declare wallpaper absolute path
# value: Boolean
wallpaper=false
#

# EDIT WALLPAPER
#
# Blur value
# available value here: https://imagemagick.org/Usage/blur/blur_montage.jpg
blur_value=0x4
#
# Dim percent value
# value: Percent
dim_value=60%
#

# LOCK LAYER
#
# Use Lock layer or not
# value: Boolean
use_lock=true
lock="$HOME/projects/tungcena-i3lock/lock.png"
#
# Set Lock layer location in screen
# value: Percent or Number in pixel
lock_x=10%
lock_y=80%
#
# Set coordinates where Lock ring input will appear inside lock layer
# Lock ring input appears inside Lock layer
# value: Boolean
ring_inside_lock=true
#
# should set center of lock icon
# so Lock ring input will overlay lock icon
# if $ring_inside_lock is false, $ring_x and $ring_y will be coordinates of screen
# value: Number in pixel
ring_x=10
ring_y=10
#

#####################################################################

# Set screenshot path. No need to pay attention
screenshot="$HOME/screenshot.png"

# Get screen resolution
screen_w=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
screen_h=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)

# Take a screenshot
if [[ "$use_screenshot" = true ]]
then
  scrot -q 100 $screenshot
else
  # Resize default wallpaper and save to $screenshot
  convert "$wallpaper" \
    -resize "$screen_w"x"$screen_h"! \
    "$screenshot"
fi

# Blur and Dim $screenshot
convert "$screenshot" \
  -fill black -colorize "$dim_value" \
  -filter Gaussian \
  -blur "$blur_value" \
  "$screenshot"

# Merge Lock layer and $screenshot
if [[ "$use_lock" = true ]]
then
  lock_w=$(magick identify -format "%w" $lock)
  lock_h=$(magick identify -format "%h" $lock)
  x=$lock_x
  y=$lock_y

  if [[ $lock_x =~ "%" ]]
  then
    x=$(($(echo $lock_x| cut -d'%' -f 1)*$screen_w/100))
  fi

  if [[ $lock_y =~ "%" ]]
  then
    y=$(($(echo $lock_y| cut -d'%' -f 1)*$screen_h/100))
  fi

  if [[ $x < 0 ]]
  then
    merge_x=-$x
  else
    merge_x=+$x
  fi

  if [[ $y < 0 ]]
  then
    merge_y=-$y
  else
    merge_y=+$y
  fi

  convert "$screenshot" \
    "$lock" -geometry "$merge_x""$merge_y" -composite \
    "$screenshot"
fi

# Calculate Lock ring input location
if [[ $ring_inside_lock = true ]]
then
  ring_screen_x=$(($x+$ring_x))
  ring_screen_y=$(($y+$ring_y))
else
  ring_screen_x=$ring_x
  ring_screen_y=$ring_y
fi

# Enable compton's fade-in effect so that the lockscreen gets a nice fade-in
# effect.
# dbus-send --print-reply --dest=com.github.chjj.compton.${DISPLAY/:/_} / \
#     com.github.chjj.compton.opts_set string:no_fading_openclose boolean:false

# If disable unredir_if_possible is enabled in compton's config, we may need to
# disable that to avoid flickering. YMMV. To try that, uncomment the following
# two lines and the last two lines in this script.
# dbus-send --print-reply --dest=com.github.chjj.compton.${DISPLAY/:/_} / \
#     com.github.chjj.compton.opts_set string:unredir_if_possible boolean:false

# Suspend dunst and lock, then resume dunst when unlocked.
pkill -u $USER -USR1 dunst

# LOCK
i3lock -n -i $screenshot \
  --insidecolor=373445ff --ringcolor=ffffffff --line-uses-inside \
  --keyhlcolor=d23c3dff --bshlcolor=d23c3dff --separatorcolor=00000000 \
  --insidevercolor=fecf4dff --insidewrongcolor=d23c3dff \
  --ringvercolor=ffffffff --ringwrongcolor=ffffffff \
  --veriftext="" --wrongtext="" --noinputtext="" \
  --indpos="x+"$ring_screen_x":y+"$ring_screen_y"" \
  --radius=10 --ring-width=5

pkill -u $USER -USR2 dunst

# Remove temporary wallpaper
rm $screenshot

# Revert compton's config changes.
sleep 0.2
# dbus-send --print-reply --dest=com.github.chjj.compton.${DISPLAY/:/_} / \
#     com.github.chjj.compton.opts_set string:no_fading_openclose boolean:true
# dbus-send --print-reply --dest=com.github.chjj.compton.${DISPLAY/:/_} / \
#     com.github.chjj.compton.opts_set string:unredir_if_possible boolean:true
