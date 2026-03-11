{ host, ... }:
{
  home = {
    username = host.username;
    homeDirectory = host.homeDirectory;
    stateVersion = host.homeStateVersion;
  };

  programs.home-manager.enable = true;
}
