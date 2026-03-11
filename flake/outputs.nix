{ inputs }:
{
  darwinConfigurations = import ./darwin-configurations.nix { inherit inputs; };
}
