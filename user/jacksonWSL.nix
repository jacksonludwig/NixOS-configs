{ config, pkgs, ... }:

{
  # enable neovim-nightly overlay
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  # packages to install
  home.packages = with pkgs; [
    bat
    fd
    unzip
    ripgrep

    gcc10

    python3
    go
    jdk11
    nodejs

    gopls
    nodePackages.pyright

    htop
    xclip
    ispell
    texlive.combined.scheme-medium

    (nerdfonts.override { fonts = [ "Inconsolata" ]; })
    iosevka
    roboto-mono
    jetbrains-mono

    neofetch
  ];

  programs.git = {
    enable = true;
    userEmail = "jacksonludwig0@gmail.com";
    userName = "Jackson Ludwig";
  };

  programs.emacs = {
    enable = true;
    # package = pkgs.emacsGcc;
  };
  # home.file.".emacs.d/Emacs.org".source = ../configs/emacs/Emacs.org;
  home.file.".emacs.d/init.el".source = ../configs/emacs/init.el;
}
