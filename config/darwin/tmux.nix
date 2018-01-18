{ config, pkgs, ... }: {

  programs.tmux.enable = true;

  programs.tmux.enableSensible = true;

  programs.tmux.enableFzf = true;

  programs.tmux.enableVim = true;

  programs.tmux.tmuxConfig = ''
      # remap prefix to Control + a
      unbind C-b
      set-option -g prefix C-a

      # pass through a ctrl-a if you press it twice
      bind C-a send-prefix

      # 256 color
      set -g default-terminal "xterm-256color"

      # start first window and pane at 1, not zero
      set -g base-index 1
      set -g pane-base-index 1

      # Rebind close window
      bind q confirm kill-window

      # Rebind pane splitting
      bind v split-window -h
      bind s split-window -v

      # Vim-style pane navigation
      bind  h  select-pane -L                                 # Select the pane to the left
      bind  j  select-pane -D                                 # Select the pane below
      bind  k  select-pane -U                                 # Select the pane above
      bind  l  select-pane -R                                 # Select the pane to the right

      bind C-h resize-pane -L
      bind C-j resize-pane -D
      bind C-k resize-pane -U
      bind C-l resize-pane -R

      #Title bar
      set-option -g set-titles on
      set-option -g set-titles-string "#(whoami)@#H [#S-#I-#P] #W - #T"

      # Left status bar
      set -g status-bg colour235
      set -g status-left-fg colour239
      set -g status-left-length 30
      set -g status-left '#[bg=colour234,fg=colour239] #(whoami)@#H [#S-#I-#P] #[default]'

      # Window status bars
      set -g window-status-current-format '#[fg=white,bg=colour239,noreverse,bold] #I : #W '
      set -g window-status-format '#[fg=colour245] #I : #W '

      # Right status bar
      set -g status-right '#[bg=colour234] #[fg=colour239]%Y-%m-%d #[fg=colour239]| #[fg=colour239]%I:%M '

      # Message
      set -g message-bg blue
      set -g message-fg white
      set -g message-attr bright

      # border
      set -g pane-border-fg colour235
      set -g pane-active-border-fg colour239

      # Don't automatically rename windows
      set -g automatic-rename off

      # set up alias for turning on logging
      bind P pipe-pane 'exec cat >>~/tmux-#W.log' \; display-message "Toggled logging to ~/tmux-#W.log"
      bind p pipe-pane \; display-message 'Ended logging to $HOME/tmux-#W.log'
  '';

}

