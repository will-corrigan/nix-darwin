{
  description = "Declarative macOS with nix-darwin, home-manager, and Stylix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:nix-community/stylix";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      stylix,
    }:
    let
      fonts = import ./fonts.nix;
      direnvOverlay = final: prev: {
        direnv = prev.direnv.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace GNUmakefile --replace-fail "-linkmode=external" ""
          '';
        });
      };
      sharedModules = [
        { nixpkgs.overlays = [ direnvOverlay ]; }
        stylix.darwinModules.stylix
        ./modules/common.nix
        ./modules/packages.nix
        ./modules/homebrew.nix
        home-manager.darwinModules.home-manager
        ./modules/home.nix
      ];
      mkDarwin = hostFile:
        let
          host = import hostFile { inherit fonts; };
          file = builtins.baseNameOf (toString hostFile);
          require = field:
            if host ? ${field} then host.${field}
            else builtins.throw "${file}: missing required field '${field}'";
        in
        assert require "platform" != null;
        assert require "primaryUser" != null;
        assert require "user" != null;
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit self;
            font = host.font or fonts.monaspace.neon;
            user = host.user;
            themeName = host.themeName or "catppuccin-mocha";
          };
          modules = sharedModules ++ [
            {
              nixpkgs.hostPlatform = host.platform;
              system.primaryUser = host.primaryUser;
              system.stateVersion = 6;
              system.configurationRevision = self.rev or self.dirtyRev or null;
            }
          ];
        };
    in
    {
      darwinConfigurations."Wills-MacBook-Air" = mkDarwin ./hosts/macbook-air.nix;
      darwinConfigurations."Wills-MacBook-Pro" = mkDarwin ./hosts/macbook-pro.nix;
    };
}
