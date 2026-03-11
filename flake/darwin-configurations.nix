{ inputs }:
let
  inherit (inputs)
    self
    nixpkgs
    nix-darwin
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
    nix-darwin.lib.darwinSystem {
      system = host.system;
      specialArgs = {
        inherit self inputs host;
      };
      modules = [
        home-manager.darwinModules.home-manager
        homeDefaults
        ../modules/darwin/base.nix
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

  darwinHosts = lib.filterAttrs (_: host: host.platform == "darwin") hosts;
in
lib.mapAttrs mkConfiguration darwinHosts
