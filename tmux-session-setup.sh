#!/bin/bash

SESSION='el-dev'
# Tests to see if the session already exists. If it does, just skip everything and reattach.
if [ "$(tmux list-sessions 2> /dev/null | grep -o $SESSION)" != "$SESSION" ]; then
  # Create session 
  tmux new-session -d -s $SESSION
  # Rename auto created window and create other windows 
  tmux rename-window -t $SESSION:1 'frontend'
  tmux new-window -t $SESSION:2 -n 'backend' "$SHELL"
  tmux new-window -t $SESSION:3 -n 'aws' "$SHELL"
  tmux new-window -t $SESSION:4 -n 'notes' "$SHELL"
  tmux new-window -t $SESSION:5 -n 'other' "$SHELL"
 
else
  tmux attach -t $SESSION
fi
