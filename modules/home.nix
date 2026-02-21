{ lib, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.will = {
    home.username = "will";
    home.homeDirectory = lib.mkForce "/Users/will";
    home.stateVersion = "24.11";

    home.sessionVariables = {
      SSH_AUTH_SOCK = "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    };

    programs.git = {
      enable = true;
      settings = {
        user.name = "Will Corrigan";
        user.email = "will-corrigan@users.noreply.github.com";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
        commit.gpgsign = true;
        gpg.format = "ssh";
        gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHx5824VO9jx/mjYyVW8dcxywMn4dSk5KEbD3Eq2kCJ8";
      };
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        username = {
          show_always = true;
          format = "[$user]($style) ";
        };
        directory = {
          truncation_length = 3;
          truncate_to_repo = true;
        };
        git_branch = {
          format = "[$symbol$branch(:$remote_branch)]($style) ";
        };
        git_status = {
          format = "([$all_status$ahead_behind]($style) )";
        };
        nodejs = {
          format = "[$symbol($version)]($style) ";
        };
        nix_shell = {
          format = "[$symbol$state]($style) ";
        };
        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
        };
      };
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

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        extraOptions.IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
      };
    };

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "common-aliases" ];
      };
      shellAliases = {
        rebuild = "sudo darwin-rebuild switch --flake /etc/nix-darwin";
      };
      initContent = ''
        eval "$(mise activate zsh)"
      '';
    };

    home.file."Library/Application Support/com.mitchellh.ghostty/config" = {
      source = ../dotfiles/ghostty-config;
    };

    home.file.".config/zed/settings.json" = {
      source = ../dotfiles/zed-settings.jsonc;
    };
  };
}
