set shell := ["zsh", "-cu"]

flake := "path:" + justfile_directory()
noelle := flake + "#Noelle"
rosalie := flake + "#Rosalie"

default:
  @just --justfile {{justfile()}} --list

check:
  nix flake check {{flake}}

fmt:
  nix fmt

build-noelle:
  darwin-rebuild build --flake {{noelle}} --impure

switch-noelle:
  sudo darwin-rebuild switch --flake {{noelle}} --impure

build-rosalie:
  nixos-rebuild build --flake {{rosalie}}

switch-rosalie:
  sudo nixos-rebuild switch --flake {{rosalie}}
