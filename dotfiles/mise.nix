{ ... }:
{
  programs.mise = {
    enable = true;
    package = null;
    enableZshIntegration = false;
    globalConfig = {
      tools = {
        node = "lts";
      };
      settings = {
        experimental = true;
      };
    };
  };
}
