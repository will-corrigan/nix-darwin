# Font catalog — maps user-friendly keys to Nix package names and font family strings.
# Stylix needs both the package (to install) and the exact family name (to configure apps).
# Keys are used in host TOML files: font = "fira-code"
#
# To add a font: find the nixpkgs attr with `nix eval nixpkgs#nerd-fonts --apply 'x: builtins.attrNames x'`
# then check the family name with `ghostty +list-fonts | grep -i <name>` after installing.
{
  "0xproto"                = { name = "0xProto Nerd Font";           mono = "0xProto Nerd Font Mono";           pkg = "_0xproto"; };
  "cascadia-code"          = { name = "CaskaydiaCove Nerd Font";    mono = "CaskaydiaCove Nerd Font Mono";    pkg = "caskaydia-cove"; };
  "cascadia-mono"          = { name = "CaskaydiaMono Nerd Font";    mono = "CaskaydiaMono Nerd Font Mono";    pkg = "caskaydia-mono"; };
  "comic-shanns"           = { name = "ComicShannsMono Nerd Font";  mono = "ComicShannsMono Nerd Font Mono";  pkg = "comic-shanns-mono"; };
  "commit-mono"            = { name = "CommitMono Nerd Font";       mono = "CommitMono Nerd Font Mono";       pkg = "commit-mono"; };
  "cousine"                = { name = "Cousine Nerd Font";           mono = "Cousine Nerd Font Mono";           pkg = "cousine"; };
  "droid-sans-mono"        = { name = "DroidSansM Nerd Font";       mono = "DroidSansM Nerd Font Mono";       pkg = "droid-sans-mono"; };
  "fira-code"              = { name = "FiraCode Nerd Font";         mono = "FiraCode Nerd Font Mono";         pkg = "fira-code"; };
  "geist-mono"             = { name = "GeistMono Nerd Font";        mono = "GeistMono Nerd Font Mono";        pkg = "geist-mono"; };
  "hack"                   = { name = "Hack Nerd Font";             mono = "Hack Nerd Font Mono";             pkg = "hack"; };
  "ibm-plex-mono"          = { name = "BlexMono Nerd Font";         mono = "BlexMono Nerd Font Mono";         pkg = "blex-mono"; };
  "inconsolata"            = { name = "Inconsolata Nerd Font";      mono = "Inconsolata Nerd Font Mono";      pkg = "inconsolata"; };
  "iosevka"                = { name = "Iosevka Nerd Font";           mono = "Iosevka Nerd Font Mono";           pkg = "iosevka"; };
  "iosevka-term"           = { name = "IosevkaTerm Nerd Font";      mono = "IosevkaTerm Nerd Font Mono";      pkg = "iosevka-term"; };
  "jetbrains-mono"         = { name = "JetBrainsMono Nerd Font";   mono = "JetBrainsMono Nerd Font Mono";   pkg = "jetbrains-mono"; };
  "jetbrains-mono-no-liga" = { name = "JetBrainsMonoNL Nerd Font"; mono = "JetBrainsMonoNL Nerd Font Mono"; pkg = "jetbrains-mono"; };
  "lilex"                  = { name = "Lilex Nerd Font";             mono = "Lilex Nerd Font Mono";             pkg = "lilex"; };
  "meslo"                  = { name = "MesloLGS Nerd Font";         mono = "MesloLGS Nerd Font Mono";         pkg = "meslo-lg"; };
  "monaspace-argon"        = { name = "MonaspiceAr Nerd Font";     mono = "MonaspiceAr Nerd Font Mono";     pkg = "monaspace"; };
  "monaspace-krypton"      = { name = "MonaspiceKr Nerd Font";     mono = "MonaspiceKr Nerd Font Mono";     pkg = "monaspace"; };
  "monaspace-neon"         = { name = "MonaspiceNe Nerd Font";     mono = "MonaspiceNe Nerd Font Mono";     pkg = "monaspace"; };
  "monaspace-radon"        = { name = "MonaspiceRn Nerd Font";     mono = "MonaspiceRn Nerd Font Mono";     pkg = "monaspace"; };
  "monaspace-xenon"        = { name = "MonaspiceXe Nerd Font";     mono = "MonaspiceXe Nerd Font Mono";     pkg = "monaspace"; };
  "mononoki"               = { name = "mononoki Nerd Font";        mono = "mononoki Nerd Font Mono";        pkg = "mononoki"; };
  "noto"                   = { name = "NotoSansMono Nerd Font";    mono = "NotoSansMono Nerd Font Mono";    pkg = "noto"; };
  "roboto-mono"            = { name = "RobotoMono Nerd Font";       mono = "RobotoMono Nerd Font Mono";       pkg = "roboto-mono"; };
  "source-code-pro"        = { name = "SauceCodePro Nerd Font";     mono = "SauceCodePro Nerd Font Mono";     pkg = "sauce-code-pro"; };
  "ubuntu-mono"            = { name = "UbuntuMono Nerd Font";       mono = "UbuntuMono Nerd Font Mono";       pkg = "ubuntu-mono"; };
  "victor-mono"            = { name = "VictorMono Nerd Font";       mono = "VictorMono Nerd Font Mono";       pkg = "victor-mono"; };
  "zed-mono"               = { name = "ZedMono Nerd Font";           mono = "ZedMono Nerd Font Mono";           pkg = "zed-mono"; };
}
