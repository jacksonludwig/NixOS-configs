{ config, pkgs, ... }:

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
    (lib.lowPrio nodePackages.npm)
    nodePackages.typescript
    nodePackages.prettier
    nodePackages.eslint
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
    extraConfig = builtins.readFile ../configs/nvim_lua/init.vim;
  };
  home.file.".config/nvim/lua" = {
    source = ../configs/nvim_lua/lua;
    recursive = true;
  };
  # home.file.".config/nvim/coc-settings.json".source = ../configs/nvim_coc/coc-settings.json;

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
      vterm
    ];
  };

  home.file.".local/share/fonts/" = {
    source = ../configs/fonts;
    recursive = true;
  };

  home.file.".config/fontconfig/fonts.conf".source = ../configs/wsl_font_conf/fonts.conf;
  home.file.".Xresources".source = ../configs/wsl_font_conf/.Xresources;

  home.file.".config/kitty/kitty.conf".source = ../configs/kitty/kitty.conf;
  home.file.".config/alacritty/alacritty.yml".source = ../configs/alacritty/alacritty.yml;
}
