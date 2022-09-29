{
  description = "WSL2 Linux Kernel";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    wsl2-kernel = {
      url = "github:microsoft/WSL2-Linux-Kernel/linux-msft-wsl-5.10.y";
      flake = false;
    };
  };

  outputs = { self, flake-utils, nixpkgs, wsl2-kernel }@inputs:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        wsl2_linux = pkgs.linuxKernel.manualConfig rec {
          inherit (pkgs) lib;
          inherit (pkgs.linux_5_10) stdenv;

          src = wsl2-kernel;

          # TODO: generate the version ourselves. Must match what's in wsl2-kernel.
          version = "5.10.102.1-microsoft-standard-WSL2";

          allowImportFromDerivation = true;
          configfile = pkgs.writeText "config" ''
            ${builtins.readFile "${wsl2-kernel}/Microsoft/config-wsl"}
            # Extra config here
          '';
        };
      in
      {
        defaultPackage = wsl2_linux;
      }
    ));
}
