{
  description = "Java Project Flake";

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

        kirara = kirara-nixvim.lib.${system};

        cfg = kirara.cfg;
        meow = kirara.meow;
        fn = kirara.fn;

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

        cfg_final = lib.attrsets.recursiveUpdate cfg {
          plugins = {
            lsp.enable = false;
            nvim-jdtls = {
              enable = true;
              data = "";

              extraOptions = {
                cmd.__raw = "  {\n    \"${
                        lib.getExe pkgs.jdt-language-server
                      }\",\n    \"-root_dir\", vim.fs.root(0, \"pom.xml\"),\n  }\n";
              };
            };

            treesitter.ensureInstalled = [ "java" ];

          };

          keymaps = cfg.keymaps ++ [
            (fn.nmap "<leader>f" "<Cmd>lua vim.lsp.buf.format() <CR>")
            (fn.nmap "<leader>r" "<Cmd>lua vim.lsp.buf.rename()<CR>")
            (fn.nmap "<leader>a" "<Cmd>lua vim.lsp.buf.code_action() <CR>")

            (fn.nmap "K" "<Cmd>lua vim.lsp.buf.hover() <CR>")
            (fn.nmap "gD" "<Cmd>lua vim.lsp.buf.references() <CR>")
            (fn.nmap "gd" "<Cmd>lua vim.lsp.buf.definition() <CR>")
            (fn.nmap "gi" "<Cmd>lua vim.lsp.buf.implementation() <CR>")
            (fn.nmap "gt" "<Cmd>lua vim.lsp.buf.type_definition() <CR>")

            (fn.nmap "<leader>e" "<Cmd>lua vim.diagnostic.open_float() <CR>")
          ];
        };

        nvim = meow cfg_final;
        shellPackages = [ pkgs.maven pkgs.jdk ];

      in {
        packages.default = solution;
        devShells = {
          default = pkgs.mkShell { packages = shellPackages; };
          nvim = pkgs.mkShell { packages = shellPackages ++ [ nvim ]; };
        };
      });
}
