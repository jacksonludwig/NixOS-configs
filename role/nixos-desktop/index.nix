# ~/.config/nixpkgs/role/nixos-desktop/index.nix
{ config, lib, pkgs, ... }:
{
    # manage awesomeWM config
    home.file.".config/awesome/rc.lua".source = ../../configs/awesomewm/rc.lua;
}
