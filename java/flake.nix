{
  description = "Java Project Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        solution = pkgs.stdenv.mkDerivation {
          pname = "application";
          version = "1.0.0";
          src = ./.;
          nativeBuildInputs = [ pkgs.jdk pkgs.maven ];

          buildPhase = ''
            mvn install
            mvn package
          '';
        };

        shellPackages = [ pkgs.maven pkgs.jdk ];

      in {
        packages.default = solution;
        devShells = {
          default = pkgs.mkShell { packages = shellPackages; };
        };
      });
}
