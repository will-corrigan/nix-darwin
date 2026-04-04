{ host, platform ? "darwin", ... }:
let
  integrations = host.integrations or {};
  signing = integrations.ssh_signing or null;
  winUser = host.machine.windows_username or "";

  signerPath =
    if platform == "darwin"
    then "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
    else if platform == "wsl"
    then "/mnt/c/Users/${winUser}/AppData/Local/1Password/app/8/op-ssh-sign.exe"
    else "op-ssh-sign";

  sshCommand =
    if platform == "wsl"
    then "ssh.exe"
    else "ssh";

  identityAgentPath =
    if platform == "darwin"
    then ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"''
    else null;  # WSL uses Windows interop, linux uses native 1Password agent
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
    } // (if platform == "wsl" then {
      core.sshCommand = sshCommand;
    } else {}) // (if signing == "1password" then {
      signing = {
        key = host.user.ssh_key or "";
        signByDefault = true;
        format = "ssh";
        signer = signerPath;
      };
    } else if signing == "gpg" then {
      signing = {
        signByDefault = true;
        format = "openpgp";
      };
    } else {});
  };

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
  } // (if signing == "1password" && identityAgentPath != null then {
    matchBlocks."*" = {
      extraOptions.IdentityAgent = identityAgentPath;
    };
  } else {});
}
