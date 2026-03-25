{ lib, host, ... }:
let
  extraPkgs = host.extra_packages or {};
  extraBrews = extraPkgs.brews or [];
  extraCasks = extraPkgs.casks or [];

  integrations = host.integrations or {};
  signing = integrations.ssh_signing or null;

  # Base brews/casks needed by integrations
  integrationCasks =
    lib.optionals (signing == "1password") [ "1password" ];
  integrationBrews =
    lib.optionals (signing == "1password") [];
in
{
  homebrew = {
    enable = true;
    enableZshIntegration = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "uninstall";

    brews = integrationBrews ++ extraBrews;
    casks = integrationCasks ++ extraCasks;
  };
}
