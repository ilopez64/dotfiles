#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Adds '/.scripts' an all subdirectories to $PATH
export PATH=$PATH:$HOME
export EDITOR="vim"
export TERMINAL="st"
export BROWSER="firefox"
export READER="zathura"
export FILE="ranger"

# Start graphical server if i3 not already running
if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep i3 || startx
fi

