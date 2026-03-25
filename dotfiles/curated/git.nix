{ host, ... }:
let
  integrations = host.integrations or {};
  signing = integrations.ssh_signing or null;
in
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
  } // (if signing == "1password" then {
    signing = {
      key = host.user.ssh_key or "";
      signByDefault = true;
      format = "ssh";
      signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };
  } else if signing == "gpg" then {
    signing = {
      signByDefault = true;
      format = "openpgp";
    };
  } else {});

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
      };
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
  } // (if signing == "1password" then {
    matchBlocks."*" = {
      extraOptions.IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
    };
  } else {});
}
