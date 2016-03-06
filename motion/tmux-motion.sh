#!/bin/bash

S=motion
T=/usr/bin/tmux
if $T has-session -t $S
then
    exit
fi

$T new-session -d -s $S
$T new-window -t $S:1 -n motion "git/rpi/motion/motion.py"
