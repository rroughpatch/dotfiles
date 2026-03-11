{ host, lib, ... }:
{
  imports = [
    ./core.nix
    ./packages/common.nix
    ./programs/git.nix
    ./programs/shell-tools.nix
    ./programs/starship.nix
    ./programs/zsh.nix
  ]
  ++ lib.optionals (host.platform == "darwin") [
    ./packages/darwin.nix
    ./platforms/darwin.nix
  ]
  ++ lib.optionals (host.platform == "linux") [
    ./packages/linux.nix
  ];
}
