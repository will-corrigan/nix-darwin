{
  config,
  lib,
  pkgs,
  ...
}:
let
  user = config.system.primaryUser;
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";

  home-manager.users.${user} = {
    home.username = user;
    home.homeDirectory = lib.mkForce "/Users/${user}";
    home.stateVersion = "24.11";

    home.sessionVariables = {
      SSH_AUTH_SOCK = "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    };

    # ── Shell ──────────────────────────────────────────────────────────

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "common-aliases"
        ];
      };
      shellAliases = {
        rebuild = "sudo darwin-rebuild switch --flake /etc/nix-darwin";
        ls = "eza";
        la = "eza -la --icons";
        ll = "eza -la --icons --git";
        lt = "eza -T -L 2 --icons";
        kube-stg = "aws login && aws eks update-kubeconfig --name contextfab-stg-infra-eks-cluster --region eu-west-1 --alias stg";
      };
      initContent = ''
        export PATH="$HOME/.rd/bin:$PATH"
        eval "$(mise activate zsh)"
        export GITHUB_TOKEN=$(op read "op://Employee/Github Token/credential")
      '';
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

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.bat.enable = true;

    # ── Git & SSH ──────────────────────────────────────────────────────

    programs.git = {
      enable = true;
      settings = {
        user.name = "Will Corrigan";
        user.email = "will-corrigan@users.noreply.github.com";
        user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHx5824VO9jx/mjYyVW8dcxywMn4dSk5KEbD3Eq2kCJ8";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
        commit.gpgsign = true;
        gpg.format = "ssh";
        gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
    };

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        extraOptions.IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
      };
    };

    # ── Dotfiles ───────────────────────────────────────────────────────

    home.file.".config/tmux/tmux.conf" = {
      source = ../dotfiles/tmux.conf;
    };

    home.file.".config/tmux/plugins/catppuccin/tmux" = {
      source = pkgs.tmuxPlugins.catppuccin.src;
      recursive = true;
    };

    home.file."Library/Application Support/com.mitchellh.ghostty/config" = {
      source = ../dotfiles/ghostty-config;
    };

    home.file.".config/zed/settings.json" = {
      source = ../dotfiles/zed-settings.jsonc;
    };

    home.file.".config/mise/config.toml" = {
      source = ../dotfiles/mise-config.toml;
    };
  };
}
