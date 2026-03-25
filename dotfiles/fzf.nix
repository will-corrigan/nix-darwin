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
}
