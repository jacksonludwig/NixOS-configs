# ~/.config/nixpkgs/role/nixos-desktop/index.nix
{ config, lib, pkgs, ... }:
{
    # manage awesomeWM config
    home.file.".config/awesome/rc.lua".source = ../../configs/awesomewm/rc.lua;
    # set screen res/refresh rate
    home.file.".xprofile".source = ../../configs/xrandr/first/.xprofile;
}
