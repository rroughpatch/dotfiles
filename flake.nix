{
  description = "yves' nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});

      hmDefaults = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "pre-nix-backup";
        };
      };

      mkDarwin =
        modules:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit self; };
          modules = [
            home-manager.darwinModules.home-manager
            hmDefaults
          ]
          ++ modules;
        };
    in
    {
      formatter = eachSystem (pkgs: pkgs.nixfmt);

      checks = eachSystem (
        _: eval: {
          formatting = eval.config.build.check self;
        }
      );

      darwinConfigurations = {
        "hylafus-MacBook-Pro" = mkDarwin [
          ./hosts/macbook/system.nix
          { home-manager.users.hylafu = import ./home.nix; }
        ];
      };
    };
}
