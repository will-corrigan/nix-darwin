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
      SSH_AUTH_SOCK = "/Users/${user}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    };

    # ── Shell ──────────────────────────────────────────────────────────

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        # Rebuild
        rebuild = "sudo nix flake update --flake /etc/nix-darwin && nh darwin switch /etc/nix-darwin";

        # File ops (safety)
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";

        # ls (eza)
        ls = "eza";
        la = "eza -la --icons";
        ll = "eza -la --icons --git";
        lt = "eza -T -L 2 --icons";

        # Git
        gst = "git status";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        gl = "git pull";
        gco = "git checkout";
        gb = "git branch";
        gd = "git diff";
        glog = "git log --oneline --graph --decorate";

        # Kubernetes
        kube-stg = "aws login && aws eks update-kubeconfig --name contextfab-stg-infra-eks-cluster --region eu-west-1 --alias stg";
      };
      initContent = ''
        export PATH="$HOME/.rd/bin:$PATH"
        eval "$(mise activate zsh)"
      '';
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        command_timeout = 1500;

        format = builtins.concatStringsSep "" [
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_status"
          "$git_metrics"
          "$git_state"
          "$fill"
          "$kubernetes"
          "$aws"
          "$terraform"
          "$docker_context"
          "$nix_shell"
          "$golang"
          "$nodejs"
          "$python"
          "$line_break"
          "$jobs"
          "$character"
        ];

        right_format = "$cmd_duration$time";

        fill.symbol = " ";

        directory = {
          truncation_length = 5;
          truncate_to_repo = true;
          style = "bold blue";
          format = "[$path]($style)[$read_only]($read_only_style) ";
          read_only = " 󰌾";
        };

        git_branch = {
          format = "[$symbol$branch(:$remote_branch)]($style) ";
          symbol = " ";
          truncation_length = 30;
          style = "bold purple";
        };

        git_status = {
          format = "([\\[$all_status$ahead_behind\\]]($style) )";
          style = "bold red";
          ahead = "⇡\${count}";
          behind = "⇣\${count}";
          diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
          conflicted = "=\${count}";
          deleted = "✘\${count}";
          renamed = "»\${count}";
          modified = "!\${count}";
          staged = "+\${count}";
          untracked = "?\${count}";
          stashed = "\\$\${count}";
        };

        git_metrics = {
          disabled = false;
          format = "([+$added]($added_style))([-$deleted]($deleted_style)) ";
          added_style = "bold green";
          deleted_style = "bold red";
        };

        git_state = {
          format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
          style = "bold yellow";
        };

        kubernetes = {
          disabled = false;
          format = "[$symbol$context( \\($namespace\\))]($style) ";
          symbol = "☸ ";
          style = "bold cyan";
          context_aliases = {
            "arn:aws:eks:eu-west-1:.*:cluster/contextfab-stg-infra-eks-cluster" = "stg";
            "arn:aws:eks:eu-west-1:.*:cluster/contextfab-prod-infra-eks-cluster" = "prod";
          };
        };

        aws = {
          disabled = false;
          format = "[$symbol($profile)(\\($region\\))(\\[$duration\\])]($style) ";
          symbol = " ";
          style = "bold yellow";
        };

        terraform = {
          format = "[$symbol$workspace]($style) ";
          symbol = "💠";
          style = "bold 105";
        };

        docker_context = {
          format = "[$symbol$context]($style) ";
          symbol = " ";
          style = "bold blue";
          only_with_files = true;
        };

        nix_shell = {
          format = "[$symbol$state( \\($name\\))]($style) ";
          symbol = " ";
          style = "bold blue";
          impure_msg = "impure";
          pure_msg = "pure";
        };

        golang = {
          format = "[$symbol($version)]($style) ";
          symbol = " ";
          style = "bold cyan";
        };

        nodejs = {
          format = "[$symbol($version)]($style) ";
          symbol = " ";
          style = "bold green";
        };

        python = {
          format = "[$symbol($version)( \\($virtualenv\\))]($style) ";
          symbol = " ";
          style = "bold yellow";
        };

        cmd_duration = {
          min_time = 2000;
          format = "[ $duration]($style) ";
          style = "bold yellow";
        };

        time = {
          disabled = false;
          format = "[ $time]($style)";
          style = "dimmed white";
          time_format = "%H:%M";
        };

        jobs = {
          format = "[$symbol$number]($style) ";
          symbol = "✦";
          threshold = 1;
        };

        username = {
          show_always = false;
          format = "[$user]($style) ";
        };

        hostname = {
          ssh_only = true;
          format = "[@$hostname]($style) ";
          style = "bold dimmed white";
        };

        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
          vimcmd_symbol = "[❮](bold green)";
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
      defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
      defaultOptions = [
        "--height=60%"
        "--layout=reverse"
        "--border=rounded"
        "--prompt='  '"
        "--pointer='▶'"
        "--marker='✓'"
        "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8"
        "--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc"
        "--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
        "--color=selected-bg:#45475a"
        "--color=border:#6c7086,label:#cdd6f4"
        "--preview='bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || eza -la --color=always --icons {}'"
        "--preview-window=right,50%,border-left"
        "--multi"
        "--bind='ctrl-d:half-page-down,ctrl-u:half-page-up'"
        "--bind='ctrl-y:execute-silent(echo -n {+} | pbcopy)'"
      ];
      fileWidgetCommand = "fd --type f --hidden --strip-cwd-prefix --exclude .git";
      fileWidgetOptions = [
        "--preview='bat --color=always --style=numbers --line-range=:300 {}'"
      ];
      changeDirWidgetCommand = "fd --type d --hidden --strip-cwd-prefix --exclude .git";
      changeDirWidgetOptions = [
        "--preview='eza -la --color=always --icons {}'"
      ];
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.bat = {
      enable = true;
      config = {
        theme = "catppuccin-mocha";
        style = "numbers,changes,header,grid";
        italic-text = "always";
        pager = "less -FR";
      };
      themes = {
        catppuccin-mocha = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
            hash = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
          };
          file = "themes/Catppuccin Mocha.tmTheme";
        };
      };
    };

    programs.btop = {
      enable = true;
      settings = {
        color_theme = "catppuccin_mocha";
        theme_background = false;
        vim_keys = true;
      };
    };

    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
        aliases = {
          co = "pr checkout";
        };
      };
    };

    # ── Git & SSH ──────────────────────────────────────────────────────

    programs.git = {
      enable = true;
      signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHx5824VO9jx/mjYyVW8dcxywMn4dSk5KEbD3Eq2kCJ8";
        signByDefault = true;
        format = "ssh";
        signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
      settings = {
        user.name = "Will Corrigan";
        user.email = "will-corrigan@users.noreply.github.com";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
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
