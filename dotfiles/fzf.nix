{ ... }:
{
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
}
