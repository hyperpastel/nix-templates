{
  description = "Python Project Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Add the required python packages here
        python = pkgs.python3.withPackages (python-pkgs:
          [

          ]);

        shellPackages = [ python ];

      in {
        devShells = {
          default = pkgs.mkShell { packages = shellPackages; };
        };
      });
}
