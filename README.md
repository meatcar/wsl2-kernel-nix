# WSL2 Kernel with `nftables`

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

A Nix Flake to build the [WSL2 Kernel](https://github.com/microsoft/WSL2-Linux-Kernel) with `nftables` support.

## Instructions

1. Install [nix](https://nixos.org/download.html)
2. Clone this repo.
3. `cd wsl2-linux-kernel-nix`
4. `nix build`
5. `cp result/bzImage /mnt/c/Users/<UserName>/kernel`
6. [Configure .wslconfig](https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configuration-setting-for-wslconfig) to use the new kernel.

## Caveats

- Builds off latest git release. Tweak the `./flake.nix` inputs for a different version.
- The kernel version string has to be manually updated to match upstream.
