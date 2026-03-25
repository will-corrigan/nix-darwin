{ ... }:
{
  programs.mise = {
    enable = true;
    package = null;
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
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
