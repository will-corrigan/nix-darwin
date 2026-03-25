{ ... }:
{
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
}
