# nix-darwin

Declarative macOS configuration using [nix-darwin](https://github.com/nix-darwin/nix-darwin), [home-manager](https://github.com/nix-community/home-manager), [Stylix](https://github.com/nix-community/stylix), and [Nix flakes](https://nix.dev/concepts/flakes).

Fork this repo, create a TOML host file, rebuild. Everything else is shared.

## Prerequisites

- macOS (Apple Silicon or Intel)
- [Nix](https://nixos.org/download/) with flakes enabled
- [nix-darwin](https://github.com/nix-darwin/nix-darwin) bootstrapped
- [Homebrew](https://brew.sh/) installed (nix-darwin manages it declaratively after initial install)
- [1Password](https://1password.com/) for SSH key signing (optional)

## Quick Start

```bash
# 1. Clone
sudo git clone <repo-url> /etc/nix-darwin
cd /etc/nix-darwin

# 2. Create your host file
cp hosts/wills-macbook-air.toml hosts/my-mac.toml
# Edit hosts/my-mac.toml with your details

# 3. First build (uses darwin-rebuild directly — nh isn't installed yet)
sudo nix flake update --flake /etc/nix-darwin && darwin-rebuild switch --flake /etc/nix-darwin
```

After the first build, `nh` and the `rebuild` alias are available:

```bash
rebuild
```

A setup TUI (M2) is planned to automate host file creation.

## Repo Structure

```
.
├── flake.nix               # Entry point: auto-discovers hosts/*.toml
├── flake.lock
├── fonts.nix               # Font catalog (flat keys)
├── schema.json             # JSON Schema for host TOML validation
├── wallpapers/             # Wallpaper collection
│   └── default.avif
├── modules/
│   ├── common.nix          # Nix, Stylix, keyboard, macOS defaults (host-driven)
│   ├── packages.nix        # CLI tools (base + host extras)
│   ├── homebrew.nix        # GUI apps + tools (integration deps + host extras)
│   └── home.nix            # Home-manager: conditional dotfile imports
├── hosts/
│   └── *.toml              # One per machine (auto-discovered)
└── dotfiles/
    ├── curated/            # Opinionated configs (behavior + keybinds + LSP)
    │   ├── zsh.nix, starship.nix, fzf.nix, bat.nix, btop.nix
    │   ├── ghostty.nix, zed.nix, tmux.nix, git.nix
    │   └── direnv.nix, zoxide.nix, mise.nix
    └── minimal/            # Bare enablement (just programs.X.enable = true)
        └── (same files)
```

## Architecture

```
hosts/my-mac.toml           (per-machine: user, platform, font, theme, programs)
  │
  └── builtins.fromTOML
        │
flake.nix: mkDarwin
  ├── fonts.nix             (font catalog — flat string keys)
  ├── modules/              (system-level: shared across all hosts)
  │   ├── common.nix          Stylix (theme + fonts), nix settings, macOS defaults
  │   ├── packages.nix        CLI tools + host extra_packages.cli
  │   └── homebrew.nix        GUI apps + host extra_packages.brews/casks
  │
  └── home.nix              (user-level: conditionally imports dotfiles)
      └── dotfiles/{curated,minimal}/   (selected per-program from host TOML)
```

### How it flows

1. `flake.nix` reads all `hosts/*.toml` via `builtins.readDir` + `builtins.fromTOML` (auto-discovery, no manual registration).
2. `mkDarwin` resolves the font key and theme name, then passes `host`, `font`, and `themeName` via `specialArgs`.
3. `common.nix` configures Stylix with the font and theme — Stylix auto-themes all apps.
4. `home.nix` reads `host.programs` and imports `dotfiles/curated/<prog>.nix` or `dotfiles/minimal/<prog>.nix` for each enabled program.
5. Dotfiles contain only **behavior** config (keybinds, aliases, LSP settings) — no colors or fonts.

## Host File Format

```toml
#:schema ../schema.json

[machine]
computer_name = "My-MacBook"    # must match: scutil --get LocalHostName
type          = "apple-silicon" # or "intel"
username      = "myuser"        # macOS login username

[user]
name    = "Your Name"           # git commit author
email   = "you@example.com"     # git commit email
ssh_key = "ssh-ed25519 AAAA..." # public key (optional, for git signing)

[appearance]
font      = "monaspace-neon"    # see Font System below
theme     = "catppuccin-mocha"  # base16 scheme name
wallpaper = "default"           # name from wallpapers/ dir, or "custom"

[programs]
# Each program: "curated" (opinionated config) or "minimal" (bare enable)
# Omit a program entirely to skip installation.
zsh      = "curated"
starship = "curated"
fzf      = "curated"
bat      = "curated"
btop     = "curated"
ghostty  = "curated"
zed      = "curated"
tmux     = "curated"
git      = "curated"
direnv   = "curated"
zoxide   = "curated"
mise     = "curated"

[integrations]
ssh_signing = "1password"  # or "gpg", omit to disable signing

[extra_packages]
cli   = ["ripgrep", "fd", "jq"]          # nixpkgs CLI tools
brews = ["awscli"]                        # Homebrew formulae
casks = ["google-chrome", "slack"]        # Homebrew casks (GUI apps)

[macos.keyboard]
caps_lock    = "escape"  # or "caps-lock"
key_repeat   = "fast"    # slow / medium / fast
repeat_delay = "short"   # long / medium / short

[macos.dock]
position        = "bottom"  # left / bottom / right
icon_size       = "medium"  # small / medium / large
auto_hide       = true
minimize_to_app = true

[macos.finder]
default_view    = "list"  # list / columns / icons / gallery
show_extensions = true
show_path_bar   = false
show_hidden     = true

[macos.trackpad]
tap_to_click   = true
natural_scroll = false
```

### curated vs minimal

| Value | What you get |
|-------|-------------|
| `"curated"` | Opinionated config: keybinds, aliases, LSP settings, integrations |
| `"minimal"` | Just `programs.X.enable = true` — works, no opinions |

## Adding a New Host

1. Create a TOML file in `hosts/`:

```bash
cp hosts/wills-macbook-air.toml hosts/my-mac.toml
```

2. Edit the file with your machine details (see Host File Format above).

3. Rebuild — the new host is auto-discovered:

```bash
rebuild
```

No changes to `flake.nix` required.

## Theming (Stylix)

[Stylix](https://github.com/nix-community/stylix) handles all theming automatically. Set a [base16 scheme](https://github.com/tinted-theming/schemes) name in your host file:

```toml
[appearance]
theme = "catppuccin-mocha"   # default
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
# In the relevant dotfiles/curated/*.nix
stylix.targets.ghostty.enable = false;
```

## Font System

Fonts are defined in `fonts.nix` as flat string keys. Each entry has:

| Field  | Used by             | Example                          |
|--------|---------------------|----------------------------------|
| `name` | Editors             | `MonaspiceNe Nerd Font`          |
| `mono` | Terminals           | `MonaspiceNe Nerd Font Mono`     |
| `pkg`  | Nix package install | `monaspace`                      |

### Available fonts (30)

| Key | Font |
|-----|------|
| `0xproto` | 0xProto |
| `cascadia-code` | Cascadia Code |
| `cascadia-mono` | Cascadia Mono |
| `comic-shanns` | Comic Shanns Mono |
| `commit-mono` | Commit Mono |
| `cousine` | Cousine |
| `droid-sans-mono` | Droid Sans Mono |
| `fira-code` | Fira Code |
| `geist-mono` | Geist Mono |
| `hack` | Hack |
| `ibm-plex-mono` | IBM Plex Mono |
| `inconsolata` | Inconsolata |
| `iosevka` | Iosevka |
| `iosevka-term` | Iosevka Term |
| `jetbrains-mono` | JetBrains Mono |
| `jetbrains-mono-no-liga` | JetBrains Mono (no ligatures) |
| `lilex` | Lilex |
| `meslo` | Meslo LG S |
| `monaspace-neon` | Monaspace Neon (default) |
| `monaspace-argon` | Monaspace Argon |
| `monaspace-xenon` | Monaspace Xenon |
| `monaspace-krypton` | Monaspace Krypton |
| `monaspace-radon` | Monaspace Radon |
| `mononoki` | Mononoki |
| `noto` | Noto Sans Mono |
| `roboto-mono` | Roboto Mono |
| `source-code-pro` | Source Code Pro |
| `ubuntu-mono` | Ubuntu Mono |
| `victor-mono` | Victor Mono |
| `zed-mono` | Zed Mono |

Set the key in your host file:

```toml
[appearance]
font = "jetbrains-mono"
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
"my-font" = { name = "MyFont Nerd Font"; mono = "MyFont Nerd Font Mono"; pkg = "my-font"; };
```

Then use `"my-font"` as the `font` key in any host TOML.

## Adding a New Program

1. Create `dotfiles/curated/myapp.nix` (opinionated config):

```nix
{ ... }:
{
  programs.myapp = {
    enable = true;
    # behavior config here — Stylix handles theme/font
  };
}
```

2. Create `dotfiles/minimal/myapp.nix` (bare enablement):

```nix
{ ... }:
{
  programs.myapp.enable = true;
}
```

3. Add `myapp` to the `programs` enum in `schema.json`:

```json
"myapp": { "type": "string", "enum": ["curated", "minimal"], "description": "..." }
```

4. `home.nix` will now pick up `programs.myapp = "curated"` or `"minimal"` from host TOML files automatically.

If the app is installed via Homebrew, set `package = null` in the dotfile.

## Package Management

| Where | What goes here | Examples |
|-------|----------------|----------|
| `[programs]` (host TOML) | Config-managed tools with curated/minimal dotfiles | zsh, git, tmux, ghostty, zed |
| `extra_packages.cli` (host TOML) | Per-host CLI tools from nixpkgs | ripgrep, fd, jq, kubectl |
| `extra_packages.brews` (host TOML) | Per-host Homebrew formulae | awscli, mise |
| `extra_packages.casks` (host TOML) | Per-host GUI apps | Chrome, Slack, Zed, Discord |

All packages are per-host via your TOML file. The only shared base package is `nh` (the rebuild helper).

**Rule of thumb:** If a tool has rich config, add it as a program with a dotfile. GUI or slow-to-build goes to Homebrew casks. Everything else goes to `extra_packages.cli` (nixpkgs).

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
rebuild                                     # Rebuild (alias)
ghostty +list-fonts | grep -i <name>        # Check font availability
nix-collect-garbage --delete-older-than 7d  # Manual GC (runs weekly automatically)
statix check .                              # Lint nix files
deadnix .                                   # Find unused code
nixfmt .                                    # Format nix files
```
