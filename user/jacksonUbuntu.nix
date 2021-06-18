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
    # nodejs-16_x
    nodePackages.npm
    nodePackages.typescript
    nodePackages.prettier
    # (callPackage ../packages/prettier_d_slim/default.nix {}).prettier_d_slim
    nodePackages.eslint
    nodePackages.eslint_d
    nodePackages.typescript-language-server
    nodePackages.expo-cli

    tree-sitter
    watchman

    htop
    xclip
    ispell
    texlive.combined.scheme-medium

    iosevka-bin
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
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
    extraConfig = builtins.readFile ../configs/nvim_coc/init.vim;
  };
  home.file.".config/nvim/lua" = {
    source = ../configs/nvim_coc/lua;
    recursive = true;
  };
  home.file.".config/nvim/coc-settings.json".source = ../configs/nvim_coc/coc-settings.json;

  programs.emacs = {
    enable = true;
    # package = pkgs.emacsGcc;
    extraPackages = epkgs: with epkgs; [
      vterm
    ];
  };

  home.file.".local/share/fonts/" = {
    source = ../configs/fonts;
    recursive = true;
  };

  home.file.".config/kitty/kitty.conf".source = ../configs/kitty/kitty.conf;
}
