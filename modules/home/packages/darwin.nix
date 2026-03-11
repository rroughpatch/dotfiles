{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mas
    raycast
  ];
}
