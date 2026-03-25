{ pkgs, lib, host, font, themeName, ... }:
let
  appearance = host.appearance or {};
  macos = host.macos or {};
  keyboard = macos.keyboard or {};
  dock = macos.dock or {};
  finder = macos.finder or {};
  trackpad = macos.trackpad or {};

  wallpaperName = appearance.wallpaper or "default";
  wallpaperPath =
    if wallpaperName == "custom"
    then ../. + "/${appearance.wallpaper_path or "wallpaper.avif"}"
    else if builtins.pathExists (../wallpapers + "/${wallpaperName}.avif")
    then ../wallpapers + "/${wallpaperName}.avif"
    else ../wallpaper.avif;

  capsLockMap = {
    "escape" = true;
    "caps-lock" = false;
  };

  keyRepeatMap = {
    "slow" = 6;
    "medium" = 3;
    "fast" = 1;
  };

  repeatDelayMap = {
    "long" = 68;
    "medium" = 25;
    "short" = 10;
  };

  dockSizeMap = {
    "small" = 36;
    "medium" = 48;
    "large" = 72;
  };

  finderViewMap = {
    "list" = "Nlsv";
    "columns" = "clmv";
    "icons" = "icnv";
    "gallery" = "glyv";
  };
in
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
    image = wallpaperPath;
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
    remapCapsLockToEscape = capsLockMap.${keyboard.caps_lock or "escape"} or true;
  };

  # ── macOS Defaults ─────────────────────────────────────────────────

  system.defaults = {
    CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys."64".enabled = false;
    CustomUserPreferences."com.google.Keystone.Agent".checkInterval = 0;

    NSGlobalDomain = {
      AppleShowAllExtensions = finder.show_extensions or true;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      "com.apple.swipescrolldirection" = trackpad.natural_scroll or false;
      KeyRepeat = keyRepeatMap.${keyboard.key_repeat or "fast"} or 1;
      InitialKeyRepeat = repeatDelayMap.${keyboard.repeat_delay or "short"} or 10;
      NSDocumentSaveNewDocumentsToCloud = false;
    };

    finder = {
      AppleShowAllFiles = finder.show_hidden or true;
      FXPreferredViewStyle = finderViewMap.${finder.default_view or "list"} or "Nlsv";
      ShowPathbar = finder.show_path_bar or false;
      ShowStatusBar = false;
      _FXShowPosixPathInTitle = false;
      _FXSortFoldersFirst = true;
    };

    dock = {
      autohide = dock.auto_hide or true;
      show-recents = false;
      tilesize = dockSizeMap.${dock.icon_size or "medium"} or 48;
      minimize-to-application = dock.minimize_to_app or true;
      orientation = dock.position or "bottom";
    };

    trackpad = {
      Clicking = trackpad.tap_to_click or true;
      TrackpadThreeFingerDrag = true;
    };

    WindowManager.EnableStandardClickToShowDesktop = false;
  };
}
