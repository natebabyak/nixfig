# nixfig

A minimal NixOS desktop with **Niri**, **Noctalia**, and **Catppuccin Mocha**.

Firefox · Thunderbird · Ghostty · Zed · Discord · Spotify · Go · Bun · Git

Supports `x86_64-linux` and `aarch64-linux`. Machine settings stay in `/etc/nixos`.

## Quick start

On a fresh NixOS installation, log in as your normal user and connect to the internet.

1. **Clone**

   ```sh
   nix-shell -p git
   git clone https://github.com/natebabyak/nixfig.git ~/nixfig
   cd ~/nixfig
   ```

2. **Set up**

   ```sh
   sudo ./setup.sh "$(id -un)"
   ```

3. **Build** — continue only if successful.

   ```sh
   sudo nixos-rebuild build --flake path:/etc/nixos#default \
     --option experimental-features 'nix-command flakes'
   ```

4. **Apply and reboot**

   ```sh
   sudo nixos-rebuild switch --flake path:/etc/nixos#default \
     --option experimental-features 'nix-command flakes'
   sudo reboot
   ```

5. **Log in** to start Niri. Keep `~/nixfig` in place.

**Notes**

- Uses NixOS 26.05. Keep your existing `system.stateVersion`.
- Another display manager enabled? Disable it in `/etc/nixos/configuration.nix` before building.
- Existing `/etc/nixos/flake.nix`? Import `nixfig.nixosModules.default` and set `nixfig.username` there instead of running setup.

## Shortcuts

| Shortcut | Action |
| --- | --- |
| Super + Enter | Terminal |
| Super + Space | Launcher |
| Super + Shift + comma | Settings |
| Super + Shift + / | All shortcuts |

## Customize

- `home/apps.nix` — applications
- `home/niri.kdl` — windows and shortcuts
- `home/noctalia.nix` — desktop shell
- `theme.nix` — colors

## Update

After editing the checkout:

```sh
sudo nix flake update nixfig --flake path:/etc/nixos
sudo nixos-rebuild build --flake path:/etc/nixos#default
sudo nixos-rebuild switch --flake path:/etc/nixos#default
```

Run `nix flake update` in this repo first to also update dependencies.

Rollback: `sudo nixos-rebuild switch --rollback`.
