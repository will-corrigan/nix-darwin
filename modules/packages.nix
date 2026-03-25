{ pkgs, lib, host, ... }:
let
  extraPkgs = host.extra_packages or {};
  cliExtras = extraPkgs.cli or [];

  # Minimal base packages the framework needs
  basePackages = with pkgs; [
    nh
  ];

  # Map string names to packages
  extraPackages = map (name: pkgs.${name}) cliExtras;
in
{
  environment.systemPackages = basePackages ++ extraPackages;
}
