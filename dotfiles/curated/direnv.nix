{ ... }:
{
  programs.direnv = {
    enable = false;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
