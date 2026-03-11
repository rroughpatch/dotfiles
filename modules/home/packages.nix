{ pkgs, ... }:
{
  home.packages = with pkgs; [
    eza
    zoxide
    starship
    pay-respects
    carapace
    ripgrep
    fd
    bat
    jq
    fzf
    delta
    neovim
    bun
    pnpm
    nodejs
    rustup
    cmake
    nixd
    nixfmt
    alejandra
    typescript-go
  ];
}
