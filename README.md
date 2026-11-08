# nixfig

A minimal NixOS desktop with **Niri**, **Noctalia**, and **Catppuccin Mocha**.

Firefox · Thunderbird · Ghostty · Go · Bun · Git

Supports `x86_64-linux` and `aarch64-linux`. Machine settings stay in `/etc/nixos`.

## Setup

Requires an existing NixOS installation. Uses **NixOS 26.05** and Home Manager.

From a permanent checkout, replace `YOUR_USERNAME` with your Linux account:

```sh
sudo ./setup.sh YOUR_USERNAME
sudo nixos-rebuild build --flake path:/etc/nixos#default --option experimental-features 'nix-command flakes'
sudo nixos-rebuild switch --flake path:/etc/nixos#default --option experimental-features 'nix-command flakes'
```

Log in to start Niri. Keep the checkout at the same path.

<details>
<summary>Setup notes</summary>

- Preview with `./setup.sh --print YOUR_USERNAME`.
- Setup creates `/etc/nixos/flake.nix` and retains your machine configuration.
- Applying this configuration moves your system to NixOS 26.05. Keep existing
  system and Home Manager state versions; override the latter through
  `home-manager.users.<username>.home.stateVersion` in your local configuration.
- Already using flakes? Add this repo as an input, import
  `nixfig.nixosModules.default`, and set `nixfig.username`.
- Keeping a graphical login manager? Set `services.greetd.enable = false;` locally.
- New account? Set a password with `sudo passwd YOUR_USERNAME`.

</details>

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
