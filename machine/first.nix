# ~/.config/nixpkgs/machine/first.nix
{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;
}
