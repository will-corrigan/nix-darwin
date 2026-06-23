{
  pkgs,
  lib,
  host,
  ...
}:
let
  macos = host.macos or { };
  keyboard = macos.keyboard or { };
  dock = macos.dock or { };
  finder = macos.finder or { };
  trackpad = macos.trackpad or { };
  textReplacements = macos.text_replacements or { };

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

  keyboardLayoutMap = {
    "us" = {
      id = 0;
      name = "U.S.";
    };
    "british" = {
      id = 2;
      name = "British";
    };
    "british-pc" = {
      id = -2351;
      name = "British-PC";
    };
  };
  layoutKey = keyboard.layout or "us";
  layout = keyboardLayoutMap.${layoutKey} or keyboardLayoutMap."us";

  inputSourceEntry = {
    InputSourceKind = "Keyboard Layout";
    "KeyboardLayout ID" = layout.id;
    "KeyboardLayout Name" = layout.name;
  };

  replacementItems = lib.mapAttrsToList (k: v: {
    on = 1;
    replace = k;
    "with" = v;
  }) textReplacements;

  dockApps = dock.apps or [ ];
  clearOthers = dock.clear_others or false;
in
{
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 3;
      Minute = 0;
    };
    options = "--delete-older-than 7d";
  };
  nix.optimise.automatic = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = capsLockMap.${keyboard.caps_lock or "escape"} or true;
  };

  system.defaults = {
    CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys."64".enabled = false;
    CustomUserPreferences."com.google.Keystone.Agent".checkInterval = 0;
    CustomUserPreferences."com.apple.HIToolbox" = {
      AppleEnabledInputSources = [
        inputSourceEntry
        {
          "Bundle ID" = "com.apple.CharacterPaletteIM";
          InputSourceKind = "Non Keyboard Input Method";
        }
      ];
      AppleSelectedInputSources = [ inputSourceEntry ];
      AppleCurrentKeyboardLayoutInputSourceID = "com.apple.keylayout.${layout.name}";
    };
    CustomUserPreferences.NSGlobalDomain.NSUserDictionaryReplacementItems = replacementItems;

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
    }
    // (if dockApps != [ ] then { persistent-apps = dockApps; } else { })
    // (if clearOthers then { persistent-others = [ ]; } else { });

    trackpad = {
      Clicking = trackpad.tap_to_click or true;
      TrackpadThreeFingerDrag = true;
    };

    WindowManager.EnableStandardClickToShowDesktop = false;
  };
}
