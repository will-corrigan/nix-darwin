{ ... }:
{
  homebrew = {
    enable = true;
    enableZshIntegration = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";

    casks = [
      "1password"
      "claude-code"
      "discord"
      "font-jetbrains-mono-nerd-font"
      "ghostty"
      "google-chrome"
      "rancher"
      "raycast"
      "slack"
      "spotify"
      "visual-studio-code"
      "zed"
    ];
  };
}
