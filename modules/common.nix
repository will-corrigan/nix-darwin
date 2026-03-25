{ pkgs, font, themeName, ... }:
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
    options = "--delete-older-than 7d";
  };
  nix.optimise.automatic = true;

  # ── Stylix ────────────────────────────────────────────────────────

  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${themeName}.yaml";
    image = ../wallpaper.avif;
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.${font.pkg};
        name = font.mono;
      };
      sizes = {
        terminal = 10;
        applications = 10;
      };
    };
  };

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
    CustomUserPreferences."com.google.Keystone.Agent".checkInterval = 0;

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
