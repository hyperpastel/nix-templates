{
  description = "Python Project Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils}:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        makeEnv = additionalPackages:
          pkgs.buildFHSUserEnv {
            name = "pip-env";
            targetPkgs = pkgs:
              [
                pkgs.python311Full
                pkgs.python311Packages.virtualenv
                pkgs.python311Packages.pip
              ] ++ [ additionalPackages ];
            runScript = pkgs.writeShellScript "venv-starter.sh" ''
              if [ ! -d .venv ]; then
                python -m venv .venv
              fi

              source .venv/bin/activate
            '';
          };
      in {
        devShells.default = (makeEnv [ ]).env;
      });
}
