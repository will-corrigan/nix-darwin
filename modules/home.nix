{
  lib,
  host,
  platform ? "darwin",
  ...
}:
let
  username = host.machine.username;
  programs = host.programs or {};
  integrations = host.integrations or {};

  # Map program name + level to the correct dotfile path
  programImport = name: level:
    assert level == "curated" || level == "minimal"
      || builtins.throw "host.programs.${name}: invalid level '${level}' (must be 'curated' or 'minimal')";
    if level == "curated"
    then ../dotfiles/curated/${name}.nix
    else ../dotfiles/minimal/${name}.nix;

  enabledImports = lib.mapAttrsToList programImport programs;

  homeDir =
    if platform == "darwin"
    then "/Users/${username}"
    else "/home/${username}";

  # 1Password SSH agent socket varies by platform
  sessionVars =
    if (integrations.ssh_signing or null) == "1password" && platform == "darwin"
    then {
      SSH_AUTH_SOCK = "${homeDir}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    }
    # WSL: Windows handles SSH agent via interop, no socket needed
    # Linux: native 1Password agent would set this automatically
    else {};
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = { inherit host platform; };

  home-manager.users.${username} = {
    home.username = username;
    home.homeDirectory = lib.mkForce homeDir;
    home.stateVersion = "24.11";
    home.sessionVariables = sessionVars;

    imports = enabledImports;
  };
}
