{ pkgs, ... }:
{
  # ── Nix ────────────────────────────────────────────────────────────

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = "nix-command flakes";
    download-buffer-size = 524288000;
    warn-dirty = false;
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 3; Minute = 0; };
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;

  # ── Fonts ──────────────────────────────────────────────────────────

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

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
      KeyRepeat = 1;
      InitialKeyRepeat = 10;
    };

    finder = {
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

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };

    NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;

    WindowManager.EnableStandardClickToShowDesktop = false;
  };
}
