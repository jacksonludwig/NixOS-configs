{ config, pkgs, ... }:

{
  # enable neovim-nightly overlay
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];
  

  # packages to install
  home.packages = with pkgs; [
    bat
    fd
    unzip
    ripgrep

    gcc10
    cmake

    python3
    go
    jdk11
    nodejs
    nodePackages.typescript

    gopls
    nodePackages.pyright
    nodePackages.npm
    nodePackages.typescript-language-server

    firefox
    htop
    xclip
    ispell
    texlive.combined.scheme-full
    isync
    mu
    nodePackages.prettier

    (nerdfonts.override { fonts = [ "Inconsolata" ]; })
    iosevka-bin
    fira-code
    jetbrains-mono
    source-code-pro
    source-sans-pro
    roboto-mono

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
    extraConfig = builtins.readFile ../configs/nvim_lua/init.vim;
  };

  programs.emacs = {
    enable = true;
    # package = pkgs.emacsPgtkGcc;
    extraPackages = epkgs: with epkgs; [
        vterm
    ];
  };
  # home.file.".emacs.d/init.el".source = ../configs/emacs/init.el;
  home.file.".emacs.d/splash.png".source = ../configs/emacs/splash.png;

  # Font config
  home.file.".Xresources".source = ../configs/wsl_font_conf/.Xresources;
  home.file.".config/fontconfig/fonts.conf".source = ../configs/wsl_font_conf/fonts.conf;
}
