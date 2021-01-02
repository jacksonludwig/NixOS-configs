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

    gcc10
    ninja

    python3
    go
    jdk11

    gopls

    firefox
    discord
    htop

    inconsolata-nerdfont

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
}
