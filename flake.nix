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
            CONFIG_NFT_CT=y
            CONFIG_NFT_COUNTER=y
            CONFIG_NFT_CONNLIMIT=y
            CONFIG_NFT_LOG=y
            CONFIG_NFT_LIMIT=y
            CONFIG_NFT_MASQ=y
            CONFIG_NFT_REDIR=y
            CONFIG_NFT_NAT=y
            CONFIG_NFT_TUNNEL=y
            CONFIG_NFT_OBJREF=y
            CONFIG_NFT_QUEUE=y
            CONFIG_NFT_QUOTA=y
            CONFIG_NFT_REJECT=y
            CONFIG_NFT_REJECT_INET=y
            CONFIG_NFT_COMPAT=y
            CONFIG_NFT_HASH=y
            CONFIG_NF_SOCKET_IPV4=y
            CONFIG_NF_TPROXY_IPV4=y
            CONFIG_NFT_REJECT_IPV4=y
            CONFIG_NF_SOCKET_IPV6=y
            CONFIG_NF_TPROXY_IPV6=y
            CONFIG_NFT_REJECT_IPV6=y
          '';
        };
      in
      {
        defaultPackage = wsl2_linux;
      }
    ));
}
