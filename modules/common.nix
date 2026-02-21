{ ... }:
{
  # ── Nix ────────────────────────────────────────────────────────────

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes";

  # ── Shell ──────────────────────────────────────────────────────────

  programs.zsh.enable = true;

  # ── Security ───────────────────────────────────────────────────────

  security.pam.services.sudo_local.touchIdAuth = true;

  # ── Keyboard ───────────────────────────────────────────────────────

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  # ── macOS Defaults ─────────────────────────────────────────────────

  system.defaults = {
    CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys."64".enabled = false;

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      "com.apple.swipescrolldirection" = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = false;
      ShowStatusBar = false;
      _FXShowPosixPathInTitle = false;
      _FXSortFoldersFirst = true;
    };

    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;
      persistent-apps = [
        "/System/Applications/System Settings.app"
        "/Applications/Google Chrome.app"
        "/Applications/1Password.app"
        "/Applications/Visual Studio Code.app"
        "/Applications/Slack.app"
        "/Applications/Discord.app"
        "/Applications/Spotify.app"
        "/Applications/Ghostty.app"
        "/Applications/Zed.app"
      ];
    };

    trackpad.Clicking = true;
  };
}
