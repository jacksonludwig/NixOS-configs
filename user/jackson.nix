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
    ispell
    arandr

    emacs-all-the-icons-fonts
    (nerdfonts.override { fonts = [ "FiraCode" "RobotoMono" ]; })
    iosevka

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
      font.size = 12;
      font.normal.family = "FiraCode Nerd Font";
      font.bold.family = "FiraCode Nerd Font";
      font.italic.family = "FiraCode Nerd Font";
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
    package = pkgs.emacsGcc;
  };
  home.file.".emacs.d/init.el".source = ../configs/emacs/init.el;
}
