# flake.nix
{
  description = "yves' nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      flake-parts,
      home-manager,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./modules/formatter.nix
        inputs.home-manager.flakeModules.home-manager
      ];
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      perSystem =
        {
          # config,
          # self',
          # inputs',
          # pkgs,
          # system,
          ...
        }:
        { };
      flake =
        let
          homeDefaults.home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "pre-nix-backup";
          };
        in
        {
          # MacBook Pro aarch64-darwin
          darwinConfigurations.Noelle = inputs.nix-darwin.lib.darwinSystem {
            specialArgs = { inherit self; };
            modules = [
              home-manager.darwinModules.home-manager
              homeDefaults
              ./hosts/Noelle/system.nix
              {
                home-manager.users.hylafu = import ./home.nix;
              }
            ];
          };
          # Desktop x86_64-linux
          # Rosalie =
          # Nas x86_64-linux
          # Sable =
          # Mac Mini aarch64-darwin
          # Mireille =
        };
    };
}
# let

# in
# {
#   darwinConfigurations."hylafus-MacBook-Pro" = mkDarwin [
#       ./hosts/macbook/system.nix
#       { home-manager.users.hylafu = import ./home.nix; }
#     ];
#   };
# };
