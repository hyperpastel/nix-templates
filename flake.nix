{
  description = "System flake templates";

  outputs = { ... }: {
    templates = {

      java = {
        path = ./java;
        description = "Flake template with java, nixvim and jdtls.";
      };

      python-pip = {
        path = ./python-pip;
        description =
          "Flake template for python. Easy for collaboratins through pip and venv.";
      };

      python-nixpkgs = {
        path = ./python-nixpkgs;
        description =
          "Flake template for python. Only works on systems with nix, uses nixpkgs python infrastructure.";
      };

      rust = {
        path = ./rust;
        description =
          "Flake template for rust. Uses naersk and the fenix ovelay.";
      };

      latex = {
        path = ./latex;
        description = "Template for writing papers using latex.";
      };

    };
  };
}
