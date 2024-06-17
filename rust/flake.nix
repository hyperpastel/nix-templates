{
  description = "Rust Project Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk/master";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kirara-nixvim.url = "github:hyperpastel/kirara-nixvim";
  };

  outputs = { self, nixpkgs, flake-utils, naersk, fenix, kirara-nixvim }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
        toolchain = fenix.packages.${system}.default.withComponents [
          "cargo"
          "clippy"
          "rustc"
          "rustfmt"
        ];

        naersk' = pkgs.callPackage naersk {};
        package = (naersk'.buildPackage {
          src = ./.;
          cargo = toolchain;
          rustc = toolchain;
        });

        kirara = kirara-nixvim.lib.${system};

        cfg = kirara.cfg;
        meow = kirara.meow;

        cfg_final = lib.attrsets.recursiveUpdate cfg {
          plugins = {
            lsp = {
              enable = true;
              servers = {
                rust-analyzer = {
                  enable = true;
                  installRustc = false;
                  installCargo = false;
                };
              };
            };

            treesitter.ensureInstalled = [ "rust" ];
          };
        };

        nvim = meow cfg_final;

        shellPackages = [ toolchain ];

      in {
        packages.default = package;
        devShells = {
          default = pkgs.mkShell { packages = shellPackages; };
          nvim = pkgs.mkShell { packages = shellPackages ++ [ nvim ]; };
        };
      });
}
