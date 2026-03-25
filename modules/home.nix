{
  config,
  lib,
  user,
  ...
}:
let
  username = config.system.primaryUser;
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = { inherit user; };

  home-manager.users.${username} = {
    home.username = username;
    home.homeDirectory = lib.mkForce "/Users/${username}";
    home.stateVersion = "24.11";

    home.sessionVariables = {
      SSH_AUTH_SOCK = "/Users/${username}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
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
