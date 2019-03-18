#!/bin/bash

# Disables ctrl-s and ctrl-q
stty -ixon 

# Allows you to cd into directory merely by typing the directory name
shopt -s autocd

# Infinite history
HISTSIZE= HISTFILESIZE=

# System Maintainance
alias sdn="sudo shutdown now"


# Some aliases
alias p="sudo pacman"
alias y="yay"
alias SS="sudo systemctl"
alias v="vim"
alias sv="sudo vim"
alias r="ranger"
alias ref="source ~/.bashrc"
alias sr="sudo ranger"
alias ka="killall"
alias g="git"
alias z="zathura"


# Adding color
alias ls='ls -hN --color=auto --group-directories-first'
alias grep="grep --color=auto" # Color grep - highlight desires sequence
alias ccat="highlight --out-format=ansi" # Color cat - print file with syntax highlight

# Internet
alias yt="youtube-dl --add-metadata ic" # Download video link
alias yta="youtube-dl --add-metadata -xic" # Download only audio
alias YT="youtube-viewer"
alias ethspeed="speedometer -r enp0s25"
alias wifispeed="speedometer -r wlp3s0"
alias starwars="telnet towel.blinkenlights.nl"

source ~/.shortcuts

# Run neofetch on startup
neofetch
