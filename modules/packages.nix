{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    _1password-cli
    awscli2
    bruno
    eza
    fd
    flyctl

    glow
    google-cloud-sdk
    jq
    k9s
    kubectl
    mise
    nixd
    nh
    nixfmt
    p7zip
    ripgrep
    sqlite
    terraform-ls
    tldr
    tmux
    tree
    vim
    wget
    yq
  ];
}
