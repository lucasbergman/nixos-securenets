{
  description = "A flake to manage simple WireGuard mesh networks";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    terranix = {
      url = "github:terranix/terranix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        treefmt = treefmt-nix.lib.evalModule pkgs ./nix/treefmt.nix;
      in
      {
        formatter = treefmt.config.build.wrapper;

        nixosModules.securenets =
          { ... }:
          {
            imports = [ ./nix/nixos.nix ];
          };
      }
    )
    // {
      terranixModules.securenets = import ./nix/terranix.nix;
      terranixModule.imports = [ self.terranixModules.securenets ];
    };
}
