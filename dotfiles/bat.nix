{ ... }:
{
  programs.bat = {
    enable = true;
    config = {
      style = "numbers,changes,header,grid";
      italic-text = "always";
      pager = "less -FR";
    };
  };
}
