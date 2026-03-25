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


      fill.symbol = " ";

      # System
      os = {
        disabled = false;
        style = "bold text";
        symbols = {
          Macos = " ";
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
        read_only = " ";
        substitutions = {
          Documents = "󰈙 Documents";
          Downloads = " Downloads";
          Developer = " Developer";
        };
      };

      # Git
      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        symbol = " ";
        truncation_length = 30;
        style = "bold purple";
      };

      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
        style = "bold red";
        ahead = "↑\${count}";
        behind = "↓\${count}";
        diverged = "↕↑\${ahead_count}↓\${behind_count}";
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

      # Cloud & Infra
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
        symbol = " ";
        style = "bold yellow";
      };

      terraform = {
        format = "[$symbol$workspace]($style) ";
        symbol = " ";
        style = "bold lavender";
      };

      docker_context = {
        format = "[$symbol$context]($style) ";
        symbol = " ";
        style = "bold blue";
        only_with_files = true;
      };

      nix_shell = {
        format = "[$symbol$state( \\($name\\))]($style) ";
        symbol = " ";
        style = "bold blue";
        impure_msg = "impure";
        pure_msg = "pure";
      };

      container = {
        format = "[$symbol$name]($style) ";
        symbol = " ";
        style = "bold red";
      };

      # Package
      package = {
        format = "[$symbol$version]($style) ";
        symbol = " ";
        style = "bold peach";
      };

      # Languages
      golang = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
        style = "bold cyan";
      };

      nodejs = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
        style = "bold green";
      };

      python = {
        format = "[$symbol($version)( \\($virtualenv\\))]($style) ";
        symbol = " ";
        style = "bold yellow";
      };

      rust = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
        style = "bold red";
      };

      dotnet = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
        style = "bold lavender";
      };

      lua = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
        style = "bold blue";
      };

      deno = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
        style = "bold green";
      };

      zig = {
        format = "[$symbol($version)]($style) ";
        symbol = " ";
        style = "bold yellow";
      };

      # System indicators
      memory_usage = {
        disabled = false;
        threshold = 75;
        format = "[$symbol\${ram_pct}]($style) ";
        symbol = "󰈳 ";
        style = "bold dimmed yellow";
      };

      battery = {
        full_symbol = " ";
        charging_symbol = " ";
        discharging_symbol = " ";
        format = "[$symbol$percentage]($style) ";
        display = [
          { threshold = 20; style = "bold red"; }
          { threshold = 50; style = "bold yellow"; }
        ];
      };

      sudo = {
        disabled = false;
        format = "[$symbol]($style)";
        symbol = " ";
        style = "bold yellow";
      };

      status = {
        disabled = false;
        format = "[$symbol$status]($style) ";
        symbol = "✗ ";
        style = "bold red";
      };

      jobs = {
        format = "[$symbol$number]($style) ";
        symbol = "✦";
        threshold = 1;
      };

      # Duration & Time
      cmd_duration = {
        min_time = 2000;
        format = "[ $duration]($style) ";
        style = "bold yellow";
      };

      time = {
        disabled = false;
        format = "[ $time]($style)";
        style = "dimmed text";
        time_format = "%H:%M";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
        vimcmd_replace_one_symbol = "[❮](bold lavender)";
        vimcmd_replace_symbol = "[❮](bold lavender)";
        vimcmd_visual_symbol = "[❮](bold yellow)";
      };

    };
  };
}
