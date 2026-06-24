{ lib, host, ... }:
let
  extraPkgs = host.extra_packages or {};
  extraBrews = extraPkgs.brews or [];
  extraCasks = map (c:
    if c == "discord"
    then { name = "discord"; args.appdir = "/Users/will/Applications"; }
    else c
  ) (extraPkgs.casks or []);

  integrations = host.integrations or {};
  signing = integrations.ssh_signing or null;

  # Base casks needed by integrations
  integrationCasks =
    lib.optionals (signing == "1password") [ "1password" ];
in
{
  homebrew = {
    enable = true;
    enableZshIntegration = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = false;
    onActivation.cleanup = "uninstall";
    prefix = "/opt/workbrew";

    brews = extraBrews;
    casks = integrationCasks ++ extraCasks;
  };
}
