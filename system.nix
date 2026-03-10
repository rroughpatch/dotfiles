{ pkgs, ... }:

{
  # Let Determinate Nix manage itself
  nix.enable = false;

  # Allow unfree packages (things like vscode, etc.)
  nixpkgs.config.allowUnfree = true;

  # System-level packages (available to all users)
  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
  ];

  # Enable zsh as default shell (macOS default)
  programs.zsh.enable = true;

  # Required for nix-darwin
  system.stateVersion = 6;

  # Set your primary user
  users.users.hylafu = {
    name = "hylafu";
    home = "/Users/hylafu";
  };

  # You can add macOS system preferences here later, e.g.:
  # security.pam.services.sudo_local.touchIdAuth = true;
  # system.defaults.dock.autohide = true;
  # system.defaults.finder.AppleShowAllExtensions = true;
}
