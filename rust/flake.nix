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
  };

  outputs = { self, nixpkgs, flake-utils, naersk, fenix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
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

        shellPackages = [ toolchain ];

      in {
        packages.default = package;
        devShells = {
          default = pkgs.mkShell { packages = shellPackages; };
        };
      });
}
