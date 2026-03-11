{ inputs }:
{
  darwinConfigurations = import ./darwin-configurations.nix { inherit inputs; };
  nixosConfigurations = import ./nixos-configurations.nix { inherit inputs; };
}
