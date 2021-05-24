{ config, pkgs, ... }:

let

  unstable = import (fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
      overlays = [
        (import (builtins.fetchTarball {
          url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
        }))
        (import (builtins.fetchTarball {
          url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
        }))
      ];
    };

in {
  # packages to install
  home.packages = with pkgs; [
    bat
    fd
    unzip
    ripgrep

    gcc
    cmake

    jdk11
    nodejs
    nodePackages.typescript
    nodePackages.prettier
    nodePackages.eslint

    nodePackages.pyright
    nodePackages.typescript-language-server
    nodePackages.npm
    tree-sitter

    firefox
    htop
    xclip
    ispell
    texlive.combined.scheme-full

    iosevka-bin
    jetbrains-mono
    source-code-pro
    source-sans-pro
    roboto-mono
    dejavu_fonts
    emacs-all-the-icons-fonts

    neofetch
  ];

  programs.git = {
    enable = true;
    userEmail = "jacksonludwig0@gmail.com";
    userName = "Jackson Ludwig";
  };

  programs.neovim = {
    enable = false;
    package = unstable.neovim-nightly;
    withNodeJs = true;
    extraConfig = builtins.readFile ../configs/nvim_lua/init.vim;
  };
  home.file.".config/nvim/lua" = {
    source = ../configs/nvim_lua/lua;
    recursive = true;
  };

  programs.emacs = {
    enable = true;
    package = unstable.emacsGcc;
    extraPackages = epkgs: with epkgs; [
        vterm
    ];
  };
  # home.file.".doom.d/init.el".source = ../configs/doom/init.el;
  # home.file.".doom.d/config.el".source = ../configs/doom/config.el;
  # home.file.".doom.d/packages.el".source = ../configs/doom/packages.el;
  # home.file.".emacs.d/init.el".source = ../configs/emacs/init.el;
  # home.file.".emacs.d/splash.png".source = ../configs/emacs/splash.png;

  # Font config
  home.file.".Xresources".source = ../configs/wsl_font_conf/.Xresources;
  home.file.".config/fontconfig/fonts.conf".source = ../configs/wsl_font_conf/fonts.conf;
}
