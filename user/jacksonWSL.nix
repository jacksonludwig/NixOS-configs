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
    nodePackages.typescript-language-server
    nodePackages.npm

    firefox
    htop
    xclip
    ispell
    texlive.combined.scheme-medium
    isync
    mu

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

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    withNodeJs = true;
    extraConfig = builtins.readFile ../configs/nvim/init.vim;
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
        vterm
    ];
  };
  home.file.".emacs.d/init.el".source = ../configs/emacs/init.el;

  # Font config
  home.file.".Xresources".source = ../configs/wsl_font_conf/.Xresources;
  home.file.".config/fontconfig/fonts.conf".source = ../configs/wsl_font_conf/fonts.conf;
}
