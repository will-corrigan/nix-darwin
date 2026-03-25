{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    mouse = true;
    keyMode = "vi";
    escapeTime = 0;
    baseIndex = 1;
    terminal = "tmux-256color";
    historyLimit = 50000;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_window_text " #W"
          set -g @catppuccin_window_current_text " #W"
          set -g @catppuccin_date_time_text " %a %d %b %H:%M"
        '';
      }
    ];
    extraConfig = ''
      setw -g pane-base-index 1
      set -g allow-rename off
      set -g automatic-rename off
      set -g renumber-windows on
      set -g focus-events on
      set -g display-time 4000
      set -g display-panes-time 4000
      set -g repeat-time 1000
      set -g status-interval 5
      setw -g aggressive-resize on

      # True Color & Undercurl
      set -as terminal-overrides ",*:Tc"
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'

      # Extended Keys & Clipboard
      set -g extended-keys on
      set -as terminal-features 'xterm*:extkeys'
      set -g set-clipboard on
      set -g set-titles on
      set -g set-titles-string "#S / #W"

      # Copy Mode (vi + macOS clipboard)
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"

      # Splits & Windows
      bind \\ split-window -h -c "#{pane_current_path}"
      bind _ split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Pane Navigation (vim)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Pane Resizing (vim)
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Window Management
      bind -r n next-window
      bind -r p previous-window
      bind -r < swap-window -d -t -1
      bind -r > swap-window -d -t +1
      bind S choose-tree -sZ

      # Misc
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"

      # Status
      set -g status-position bottom
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_session} #{E:@catppuccin_status_application} #{E:@catppuccin_status_date_time}"
    '';
  };
}
