{
  jetbrains-mono = builtins.mapAttrs (_: v: v // { pkg = "jetbrains-mono"; }) {
    default      = { name = "JetBrainsMono Nerd Font";   mono = "JetBrainsMono Nerd Font Mono"; };
    no-ligatures = { name = "JetBrainsMonoNL Nerd Font"; mono = "JetBrainsMonoNL Nerd Font Mono"; };
  };
  monaspace = builtins.mapAttrs (_: v: v // { pkg = "monaspace"; }) {
    neon    = { name = "MonaspiceNe Nerd Font"; mono = "MonaspiceNe Nerd Font Mono"; };
    argon   = { name = "MonaspiceAr Nerd Font"; mono = "MonaspiceAr Nerd Font Mono"; };
    xenon   = { name = "MonaspiceXe Nerd Font"; mono = "MonaspiceXe Nerd Font Mono"; };
    krypton = { name = "MonaspiceKr Nerd Font"; mono = "MonaspiceKr Nerd Font Mono"; };
    radon   = { name = "MonaspiceRn Nerd Font"; mono = "MonaspiceRn Nerd Font Mono"; };
  };
  mononoki = { name = "mononoki Nerd Font";    mono = "mononoki Nerd Font Mono";    pkg = "mononoki"; };
  noto     = { name = "NotoSansMono Nerd Font"; mono = "NotoSansMono Nerd Font Mono"; pkg = "noto"; };
}
