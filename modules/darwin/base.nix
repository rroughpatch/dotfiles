{ host, pkgs, ... }:
{
  nix.enable = false;

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = host.system;
  };

  programs.zsh.enable = true;

  users.users.${host.username} = {
    name = host.username;
    home = host.homeDirectory;
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
  ];

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    primaryUser = host.username;
    stateVersion = host.darwinStateVersion;
    defaults = {
      dock.autohide = true;
      finder.AppleShowAllExtensions = true;
    };
  };
}
