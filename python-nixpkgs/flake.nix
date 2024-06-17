{
  description = "Python Project Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    kirara-nixvim.url = "github:hyperpastel/kirara-nixvim";
  };

  outputs = { self, nixpkgs, flake-utils, kirara-nixvim }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;

        # Add the required python packages here
        python = pkgs.python3.withPackages (python-pkgs:
          [

          ]);

        kirara = kirara-nixvim.lib.${system};

        cfg = kirara.cfg;
        meow = kirara.meow;

        cfg_final = lib.attrsets.recursiveUpdate cfg {
          plugins = {
            lsp = {
              enable = true;
              servers = {
                pylsp = {
                  enable = true;
                  settings = {
                    plugins = {
                      ruff = {
                        enabled = true;
                        select = [ "F" "E" "PLR" "Q" "W" ];
                      };
                      pylsp_mypy = {
                        enabled = true;
                        dmypy = true;
                      };
                    };
                  };
                };
              };
            };

            treesitter.ensureInstalled = [ "python" ];
          };
        };

        nvim = meow cfg_final;
        shellPackages = [ python ];

      in {
        devShells = {
          default = pkgs.mkShell { packages = shellPackages; };
          nvim = pkgs.mkShell { packages = shellPackages ++ [ nvim ]; };
        };
      });
}
