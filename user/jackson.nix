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

    python3
    go
    jdk11
    nodejs

    gopls
    nodePackages.pyright

    firefox
    discord
    htop
    scrot
    xclip

    inconsolata-nerdfont
    emacs-all-the-icons-fonts
    roboto-mono
    fira-code

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
      font.size = 14.5;
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
    # package = pkgs.emacsGcc;
  };
  home.file.".doom.d/init.el".source = ../configs/doom/init.el;
  home.file.".doom.d/config.el".source = ../configs/doom/config.el;
  home.file.".doom.d/packages.el".source = ../configs/doom/packages.el;
}
