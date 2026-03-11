{ host, pkgs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = host.system;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh.enable = true;

  users.users.${host.username} = {
    isNormalUser = true;
    home = host.homeDirectory;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = host.nixosStateVersion;
}
