#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: sudo ./setup.sh [username]"
  echo "       ./setup.sh --print [username]"
  echo "Connect this checkout to the existing NixOS configuration. Default user: nateb."
}

print_only=false
case "${1:-}" in
  --help|-h) usage; exit 0 ;;
  --print) print_only=true; shift ;;
esac
if (( $# > 1 )); then
  usage >&2
  exit 1
fi

username="${1:-nateb}"
repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
escape_nix() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/${/\\${/g'
}
repo_url="$(escape_nix "path:$repo_dir")"
account="$(escape_nix "$username")"

flake="$(cat <<EOF
{
  inputs = {
    nixfig.url = "$repo_url";
    nixpkgs.follows = "nixfig/nixpkgs";
  };

  outputs = { nixpkgs, nixfig, ... }: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        nixfig.nixosModules.default
        { nixfig.username = "$account"; }
      ];
    };
  };
}
EOF
)"

if "$print_only"; then
  printf '%s\n' "$flake"
  exit 0
fi

if [[ ! -f /etc/NIXOS || ! -f /etc/nixos/configuration.nix ]]; then
  echo "Run this on an installed NixOS device with /etc/nixos/configuration.nix." >&2
  exit 1
fi
if (( EUID != 0 )); then
  echo "Run with sudo so the local flake can be written to /etc/nixos." >&2
  exit 1
fi
if [[ -e /etc/nixos/flake.nix ]]; then
  echo "/etc/nixos/flake.nix already exists; no files changed." >&2
  echo "Import nixfig.nixosModules.default into your existing flake instead." >&2
  exit 1
fi

set -o noclobber
printf '%s\n' "$flake" > /etc/nixos/flake.nix
echo "Created /etc/nixos/flake.nix for $username. Existing machine settings are unchanged."
echo "Next, build before switching (see README.md). Keep this checkout at $repo_dir."
