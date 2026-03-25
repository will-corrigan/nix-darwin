{ ... }:
{
  homebrew = {
    enable = true;
    enableZshIntegration = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";

    brews = [
      "awscli"
      "mise"
    ];

    casks = [
      "1password"
      "claude-code"
      "discord"

      "ghostty"
      "google-chrome"
      "google-cloud-sdk"
      "rancher"
      "raycast"
      "slack"
      "spotify"
      "visual-studio-code"
      "zed"
    ];
  };
}
