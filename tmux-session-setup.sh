#!/bin/bash

SESSION='el-dev'
# Tests to see if the session already exists. If it does, just skip everything and reattach.
if [ "$(tmux list-sessions 2> /dev/null | grep -o $SESSION)" != "$SESSION" ]; then
  # Create session 
  tmux new-session -d -s $SESSION
  # Create windows
  tmux unlink-window -k -t $SESSION:1
  tmux new-window -t $SESSION:1 -n 'frontend' "$SHELL"
  tmux new-window -t $SESSION:2 -n 'backend' "$SHELL"
  tmux new-window -t $SESSION:3 -n 'aws' "$SHELL"
  tmux new-window -t $SESSION:4 -n 'notes' "$SHELL"
  tmux new-window -t $SESSION:5 -n 'other' "$SHELL"
 
  # Gets rid of window 0, which is not accessible right away (hence sleep 1)
  sleep 1
  tmux unlink-window -k -t $SESSION:0
 
else
  tmux attach -t $SESSION
fi
