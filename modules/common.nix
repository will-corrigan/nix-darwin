{ ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  system.defaults = {
    # Disable Spotlight shortcut (conflicts with other tools)
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
    };

    trackpad.Clicking = true;
  };
}
