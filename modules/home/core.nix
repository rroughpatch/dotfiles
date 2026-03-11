{ host, ... }:
{
  home.stateVersion = host.homeStateVersion;

  programs.home-manager.enable = true;
}
