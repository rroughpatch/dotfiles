# hosts/macbook/system.nix
{ pkgs, ... }:
{
  nix.enable = false;
  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;
  nixpkgs.hostPlatform = "aarch64-darwin";
  users.users.hylafu = {
    name = "hylafu";
    home = "/Users/hylafu";
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
  ];

  security.pam.services.sudo_local.touchIdAuth = true;
  system = {
    primaryUser = "hylafu";
    stateVersion = 6;
    defaults = {
      dock.autohide = true;
      finder.AppleShowAllExtensions = true;
    };
  };
}
