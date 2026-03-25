{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    _1password-cli
    bruno
    eza
    fd
    flyctl
    glow
    jq
    k9s
    kubectl

    nixd
    nh
    nixfmt
    p7zip
    ripgrep
    sqlite
    terraform-ls
    tldr
    tree
    vim
    wget
    yq
  ];
}
