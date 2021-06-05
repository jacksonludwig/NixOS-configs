{ config, pkgs, ... }:

# let
# 
#   unstable = import (fetchTarball
#     "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
#       overlays = [
#         (import (builtins.fetchTarball {
#           url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
#         }))
#         (import (builtins.fetchTarball {
#           url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
#         }))
#       ];
#     };
# 
# in 

{

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

    gcc
    cmake

    nodejs
    nodePackages.npm
    nodePackages.typescript
    nodePackages.prettier
    nodePackages.eslint
    nodePackages.eslint_d
    nodePackages.diagnostic-languageserver
    nodePackages.typescript-language-server
    nodePackages.expo-cli

    nodePackages.pyright
    tree-sitter
    jdk11

    htop
    xclip
    ispell
    discord
    texlive.combined.scheme-full

    iosevka-bin
    jetbrains-mono
    source-code-pro
    source-sans-pro
    dejavu_fonts
    emacs-all-the-icons-fonts
    roboto-mono

    neofetch
  ];

  programs.git = {
    enable = true;
    userEmail = "jludwig@greenactionstudio.com";
    userName = "Jackson Ludwig";
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    withNodeJs = true;
    extraConfig = builtins.readFile ../configs/nvim_lua/init.vim;
  };
  home.file.".config/nvim/lua" = {
    source = ../configs/nvim_lua/lua;
    recursive = true;
  };

  programs.emacs = {
    enable = true;
    # package = unstable.emacsGcc;
    extraPackages = epkgs: with epkgs; [
      vterm
    ];
  };
  # home.file.".doom.d/init.el".source = ../configs/doom/init.el;
  # home.file.".doom.d/config.el".source = ../configs/doom/config.el;
  # home.file.".doom.d/packages.el".source = ../configs/doom/packages.el;
  # home.file.".emacs.d/init.el".source = ../configs/emacs/init.el;
  # home.file.".emacs.d/splash.png".source = ../configs/emacs/splash.png;

  home.file.".local/share/fonts/" = {
    source = ../configs/fonts;
    recursive = true;
  };
}
