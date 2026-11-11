# nixfig

NixOS desktop with Niri, Noctalia, and Catppuccin Mocha.

## Included

- **Apps:** Firefox, Thunderbird, Ghostty, Thunar, Zed, Cursor, Discord, Spotify, ChatGPT, T3 Code, osu!lazer (x86_64 only).
- **Tools:** Docker, Go, Bun, Git, GitHub CLI, ripgrep, fd, package-version-server.
- **Web shortcuts:** GitHub and Linear, searchable in the launcher.

## Settings

- Catppuccin Mocha with a mauve accent, dark mode, JetBrains Mono Nerd Font.
- Firefox with uBlock Origin and Firefox Color; Ghostty at 12 pt without window decorations.
- NetworkManager, Bluetooth, PipeWire, and AppImage support enabled.
- Apps: `home/apps.nix`. Shell: `home/noctalia.nix`. Theme: `theme.nix`.
- Machine settings: `/etc/nixos/configuration.nix`. Home Manager is applied with the system rebuild.

## Create

On an installed NixOS system without an existing `/etc/nixos/flake.nix`:

```sh
nix-shell -p git
git clone https://github.com/natebabyak/nixfig.git ~/nixfig
cd ~/nixfig
sudo ./setup.sh "$(id -un)"
sudo nixos-rebuild build --flake path:/etc/nixos#default \
  --option experimental-features 'nix-command flakes'
sudo nixos-rebuild switch --flake path:/etc/nixos#default \
  --option experimental-features 'nix-command flakes'
sudo reboot
```

Keep the checkout in place. If you already have a system flake, import
`nixfig.nixosModules.default` and set `nixfig.username` there instead of running setup.

## Build and switch

Run from this repo's directory. The override uses your current local edits.

```sh
# Build without activating
sudo nixos-rebuild build --flake path:/etc/nixos#default \
  --override-input nixfig "path:$PWD"

# Build and activate
sudo nixos-rebuild switch --flake path:/etc/nixos#default \
  --override-input nixfig "path:$PWD"
```

## Update

Run from this repo, then use the switch command above:

```sh
# Update package and module versions
nix flake update

# Refresh the system's reference to this checkout
sudo nix flake update nixfig --flake path:/etc/nixos
```

## Generations and cleanup

```sh
# List system generations
nixos-rebuild list-generations

# Switch back to the previous generation
sudo nixos-rebuild switch --rollback
```

```sh
# Delete generations older than 30 days and collect unused store paths
sudo nix-collect-garbage --delete-older-than 30d
```

To delete all previous generations instead, use `sudo nix-collect-garbage -d`.
Deleted generations are no longer available for rollback. After cleanup, run the
switch command above to refresh the boot menu.
