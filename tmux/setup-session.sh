#!/bin/bash

NUM_WINDOWS=$(tmux list-windows | wc -l)

tmux new-window -n "Editor" "nvim"
tmux new-window -n "Shell1" "zsh"
tmux new-window -n "Shell2" "zsh"

tmux select-window -t "$NUM_WINDOWS"
for i in $( seq 0 $(($NUM_WINDOWS - 1)) ); do
	tmux kill-window -t $i
done

tmux move-window -r

tmux select-window -t 0
tmux split-window -h "claude"
