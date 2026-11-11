# nixfig

A locked NixOS + Home Manager flake for the Niri desktop, Noctalia shell, and
Catppuccin Mocha theme. One system rebuild applies the OS, user applications,
and desktop configuration. No separate Home Manager command or `/etc/nixos`
wrapper flake is needed.

## Layout

```text
flake.nix                     # Inputs, host registry, module exports, checks
flake.lock                    # Exact dependency revisions; commit this file
hosts/<hostname>/             # Hardware, boot, identity, compatibility versions
modules/default.nix           # Shared NixOS + Home Manager integration
modules/nixos/                # Desktop, greeter, services; optional NVIDIA module
modules/home-manager/         # Applications, Niri, Noctalia, and user theming
theme.nix                     # Shared palette
```

`hosts/nixos` reproduces the existing Intel + RTX 3070 laptop, including its
actual filesystem UUIDs, EFI bootloader, PCI addresses, and two-monitor layout.
**Use this host only on that machine.** Other computers need their own hardware
configuration, as described below. Shared modules contain no laptop PCI addresses,
disk identifiers, monitor modes, or forced GPU selection.

## Included

- **Apps:** Firefox, Thunderbird, Ghostty, Thunar, Zed, Cursor, ChatGPT, T3 Code;
  Discord, Spotify, and osu!lazer on x86_64 Linux (their pinned binaries do not
  support ARM Linux).
- **Tools:** Docker, Go, Bun (at least 1.4.4), Git, GitHub CLI, ripgrep, fd,
  package-version-server.
- **Desktop:** Niri, Noctalia, greetd/tuigreet, AppImage support, NetworkManager,
  Bluetooth, PipeWire, power management.
- **Theme:** Catppuccin Mocha/mauve, dark mode, JetBrains Mono Nerd Font,
  uBlock Origin and Firefox Color, Ghostty at 12 pt without decorations.
- **NVIDIA laptop:** Open kernel modules, modesetting, PRIME offload,
  `nvidia-offload`, automatic osu! offloading, and the original render-device
  and monitor settings.

## Clone and rebuild

On an installed NixOS system:

```sh
nix-shell -p git
git clone https://github.com/natebabyak/nixfig.git ~/nixfig
cd ~/nixfig
```

For the existing laptop, use `nixos`; for another computer, add its host first.
Run from the checkout:

```sh
# Evaluate all outputs, including NixOS and its integrated Home Manager config
nix flake check --no-build

# Build and validate both the shared and laptop Niri configurations
nix flake check

# Build the system without activating it
sudo nixos-rebuild build --flake .#nixos

# Activate the OS and Home Manager together
sudo nixos-rebuild switch --flake .#nixos
```

Replace `nixos` with the desired hostname. If flakes are not yet enabled, append
`--option experimental-features 'nix-command flakes'` to these Nix/rebuild
commands for the first build. Subsequent rebuilds enable flakes permanently.
Reboot after the first switch to load the configured kernel and GPU driver.

This checkout becomes the source of configuration. Existing files under
`/etc/nixos` are not imported or modified by these hosts, and the old `setup.sh`
workflow is unnecessary. Existing account passwords are retained; a newly created
account needs a password set with `sudo passwd <username>`. Passwords and other
secrets are deliberately not stored in the repository. Home Manager preserves
pre-existing managed files with the suffix `.nixfig-backup`; move aside an older
backup if it reports a collision.

## Add a computer

1. On the target machine, create a host directory and copy its installed NixOS
   configuration. This retains its existing bootloader, disks, users, locale,
   `system.stateVersion`, and any extra hardware settings:

   ```sh
   host=workstation
   mkdir -p "hosts/$host"
   cp /etc/nixos/configuration.nix "hosts/$host/default.nix"
   cp /etc/nixos/hardware-configuration.nix "hosts/$host/hardware-configuration.nix"
   ```

   Keep the relative `./hardware-configuration.nix` import. Copy any other local
   imports and referenced files into this host directory too; remove absolute
   `/etc/nixos` imports. If there is no hardware file, generate one on the target:

   ```sh
   sudo nixos-generate-config --show-hardware-config > "hosts/$host/hardware-configuration.nix"
   ```

2. In `hosts/workstation/default.nix`, set `networking.hostName = "workstation";`
   and add these settings, using your login name and the Home Manager compatibility
   version appropriate for that account (26.05 for a new Home Manager setup):

   ```nix
   nixfig.username = "nateb";
   home-manager.users.nateb.home.stateVersion = "26.05";
   ```

   The shared module creates that user, adds wheel/NetworkManager/Docker groups,
   and installs the complete shared environment. Keep the installed system's
   `system.stateVersion` and an existing Home Manager `home.stateVersion` unchanged.
   Remove competing desktop/display-manager settings if replacing another desktop
   with Niri/greetd. Keep host-specific services and settings you still need.
   The hardware scan sets `nixpkgs.hostPlatform`; x86_64-linux and aarch64-linux
   use the same shared modules.

