{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    _1password-cli
    bruno
    fd
    flyctl
    gcc
    gh
    google-cloud-sdk
    jq
    kubectl
    mise
    nixd
    nixfmt
    nodejs_24
    openssh
    ripgrep
    sqlite
    terraform
    terraform-ls
    tree
    vim
    yq
  ];
}
