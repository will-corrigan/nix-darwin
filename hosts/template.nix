# Copy this file to create a new host configuration.
# Required fields are marked — optional fields can be removed.
#
# Then add to flake.nix:
#   darwinConfigurations."Your-Hostname" = mkDarwin ./hosts/your-host.nix;
#
# Available fonts (see fonts.nix for full list):
#   fonts.monaspace.neon        (default)
#   fonts.monaspace.argon / xenon / krypton / radon
#   fonts.jetbrains-mono.default / no-ligatures
#   fonts.mononoki
#   fonts.noto
#
# Available themes (any base16 scheme name):
#   "catppuccin-mocha"          (default)
#   "catppuccin-latte" / "catppuccin-frappe" / "catppuccin-macchiato"
#   "dracula" / "gruvbox-dark-hard" / "nord" / "tokyo-night-dark"
#   Run: ls $(nix build nixpkgs#base16-schemes --no-link --print-out-paths)/share/themes/

{ fonts }:
{
  # ── Required ──────────────────────────────────────────────────────
  hostname    = "Your-Hostname";          # must match: scutil --get LocalHostName
  platform    = "aarch64-darwin";         # aarch64-darwin (Apple Silicon) or x86_64-darwin (Intel)
  primaryUser = "username";               # macOS login username

  user = {
    name   = "Your Name";                 # git commit author
    email  = "you@example.com";           # git commit email
    sshKey = "ssh-ed25519 AAAA...";       # public key for git signing (1Password)
  };

  # ── Optional (defaults shown) ─────────────────────────────────────
  # font      = fonts.monaspace.neon;
  # themeName = "catppuccin-mocha";
}
