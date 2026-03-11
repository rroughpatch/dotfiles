{ inputs }:
let
  inherit (inputs)
    self
    nixpkgs
    home-manager
    ;
  inherit (nixpkgs) lib;

  hosts = import ../hosts;

  homeDefaults.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "pre-nix-backup";
  };

  mkConfiguration =
    _: host:
    lib.nixosSystem {
      system = host.system;
      specialArgs = {
        inherit self inputs host;
      };
      modules = [
        home-manager.nixosModules.home-manager
        homeDefaults
        ../modules/nixos/base.nix
        (host.path + "/system.nix")
        {
          home-manager.extraSpecialArgs = {
            inherit host inputs;
          };
          home-manager.users.${host.username}.imports = [
            ../modules/home/base.nix
            (host.path + "/home.nix")
          ];
        }
      ];
    };

  nixosHosts = lib.filterAttrs (_: host: host.platform == "linux") hosts;
in
lib.mapAttrs mkConfiguration nixosHosts
