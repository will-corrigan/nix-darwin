{ platform ? "darwin", ... }:
let
  rebuildCmd =
    if platform == "darwin"
    then "sudo nix flake update --flake /etc/nix-darwin && nh darwin switch /etc/nix-darwin"
    else "sudo nix flake update --flake /etc/nixos && nh os switch /etc/nixos";
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      rebuild = rebuildCmd;

      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";

      ls = "eza";
      la = "eza -la --icons";
      ll = "eza -la --icons --git";
      lt = "eza -T -L 2 --icons";

      gst = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gco = "git checkout";
      gb = "git branch";
      gd = "git diff";
      glog = "git log --oneline --graph --decorate";

      kube-stg = "aws login && aws eks update-kubeconfig --name contextfab-stg-infra-eks-cluster --region eu-west-1 --alias stg";
    };
    initContent = ''
      export PATH="$HOME/.rd/bin:$PATH"
      eval "$(mise activate zsh)"
    '';
  };
}
