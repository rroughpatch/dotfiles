{ host, lib, ... }:
{
  imports = [
    ./core.nix
    ./packages.nix
    ./programs/git.nix
    ./programs/shell-tools.nix
    ./programs/starship.nix
    ./programs/zsh.nix
  ]
  ++ lib.optionals (host.platform == "darwin") [
    ./platforms/darwin.nix
  ];
}
