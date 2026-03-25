{ ... }:
{
  programs.ghostty = {
    enable = true;
    package = null;
    settings = {
      font-thicken = true;
      adjust-cell-height = 2;

      background-opacity = 0.92;
      background-blur-radius = 20;
      cursor-style = "bar";
      cursor-style-blink = false;
      mouse-hide-while-typing = true;
      minimum-contrast = 1.1;
      unfocused-split-opacity = 0.85;

      macos-option-as-alt = true;

      window-padding-x = 10;
      window-padding-y = 6;
      window-padding-balance = true;
      window-padding-color = "extend";
      window-save-state = "always";
      window-decoration = true;

      copy-on-select = true;
      confirm-close-surface = false;
      shell-integration = "zsh";
      shell-integration-features = "cursor,sudo,title";

      keybind = [
        "cmd+shift+enter=new_split:right"
        "cmd+shift+minus=new_split:down"
        "cmd+opt+left=goto_split:left"
        "cmd+opt+right=goto_split:right"
        "cmd+opt+up=goto_split:top"
        "cmd+opt+down=goto_split:bottom"
        "cmd+shift+comma=reload_config"
      ];
    };
  };
}
