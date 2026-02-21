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
      "font-jetbrains-mono-nerd-font"
      "ghostty"
      "rancher"
      "raycast"
      "slack"
      "spotify"
      "zed"
    ];
  };
}
