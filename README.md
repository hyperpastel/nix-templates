# nix-templates

This is a collection of different templates I use for initializing flake projects.

This repository primarily aims to serve as inspiration, but you can naturally also use these templates directly.

For this, you may simply type
```bash
nix flake init -t github:/hyperpastel/nix-templates#template-name
```

This can be a lot to type tho, so instead, you can also add these templates to your nix registry by running

```bash
nix registry add hyperpastel github:/hyperpastel/nix-templates
```

After this, the command for intialising a directory with one of these template simplifies to

```bash
nix flake init -t hyperpastel#template-name
```
