{ ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      command_timeout = 1500;

      format = builtins.concatStringsSep "" [
        "$os"
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
        "$package"
        "$golang"
        "$nodejs"
        "$python"
        "$rust"
        "$dotnet"
        "$lua"
        "$deno"
        "$zig"
        "$container"
        "$memory_usage"
        "$battery"
        "$line_break"
        "$sudo"
        "$status"
        "$jobs"
        "$character"
      ];

      right_format = "$cmd_duration$time";

      palette = "catppuccin_mocha";

      fill.symbol = " ";

      # System
      os = {
        disabled = false;
        style = "bold text";
        symbols = {
          Macos = "\u{f179} ";
        };
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

      directory = {
        truncation_length = 5;
        truncate_to_repo = true;
        style = "bold blue";
        format = "[$path]($style)[$read_only]($read_only_style) ";
        read_only = " \u{f023}";
        substitutions = {
          Documents = "\u{f0219} Documents";
          Downloads = "\u{f019} Downloads";
          Developer = "\u{e26f} Developer";
        };
      };

      # Git
      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        symbol = "\u{e0a0} ";
        truncation_length = 30;
        style = "bold purple";
      };

      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
        style = "bold red";
        ahead = "\u{2191}\${count}";
        behind = "\u{2193}\${count}";
        diverged = "\u{2195}\u{2191}\${ahead_count}\u{2193}\${behind_count}";
        conflicted = "=\${count}";
        deleted = "\u{2718}\${count}";
        renamed = "\u{00bb}\${count}";
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

      # Cloud & Infra
      kubernetes = {
        disabled = false;
        format = "[$symbol$context( \\($namespace\\))]($style) ";
        symbol = "\u{2638} ";
        style = "bold cyan";
        context_aliases = {
          "arn:aws:eks:eu-west-1:.*:cluster/contextfab-stg-infra-eks-cluster" = "stg";
          "arn:aws:eks:eu-west-1:.*:cluster/contextfab-prod-infra-eks-cluster" = "prod";
        };
      };

      aws = {
        disabled = false;
        format = "[$symbol($profile)(\\($region\\))(\\[$duration\\])]($style) ";
        symbol = "\u{e7ad} ";
        style = "bold yellow";
      };

      terraform = {
        format = "[$symbol$workspace]($style) ";
        symbol = "\u{f1b2} ";
        style = "bold lavender";
      };

      docker_context = {
        format = "[$symbol$context]($style) ";
        symbol = "\u{e7b0} ";
        style = "bold blue";
        only_with_files = true;
      };

      nix_shell = {
        format = "[$symbol$state( \\($name\\))]($style) ";
        symbol = "\u{f313} ";
        style = "bold blue";
        impure_msg = "impure";
        pure_msg = "pure";
      };

      container = {
        format = "[$symbol$name]($style) ";
        symbol = "\u{e7b0} ";
        style = "bold red";
      };

      # Package
      package = {
        format = "[$symbol$version]($style) ";
        symbol = "\u{f187} ";
        style = "bold peach";
      };

      # Languages
      golang = {
        format = "[$symbol($version)]($style) ";
        symbol = "\u{e626} ";
        style = "bold cyan";
      };

      nodejs = {
        format = "[$symbol($version)]($style) ";
        symbol = "\u{e718} ";
        style = "bold green";
      };

      python = {
        format = "[$symbol($version)( \\($virtualenv\\))]($style) ";
        symbol = "\u{e235} ";
        style = "bold yellow";
      };

      rust = {
        format = "[$symbol($version)]($style) ";
        symbol = "\u{e7a8} ";
        style = "bold red";
      };

      dotnet = {
        format = "[$symbol($version)]($style) ";
        symbol = "\u{e77f} ";
        style = "bold lavender";
      };

      lua = {
        format = "[$symbol($version)]($style) ";
        symbol = "\u{e620} ";
        style = "bold blue";
      };

      deno = {
        format = "[$symbol($version)]($style) ";
        symbol = "\u{e628} ";
        style = "bold green";
      };

      zig = {
        format = "[$symbol($version)]($style) ";
        symbol = "\u{e6a9} ";
        style = "bold yellow";
      };

      # System indicators
      memory_usage = {
        disabled = false;
        threshold = 75;
        format = "[$symbol\${ram_pct}]($style) ";
        symbol = "\u{f0233} ";
        style = "bold dimmed yellow";
      };

      battery = {
        full_symbol = "\u{f240} ";
        charging_symbol = "\u{f0e7} ";
        discharging_symbol = "\u{f242} ";
        format = "[$symbol$percentage]($style) ";
        display = [
          { threshold = 20; style = "bold red"; }
          { threshold = 50; style = "bold yellow"; }
        ];
      };

      sudo = {
        disabled = false;
        format = "[$symbol]($style)";
        symbol = "\u{f09c} ";
        style = "bold yellow";
      };

      status = {
        disabled = false;
        format = "[$symbol$status]($style) ";
        symbol = "\u{2717} ";
        style = "bold red";
      };

      jobs = {
        format = "[$symbol$number]($style) ";
        symbol = "\u{2726}";
        threshold = 1;
      };

      # Duration & Time
      cmd_duration = {
        min_time = 2000;
        format = "[\u{f253} $duration]($style) ";
        style = "bold yellow";
      };

      time = {
        disabled = false;
        format = "[\u{f017} $time]($style)";
        style = "dimmed text";
        time_format = "%H:%M";
      };

      character = {
        success_symbol = "[\u{276f}](bold green)";
        error_symbol = "[\u{276f}](bold red)";
        vimcmd_symbol = "[\u{276e}](bold green)";
        vimcmd_replace_one_symbol = "[\u{276e}](bold lavender)";
        vimcmd_replace_symbol = "[\u{276e}](bold lavender)";
        vimcmd_visual_symbol = "[\u{276e}](bold yellow)";
      };

      # Catppuccin Mocha palette
      palettes.catppuccin_mocha = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";
      };
    };
  };
}
