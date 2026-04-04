{
  description = "Declarative macOS and NixOS with nix-darwin, home-manager, and Stylix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:nix-community/stylix";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      nixos-wsl,
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

      platformMap = {
        "apple-silicon" = "aarch64-darwin";
        "intel" = "x86_64-darwin";
        "wsl" = "x86_64-linux";
        "linux" = "x86_64-linux";
      };

      darwinTypes = [ "apple-silicon" "intel" ];
      isDarwinType = type: builtins.elem type darwinTypes;

      platformForType = type:
        if type == "apple-silicon" || type == "intel" then "darwin"
        else if type == "wsl" then "wsl"
        else "linux";

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
            platform = "darwin";
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

      mkNixOS = host:
        let
          appearance = host.appearance or {};
          fontKey = appearance.font or "monaspace-neon";
          font = fontMap.${fontKey} or fontMap."monaspace-neon";
          themeName = appearance.theme or "catppuccin-mocha";
          platform = platformForType (host.machine.type or "linux");
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit self host font themeName nixos-wsl platform;
          };
          modules = [
            stylix.nixosModules.stylix
            ./modules/shared.nix
            ./modules/nixos.nix
            ./modules/packages.nix
            home-manager.nixosModules.home-manager
            ./modules/home.nix
            {
              nixpkgs.hostPlatform = platformMap.${host.machine.type} or "x86_64-linux";
            }
          ];
        };

      # Auto-discover all .toml host files
      hostDir = builtins.readDir ./hosts;
      tomlFiles = lib.filterAttrs (name: type:
        type == "regular" && lib.hasSuffix ".toml" name
      ) hostDir;

      allHosts = lib.mapAttrs' (filename: _:
        let
          host = builtins.fromTOML (builtins.readFile (./hosts + "/${filename}"));
          name = (host.machine or (builtins.throw "${filename}: missing [machine] table")).computer_name
            or (builtins.throw "${filename}: missing machine.computer_name");
          type = host.machine.type or (builtins.throw "${filename}: missing machine.type");
        in
        lib.nameValuePair name { inherit host type; }
      ) tomlFiles;

      darwinHosts = lib.filterAttrs (_: v: isDarwinType v.type) allHosts;
      nixosHosts = lib.filterAttrs (_: v: !(isDarwinType v.type)) allHosts;
    in
    {
      darwinConfigurations = lib.mapAttrs (_: v: mkDarwin v.host) darwinHosts;
      nixosConfigurations = lib.mapAttrs (_: v: mkNixOS v.host) nixosHosts;
    };
}
