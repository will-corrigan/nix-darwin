{ host, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = host.user.name;
      user.email = host.user.email;
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
    };
  };
}
