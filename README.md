# nix-darwin

Declarative macOS configuration using [nix-darwin](https://github.com/nix-darwin/nix-darwin), [home-manager](https://github.com/nix-community/home-manager), [Stylix](https://github.com/nix-community/stylix), and [Nix flakes](https://nix.dev/concepts/flakes).

Fork this repo, create your host file, rebuild. Everything else is shared.

## Prerequisites

- macOS (Apple Silicon or Intel)
- [Nix](https://nixos.org/download/) with flakes enabled
- [nix-darwin](https://github.com/nix-darwin/nix-darwin) bootstrapped
- [Homebrew](https://brew.sh/) installed (nix-darwin manages it declaratively after initial install)
- [1Password](https://1password.com/) for SSH key signing

## Quick Start

```bash
# 1. Clone
sudo git clone <repo-url> /etc/nix-darwin
cd /etc/nix-darwin

# 2. Create your host (copy the template)
cp hosts/template.nix hosts/my-mac.nix
# Edit hosts/my-mac.nix with your details

# 3. Add your host to flake.nix
#    darwinConfigurations."My-Hostname" = mkDarwin ./hosts/my-mac.nix;

# 4. Build
sudo nix flake update --flake /etc/nix-darwin && nh darwin switch /etc/nix-darwin
```

After the first build, the `rebuild` alias handles steps 3-4:

```bash
rebuild
```

## Repo Structure

```
.
├── flake.nix               # Entry point: inputs, mkDarwin helper, host list
├── flake.lock              # Pinned dependency versions
├── fonts.nix               # Font catalog (pure data)
├── wallpaper.avif          # Wallpaper (required by Stylix)
├── modules/
│   ├── common.nix          # System: nix, Stylix, keyboard, macOS defaults
│   ├── packages.nix        # CLI tools (nixpkgs)
│   ├── homebrew.nix        # GUI apps + pre-built tools (Homebrew)
│   └── home.nix            # Home-manager: imports all dotfiles
├── hosts/
│   ├── template.nix        # Copy this to create a new host
│   ├── macbook-air.nix     # Example host
│   └── macbook-pro.nix     # Example host
└── dotfiles/               # One file per program (home-manager modules)
    ├── zsh.nix             # Shell: aliases, syntax highlighting
    ├── starship.nix        # Prompt: Nerd Font icons, git/cloud/lang modules
    ├── fzf.nix             # Fuzzy finder: fd integration, bat preview
    ├── git.nix             # Git + GitHub CLI + SSH (1Password signing)
    ├── bat.nix             # File viewer
    ├── btop.nix            # System monitor, vim keys
    ├── tmux.nix            # Multiplexer: C-a prefix, vim nav
    ├── ghostty.nix         # Terminal: opacity, splits
    ├── zed.nix             # Editor: vim mode, LSP, format-on-save
    ├── direnv.nix          # Per-project environments (nix-direnv)
    ├── zoxide.nix          # Smart cd
    └── mise.nix            # Version manager config
```

## Architecture

```
hosts/my-mac.nix        (per-machine: user, platform, font, theme)
  │
flake.nix
  ├── imports fonts.nix   (font catalog)
  ├── mkDarwin            (reads host file, wires everything up)
  │
  ├── modules/            (system-level: shared across all hosts)
  │   ├── common.nix        Stylix (theme + fonts), nix settings, macOS defaults
  │   ├── packages.nix      CLI tools
  │   └── homebrew.nix      GUI apps
  │
  └── home.nix            (user-level: imports all dotfiles)
      └── dotfiles/        (program-level: behavior only, no theme/font code)
```

### How it flows

1. Host file defines: who you are, what machine, optional font/theme
2. `mkDarwin` reads the host file and passes `user`, `font`, `themeName` via `specialArgs`
3. `common.nix` configures Stylix with the font and theme — Stylix auto-themes all apps
4. `home.nix` passes `user` to dotfiles (only `git.nix` needs it)
5. Dotfiles contain only **behavior** config (keybinds, aliases, LSP settings) — no colors or fonts

### Module loading order

1. Overlays (direnv patch)
2. Stylix
3. `common.nix` (system settings, Stylix config, macOS defaults)
4. `packages.nix` (nixpkgs CLI tools)
5. `homebrew.nix` (GUI apps)
6. home-manager
7. `home.nix` (imports all dotfiles)
8. Host-specific config (platform, username)

## Adding a New Host

1. Copy the template:

```bash
cp hosts/template.nix hosts/my-mac.nix
```

2. Edit `hosts/my-mac.nix`:

```nix
{ fonts }:
{
  # ── Required ──────────────────────────────────────────────────────
  hostname    = "My-Hostname";          # scutil --get LocalHostName
  platform    = "aarch64-darwin";       # or x86_64-darwin
  primaryUser = "username";             # macOS login username

  user = {
    name   = "Your Name";              # git commit author
    email  = "you@example.com";        # git commit email
    sshKey = "ssh-ed25519 AAAA...";    # public key (1Password)
  };

  # ── Optional (uncomment to override defaults) ─────────────────────
  # font      = fonts.mononoki;
  # themeName = "dracula";
}
```

3. Add one line to `flake.nix`:

```nix
darwinConfigurations."My-Hostname" = mkDarwin ./hosts/my-mac.nix;
```

4. Rebuild:

```bash
sudo nix flake update --flake /etc/nix-darwin && nh darwin switch /etc/nix-darwin
```

## Theming (Stylix)

[Stylix](https://github.com/nix-community/stylix) handles all theming automatically. Set a [base16 scheme](https://github.com/tinted-theming/schemes) name in your host file and every app gets themed:

```nix
themeName = "catppuccin-mocha";   # default
```

To see all available themes:

```bash
ls $(nix build nixpkgs#base16-schemes --no-link --print-out-paths)/share/themes/
```

Popular options: `catppuccin-mocha`, `catppuccin-latte`, `dracula`, `gruvbox-dark-hard`, `nord`, `tokyo-night-dark`, `solarized-dark`.

Stylix themes these apps automatically: bat, btop, fzf, ghostty, starship, tmux, zed.

### Per-app override

To disable Stylix for a specific app and theme it manually:

```nix
# In the relevant dotfiles/*.nix
stylix.targets.ghostty.enable = false;
```

## Font System

Fonts are defined in `fonts.nix` as a catalog. Each entry has:

| Field  | Used by              | Example                          |
|--------|----------------------|----------------------------------|
| `name` | Editors              | `MonaspiceNe Nerd Font`          |
| `mono` | Terminals            | `MonaspiceNe Nerd Font Mono`     |
| `pkg`  | Nix package install  | `monaspace`                      |

### Available fonts

```nix
fonts.monaspace.neon               # Monaspace Neon (default)
fonts.monaspace.argon / xenon / krypton / radon
fonts.jetbrains-mono.default       # JetBrains Mono
fonts.jetbrains-mono.no-ligatures  # JetBrains Mono (no ligatures)
fonts.mononoki                     # Mononoki
fonts.noto                         # Noto Sans Mono
```

Override in your host file:

```nix
font = fonts.jetbrains-mono.default;
```

### Adding a new font

```bash
# Find the nix package name
nix eval nixpkgs#nerd-fonts --apply 'x: builtins.attrNames x'

# Check the registered font family name
ghostty +list-fonts | grep -i <name>
```

Add to `fonts.nix`:

```nix
my-font = { name = "MyFont Nerd Font"; mono = "MyFont Nerd Font Mono"; pkg = "my-font"; };
```

## Adding a New Program

1. Create `dotfiles/myapp.nix`:

```nix
{ ... }:
{
  programs.myapp = {
    enable = true;
    # config here — behavior only, Stylix handles theme/font
  };
}
```

2. Add to imports in `modules/home.nix`:

```nix
imports = [
  # ...existing...
  ../dotfiles/myapp.nix
];
```

If the app is installed via Homebrew, set `package = null`.

## Package Management

| Where | What goes here | Examples |
|-------|---------------|----------|
| `packages.nix` | CLI tools from nixpkgs | ripgrep, fd, jq, kubectl |
| `homebrew.nix` brews | Slow-to-build CLI tools | awscli, mise |
| `homebrew.nix` casks | GUI apps | Ghostty, Chrome, Slack, Zed |
| `dotfiles/*.nix` | Tools with rich config | starship, tmux, bat |

**Rule of thumb:** GUI or slow-to-build goes to Homebrew. Config-heavy tools get a home-manager module in dotfiles/. Everything else goes to nixpkgs.

## Key Bindings

### Tmux (prefix: `C-a`)

| Binding | Action |
|---------|--------|
| `\` | Split right |
| `_` | Split down |
| `h/j/k/l` | Navigate panes |
| `H/J/K/L` | Resize panes |
| `n/p` | Next/previous window |
| `S` | Choose session |

### Zed (vim mode)

| Binding | Action |
|---------|--------|
| `ctrl-h/j/k/l` | Navigate panes |
| `shift-h/l` | Previous/next tab |
| `space v` | Split right |
| `space s` | Split down |

### Ghostty

| Binding | Action |
|---------|--------|
| `cmd+shift+enter` | Split right |
| `cmd+shift+-` | Split down |
| `cmd+opt+arrows` | Navigate splits |

## Useful Commands

```bash
rebuild                              # Rebuild (alias)
ghostty +list-fonts | grep -i <name> # Check font availability
nix-collect-garbage --delete-older-than 7d  # Manual GC (runs weekly automatically)
statix check .                       # Lint nix files
deadnix .                            # Find unused code
nixfmt .                             # Format nix files
```
