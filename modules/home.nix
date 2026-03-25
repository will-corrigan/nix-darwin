{
  config,
  lib,
  host,
  ...
}:
let
  username = host.machine.username;
  programs = host.programs or {};
  integrations = host.integrations or {};

  # Map program name + level to the correct dotfile path
  programImport = name: level:
    if level == "curated"
    then ../dotfiles/curated/${name}.nix
    else ../dotfiles/minimal/${name}.nix;

  enabledImports = lib.mapAttrsToList programImport programs;

  # Only set 1Password SSH agent if integration is configured
  sessionVars =
    if (integrations.ssh_signing or null) == "1password"
    then {
      SSH_AUTH_SOCK = "/Users/${username}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    }
    else {};
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = { inherit host; };

  home-manager.users.${username} = {
    home.username = username;
    home.homeDirectory = lib.mkForce "/Users/${username}";
    home.stateVersion = "24.11";
    home.sessionVariables = sessionVars;

    imports = enabledImports;
  };
}
