{ pkgs, lib, host, ... }:
let
  extraPkgs = host.extra_packages or {};
  cliExtras = extraPkgs.cli or [];

  # Minimal base packages the framework needs
  basePackages = with pkgs; [
    nh
  ];

  # Map string names to packages
  extraPackages = map (name:
    if builtins.hasAttr name pkgs
    then pkgs.${name}
    else builtins.throw "extra_packages.cli: unknown nixpkgs package '${name}'. Browse: https://search.nixos.org/packages"
  ) cliExtras;
in
{
  environment.systemPackages = basePackages ++ extraPackages;
}
