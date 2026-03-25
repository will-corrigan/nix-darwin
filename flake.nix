{
  description = "Will's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
    }:
    let
      fonts = {
        jetbrains-mono = builtins.mapAttrs (_: v: v // { pkg = "jetbrains-mono"; }) {
          default      = { name = "JetBrainsMono Nerd Font";   mono = "JetBrainsMono Nerd Font Mono"; };
          no-ligatures = { name = "JetBrainsMonoNL Nerd Font"; mono = "JetBrainsMonoNL Nerd Font Mono"; };
        };
        monaspace = builtins.mapAttrs (_: v: v // { pkg = "monaspace"; }) {
          neon    = { name = "MonaspiceNe Nerd Font"; mono = "MonaspiceNe Nerd Font Mono"; };
          argon   = { name = "MonaspiceAr Nerd Font"; mono = "MonaspiceAr Nerd Font Mono"; };
          xenon   = { name = "MonaspiceXe Nerd Font"; mono = "MonaspiceXe Nerd Font Mono"; };
          krypton = { name = "MonaspiceKr Nerd Font"; mono = "MonaspiceKr Nerd Font Mono"; };
          radon   = { name = "MonaspiceRn Nerd Font"; mono = "MonaspiceRn Nerd Font Mono"; };
        };
        mononoki = { name = "mononoki Nerd Font";    mono = "mononoki Nerd Font Mono";    pkg = "mononoki"; };
        noto     = { name = "NotoSansMono Nerd Font"; mono = "NotoSansMono Nerd Font Mono"; pkg = "noto"; };
      };
      font = fonts.monaspace.neon;
      direnvOverlay = final: prev: {
        direnv = prev.direnv.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace GNUmakefile --replace-fail "-linkmode=external" ""
          '';
        });
      };
      sharedModules = [
        { nixpkgs.overlays = [ direnvOverlay ]; }
        ./modules/common.nix
        ./modules/packages.nix
        ./modules/homebrew.nix
        home-manager.darwinModules.home-manager
        ./modules/home.nix
      ];
    in
    {
      darwinConfigurations."Wills-MacBook-Air" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self font; };
        modules = sharedModules ++ [ ./hosts/macbook-air.nix ];
      };

      darwinConfigurations."Wills-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self font; };
        modules = sharedModules ++ [ ./hosts/macbook-pro.nix ];
      };
    };
}