3. Register the host beside `nixosConfigurations.nixos` in `flake.nix`:

   ```nix
   nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
     modules = [
       self.nixosModules.default
       ./hosts/workstation
     ];
   };
   ```

4. Include the new files in Git, validate, build, and switch:

   ```sh
   git add flake.nix hosts/workstation
   nix flake check --no-build
   sudo nixos-rebuild build --flake .#workstation
   sudo nixos-rebuild switch --flake .#workstation
   ```

   Git flakes include tracked/staged files, so stage new files before evaluating
   `.#hostname`. Commit the host configuration and lockfile to reproduce this
   machine from another checkout. No edits to the shared desktop are required.

### Optional NVIDIA and display settings

The shared desktop works with Intel/AMD graphics without importing NVIDIA.
For an Intel + NVIDIA PRIME laptop, add this to its host configuration and use
that machine's bus IDs (from `lspci`, translated to NixOS `PCI:bus:device:function`
format; the numbers must be decimal):

```nix
imports = [
  ./hardware-configuration.nix
  ../../modules/nixos/nvidia-offload.nix
];
hardware.nvidia.prime = {
  intelBusId = "PCI:0@0:2:0";
  nvidiaBusId = "PCI:1@0:0:0";
};
```

This module uses NVIDIA's open kernel modules and requires a supported GPU.
A desktop GPU or different hybrid setup should use the appropriate host-local
`hardware.nvidia` configuration instead.

By default Niri chooses displays and its render GPU automatically. Optional
per-host settings stay under `hosts/`, for example:

```nix
home-manager.users.nateb.nixfig.niri = {
  extraConfig = builtins.readFile ./niri.kdl;
  renderDrmDevice = "/dev/dri/by-path/pci-0000:01:00.0-render";
};
```

`extraConfig` contains additional Niri KDL, such as `output` blocks. Leave
`renderDrmDevice` unset on machines that do not need a forced render device.
Both shared and registered hosts' Niri configurations are exposed as flake checks.

## Update, validate, and roll back

```sh
# Deliberately refresh dependency revisions, then review and commit flake.lock
nix flake update
nix flake check --all-systems --no-build
nix flake check
sudo nixos-rebuild build --flake .#nixos
sudo nixos-rebuild switch --flake .#nixos

nixos-rebuild list-generations
sudo nixos-rebuild switch --rollback
```

`--no-build` evaluates the full system and Home Manager activation derivations;
`nix flake check` also runs Niri's validator. A system build checks the full
closure without activating it. Build ARM systems on ARM hardware or with an
appropriately configured remote builder/emulation; evaluating ARM outputs alone
does not build them.

Input versions remain pinned until you update `flake.lock`. Bun, ChatGPT, and
T3 Code reuse Noctalia's separately locked newer nixpkgs input; everything else
uses the main locked NixOS package set. Firefox extension installation URLs and
Noctalia's runtime plugins/wallpaper providers still contact their upstream
services, as in the original setup; their remote content is not pinned by Nix.

To remove old generations and unused store paths:

```sh
sudo nix-collect-garbage --delete-older-than 30d
# Rebuild afterward to refresh the boot menu
sudo nixos-rebuild switch --flake .#nixos
```

Deleted generations are no longer available for rollback.

## Reuse as a module

Existing exports remain available to another flake:

- `nixosModules.default`: shared NixOS desktop with integrated Home Manager.
  Set `nixfig.username` to select the account (default: `nateb`). Supply hardware,
  bootloader, hostname, and state versions in the consuming host configuration.
- `nixosModules.nvidia-offload`: opt-in Intel/NVIDIA offload settings. Set the
  host's PCI bus IDs explicitly; NVIDIA is no longer enabled on every machine.
- `homeModules.default`: the shared Home Manager applications, desktop and theme,
  including the Noctalia and Catppuccin modules. Standalone consumers must supply
  their own user/home details, allow the required unfree packages, and configure
  system-level Niri/services themselves.
- `checks.<system>.niri-config` and `formatter.<system>` are retained; registered
  hosts additionally expose `checks.<system>.niri-<hostname>`.

`setup.sh` is retained for the legacy external `/etc/nixos` wrapper workflow.
New hosts should use the repository-owned configurations above.

References: [NixOS manual](https://nixos.org/manual/nixos/stable/) and
[Home Manager NixOS module](https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nixos-module).
