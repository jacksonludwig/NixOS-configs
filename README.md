# NixOS-configs

## Use
Config your configuration.nix, create a home.nix, and import or create any relevant nix files.

### Example home
```nix
{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jackson";
  home.homeDirectory = "/home/jackson";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";

  # if needed, role can overwrite settings from user
  imports = [
    ./machine/first.nix
    ./user/jackson.nix
    ./role/nixos-desktop/index.nix
  ];
}
```

### Some extras to add
To use kitty with home-manager without your `.bashrc` being managed,
put `export TERMINFO_DIRS=$(nix eval --raw nixpkgs.kitty.terminfo.outPath)/share/terminfo`
in your `.bashrc`.

### If any font issues are encountered on WSL
Run ``xrdb -merge ~/.Xresources`` after running ``home-manager switch`` at least once.

## TODO
- [x] separate into per-machine configurations (e.g., only use awesomeWM config if using awesomeWM)
