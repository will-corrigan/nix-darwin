{
  config,
  lib,
  pkgs,
  font,
  ...
}:
let
  user = config.system.primaryUser;
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = { inherit font; };

  home-manager.users.${user} = {
    home.username = user;
    home.homeDirectory = lib.mkForce "/Users/${user}";
    home.stateVersion = "24.11";

    home.sessionVariables = {
      SSH_AUTH_SOCK = "/Users/${user}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    };

    imports = [
      ../dotfiles/zsh.nix
      ../dotfiles/starship.nix
      ../dotfiles/fzf.nix
      ../dotfiles/bat.nix
      ../dotfiles/btop.nix
      ../dotfiles/ghostty.nix
      ../dotfiles/zed.nix
      ../dotfiles/tmux.nix
      ../dotfiles/git.nix
      ../dotfiles/direnv.nix
      ../dotfiles/zoxide.nix
      ../dotfiles/mise.nix
    ];
  };
}
