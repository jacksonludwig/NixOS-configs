{ config, pkgs, ... }:

let

  unstable = import (fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
      overlays = [
        (import (builtins.fetchTarball {
          url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
        }))
        (import (builtins.fetchTarball {
          url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
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

    gcc10
    cmake

    python3
    go
    jdk11
    nodejs
    nodePackages.typescript
    nodePackages.prettier

    gopls
    nodePackages.pyright
    nodePackages.npm
    nodePackages.typescript-language-server

    firefox
    google-chrome
    discord
    htop
    scrot
    xclip
    ispell
    arandr
    zoom-us
    texlive.combined.scheme-full
    isync
    mu

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

  programs.neovim = {
    enable = true;
    package = unstable.neovim-nightly;
    withNodeJs = true;
    extraConfig = builtins.readFile ../configs/nvim_lua/init.vim;
  };

  programs.emacs = {
    enable = true;
    package = unstable.emacsPgtkGcc;
    # package = unstable.emacsGcc;
    extraPackages = epkgs: with epkgs; [
        vterm
    ];
  };
  home.file.".doom.d/init.el".source = ../configs/doom/init.el;
  home.file.".doom.d/config.el".source = ../configs/doom/config.el;
  home.file.".doom.d/packages.el".source = ../configs/doom/packages.el;
  # home.file.".emacs.d/init.el".source = ../configs/emacs/init.el;
  # home.file.".emacs.d/splash.png".source = ../configs/emacs/splash.png;
}
