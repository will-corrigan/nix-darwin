{ ... }:
{
  homebrew = {
    enable = true;
    enableZshIntegration = true;
    onActivation.cleanup = "zap";
    casks = [
      "1password"
      "claude-code"
      "discord"
      "google-chrome"
      "font-jetbrains-mono-nerd-font"
      "ghostty"
      "rancher"
      "raycast"
      "slack"
      "spotify"
      "visual-studio-code"
      "zed"
    ];
  };
}
