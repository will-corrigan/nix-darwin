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
      lib = nixpkgs.lib;
      fontMap = import ./fonts.nix;

      direnvOverlay = final: prev: {
        direnv = prev.direnv.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace GNUmakefile --replace-fail "-linkmode=external" ""
          '';
        });
      };

      darwinModules = [
        { nixpkgs.overlays = [ direnvOverlay ]; }
        stylix.darwinModules.stylix
        ./modules/shared.nix
        ./modules/darwin.nix
        ./modules/packages.nix
        ./modules/homebrew.nix
        home-manager.darwinModules.home-manager
        ./modules/home.nix
      ];

      platformMap = {
        "apple-silicon" = "aarch64-darwin";
        "intel" = "x86_64-darwin";
      };

      mkDarwin = host:
        let
          appearance = host.appearance or {};
          fontKey = appearance.font or "monaspace-neon";
          font = fontMap.${fontKey} or fontMap."monaspace-neon";
          themeName = appearance.theme or "catppuccin-mocha";
        in
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit self host font themeName;
          };
          modules = darwinModules ++ [
            {
              nixpkgs.hostPlatform = platformMap.${host.machine.type} or "aarch64-darwin";
              system.primaryUser = host.machine.username;
              system.stateVersion = 6;
              system.configurationRevision = self.rev or self.dirtyRev or null;
            }
          ];
        };

      # Auto-discover all .toml host files
      hostDir = builtins.readDir ./hosts;
      tomlFiles = lib.filterAttrs (name: type:
        type == "regular" && lib.hasSuffix ".toml" name
      ) hostDir;

      hosts = lib.mapAttrs' (filename: _:
        let
          host = builtins.fromTOML (builtins.readFile (./hosts + "/${filename}"));
          name = (host.machine or (builtins.throw "${filename}: missing [machine] table")).computer_name
            or (builtins.throw "${filename}: missing machine.computer_name");
        in
        lib.nameValuePair name (mkDarwin host)
      ) tomlFiles;
    in
    {
      darwinConfigurations = hosts;
    };
}
