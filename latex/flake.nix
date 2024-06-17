{
  description = "Tex Document Flake";

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

        # Add the required tex packages here
        tex = pkgs.texlive.combine { inherit (pkgs.texlive) scheme-basic; };

        kirara = kirara-nixvim.lib.${system};

        cfg = kirara.cfg;
        meow = kirara.meow;

        cfg_final = lib.attrsets.recursiveUpdate cfg {
          plugins = {
            cmp-buffer.enable = true;
            cmp-latex-symbols.enable = true;

            vimtex = {
              enable = true;
              texlivePackage = tex;
              settings.view_method = "zathura";
            };

            cmp.settings.sources = cfg.plugins.cmp.settings.sources
              ++ [ { name = "buffer"; } { name = "latex_symbols"; } ];

            lsp = {
              enable = true;
              servers = { texlab = { enable = true; }; };
            };
          };
        };

        nvim = meow cfg_final;
        shellPackages = [ ];

      in {
        devShells = {
          default = pkgs.mkShell { packages = shellPackages; };
          nvim = pkgs.mkShell { packages = shellPackages ++ [ nvim ]; };
        };
      });
}
