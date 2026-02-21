{
  description = "Will's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
    }:
    let
      sharedModules = [
        ./modules/common.nix
        ./modules/packages.nix
        ./modules/homebrew.nix
      ];
    in
    {
      darwinConfigurations."Wills-MacBook-Air" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self; };
        modules = sharedModules ++ [ ./hosts/macbook-air.nix ];
      };

      darwinConfigurations."Wills-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self; };
        modules = sharedModules ++ [ ./hosts/macbook-pro.nix ];
      };
    };
}
