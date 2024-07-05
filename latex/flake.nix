{
  description = "Tex Document Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils}:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Add the required tex packages here
        tex = pkgs.texlive.combine { inherit (pkgs.texlive) scheme-medium; };

        shellPackages = [ tex ];

      in {
        devShells = {
          default = pkgs.mkShell { packages = shellPackages; };
        };
      });
}
