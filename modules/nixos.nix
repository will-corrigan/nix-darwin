{ pkgs, lib, host, nixos-wsl, ... }:
let
  username = host.machine.username;
  machineType = host.machine.type or "linux";
in
{
  # ── NixOS-WSL ──────────────────────────────────────────────────────

  imports = lib.optionals (machineType == "wsl") [
    nixos-wsl.nixosModules.wsl
  ];

  wsl = lib.mkIf (machineType == "wsl") {
    enable = true;
    defaultUser = username;
  };

  # ── Nix GC & Optimise (systemd format) ─────────────────────────────

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  # ── NixOS System ───────────────────────────────────────────────────

  users.users.${username} = {
    isNormalUser = true;
    shell = lib.mkIf (builtins.hasAttr "zsh" (host.programs or {})) pkgs.zsh;
  };

  networking.hostName = host.machine.computer_name;
  system.stateVersion = "24.11";
}
