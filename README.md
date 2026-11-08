# nixfig

A minimal NixOS desktop for `nateb`: Niri manages windows; Noctalia provides the
bar, launcher, notifications, lock screen, and settings.

## Layout

```text
flake.nix                 Dependencies and host wiring
flake.lock                Exact dependency revisions
hosts/desktop/            Machine-specific configuration and hardware
modules/nixos/            Reusable desktop, login, audio, network, and power setup
home/default.nix          User identity, state version, and home directories
home/apps.nix             Applications and Bash configuration
home/niri.nix             Build-time validation and installation of Niri config
home/niri.kdl             Window layout, shortcuts, and Noctalia startup
home/noctalia.nix         Noctalia theme and authentication agent
```

The desktop uses the Niri module included in NixOS. Home Manager manages user
configuration as part of the system rebuild. `nixosModules.desktop` exports the
system desktop setup without user accounts, Home Manager, or machine settings.

## Applications

- Firefox, Thunderbird, and Ghostty.
- Bash, Go, and Bun.
- Git, ripgrep (`rg`), and fd.

Desktop dependencies include Xwayland Satellite for X11 applications and fonts.
Niri uses GTK file dialogs without installing a file manager. Thunderbird account
setup is left to its UI. Other applications can be added to `home/apps.nix`.

## First setup

Run these steps on your **NixOS machine**, from this repository's directory.
The host settings under `hosts/desktop/` were transcribed from your installation
photos, including systemd-boot, disk mounts, timezone, and locale. Copy the original
files below before your first build to preserve exact disk IDs and any settings
outside the photos.

1. Copy your current machine configuration:

   ```sh
   cp /etc/nixos/configuration.nix hosts/desktop/configuration.nix
   cp /etc/nixos/hardware-configuration.nix hosts/desktop/hardware-configuration.nix
   ```

   Preserve the hardware import, bootloader, filesystems, networking, and
   `system.stateVersion`. Copy any additional imported files alongside them,
   keeping their relative paths. The desktop modules are added by the flake.

2. Check `nixos-version`. This configuration uses NixOS **26.05** and matching
   Home Manager. Resolve any release mismatch before switching. The host CPU
   architecture and username are at the top of the flake's `let` block.
   `home.stateVersion` assumes your first Home Manager setup is on 26.05;
   retain your previous value if you already used Home Manager.

3. Stage the source files so Git-backed flakes can see them:

   ```sh
   git add -A
   ```

   Add any extra machine imports too. Staging does not commit or publish files.

4. Validate and build before activating:

   ```sh
   nix --extra-experimental-features 'nix-command flakes' build .#checks.x86_64-linux.niri-config
   sudo nixos-rebuild build --flake .#desktop --option experimental-features 'nix-command flakes'
   sudo nixos-rebuild switch --flake .#desktop --option experimental-features 'nix-command flakes'
   ```

   The first build can take a while. Niri and Noctalia configuration validation
   runs during the build. Keep any error output if a step fails.

Log in as `nateb` through the text login screen; it starts the graphical desktop.
Reboot if the login screen does not appear after the first switch. Your existing
account password is preserved. If this is a new account without a password,
set one with `sudo passwd nateb` before logging in.

## Everyday use

`Super` is the Windows/Super key. The initial keyboard layout is US.

| Shortcut | Action |
| --- | --- |
| Super + Enter | Ghostty |
| Super + Space | App launcher |
| Super + B | Firefox |
| Super + S | Control center |
| Super + Shift + comma | Noctalia settings |
| Alt + Tab | Window switcher |
| Super + arrows or H/J/K/L | Focus a window or column |
| Super + Ctrl + arrows or H/J/K/L | Move a window or column |
| Super + 1–5 / Super + Ctrl + 1–5 | Switch workspace / move column to workspace |
| Super + R | Cycle column width |
| Super + F / Super + Shift + F | Maximize column / fullscreen window |
| Super + V / Super + Q | Toggle floating / close window |
| Super + O | Overview |
| Super + Alt + L | Lock screen |
| Print / Ctrl + Print / Alt + Print | Region / screen / window screenshot |
| Super + Shift + / | Full shortcut help |
| Super + Shift + E | Logout confirmation |

Displays choose their modes automatically; use `niri msg outputs` before adding
monitor-specific settings. Choose a wallpaper in Noctalia settings. Noctalia's
UI preferences in `~/.local/state/noctalia/settings.toml` override its Nix defaults.
The lock screen uses your Linux account password. Screenshots go to
`~/Pictures/Screenshots`.

## Maintenance

Edit the source files, then build and switch:

```sh
nix fmt
sudo nixos-rebuild build --flake .#desktop
sudo nixos-rebuild switch --flake .#desktop
```

Stage new files before rebuilding. Keep `flake.lock` in Git. Run
`nix flake update` when you choose to upgrade dependencies. Keep state versions unchanged
during routine upgrades. Noctalia uses its own Nixpkgs dependency for its build
libraries; the rest of the system follows stable NixOS.

To undo a switch: `sudo nixos-rebuild switch --rollback`. Earlier generations
are also available in the boot menu. Ctrl+Alt+F2 opens a text console if needed.
For login failures, inspect `journalctl -b -u greetd`. If the bar is missing,
open Ghostty with Super+Enter and run `noctalia` to see errors. If Home Manager
reports an existing configuration file collision, back up that file and retry.

On another machine, add a new directory under `hosts/` and a matching
`nixosConfigurations` entry. Reuse the desktop modules, supplying that machine's
hardware and boot configuration.

## References

- [NixOS manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager releases](https://nix-community.github.io/home-manager/usage/upgrading.html)
- [Noctalia on NixOS](https://docs.noctalia.dev/noctalia/getting-started/nixos/)
- [Noctalia with Niri](https://docs.noctalia.dev/noctalia/compositor-settings/niri/)
