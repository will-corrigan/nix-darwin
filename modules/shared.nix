{ pkgs, lib, host, font, themeName, ... }:
let
  appearance = host.appearance or {};

  wallpaperName = appearance.wallpaper or "default";
  wallpaperPath =
    if wallpaperName == "custom"
    then ../. + "/${appearance.wallpaper_path or "wallpapers/default.avif"}"
    else if builtins.pathExists (../wallpapers + "/${wallpaperName}.avif")
    then ../wallpapers + "/${wallpaperName}.avif"
    else ../wallpapers/default.avif;
in
{
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = "nix-command flakes";
    download-buffer-size = 524288000;
    warn-dirty = false;
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${themeName}.yaml";
    image = wallpaperPath;
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.${font.pkg};
        name = font.mono;
      };
      sizes = {
        terminal = 10;
        applications = 10;
      };
    };
  };

  programs.zsh.enable = true;
}
