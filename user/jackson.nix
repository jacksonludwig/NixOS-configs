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
    nodePackages.typescript

    gopls
    nodePackages.pyright
    nodePackages.npm

    #firefox
    google-chrome
    discord
    htop
    scrot
    xclip
    ispell
    arandr
    zoom-us
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

  programs.alacritty = {
    enable = true;
    settings = {
      font.size = 14;
      font.normal.family = "Inconsolata Nerd Font";
      font.bold.family = "Inconsolata Nerd Font";
      font.italic.family = "Inconsolata Nerd Font";
    };
  };

  programs.bash = {
    enable = true;
    initExtra = ''
        gu() {
            git add .
            git commit -m "$1"
            git push
        }
    '';
    shellAliases = {
      c = "cd ~/.config/nixpkgs";
    };
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
        vterm
    ];
  };
  home.file.".emacs.d/init.el".source = ../configs/emacs/init.el;
  home.file.".emacs.d/splash.png".source = ../configs/emacs/splash.png;
}
