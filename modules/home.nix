{ lib, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.will = {
    home.username = "will";
    home.homeDirectory = lib.mkForce "/Users/will";
    home.stateVersion = "24.11";

    programs.git = {
      enable = true;
      settings = {
        user.name = "Will Corrigan";
        user.email = "will-corrigan@users.noreply.github.com";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
      };
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.bat.enable = true;

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ga = "git add";
        gc = "git commit";
        gco = "git checkout";
        gd = "git diff";
        gl = "git log --oneline";
        gp = "git push";
        gpl = "git pull";
        gs = "git status";
      };
      initContent = ''
        eval "$(mise activate zsh)"
      '';
    };

    home.file.".config/ghostty/config" = {
      source = ../dotfiles/ghostty-config;
    };

    home.file.".config/zed/settings.json" = {
      source = ../dotfiles/zed-settings.jsonc;
    };
  };
}
