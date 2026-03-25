{ ... }:
{
  programs.mise = {
    enable = true;
    package = null;
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
