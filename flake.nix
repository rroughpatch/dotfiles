{
  description = "yves' nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    codex-nix.url = "github:SecBear/codex-nix";
    codex-nix.inputs.nixpkgs.follows = "nixpkgs";
    codex-nix.inputs.flake-parts.follows = "flake-parts";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./modules/formatter.nix
        inputs.home-manager.flakeModules.home-manager
      ];

      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];

      flake = import ./flake/outputs.nix { inherit inputs; };
    };
}
