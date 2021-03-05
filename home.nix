{nix-doom-emacs, ... }:

{ pkgs, ... }:

{
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Jason Murphy";
    userEmail = "jason.murphy@gmail.com";
    aliases = {
      st =  "status";
    };
  };

  programs.fish = {
    enable = true;
    shellInit = ''
    set -gx DISPLAY (cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
    '';
  };

  imports = [ nix-doom-emacs.hmModule ];
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
  };

  xsession.windowManager.awesome = {
    enable = true;
  };

  home.packages = [
    pkgs.nix-prefetch-scripts
  ];

  home.file = {
    ".config/awesome/rc.lua".source = ./config/awesome/rc.lua;
    ".config/awesome/themes".source = ./config/awesome/themes;
    ".config/awesome/lain".source = pkgs.fetchFromGitHub {
      owner = "lcpz";
      repo = "lain";
      rev = "33c0e0c";
      sha256 = "0i4kgm6n1qv643g384fa19fv1n9lm8jjpc88955dpf5mb6frhj10";
      fetchSubmodules = true;
    };
    ".config/awesome/freedesktop".source = pkgs.fetchFromGitHub {
      owner = "lcpz";
      repo = "awesome-freedesktop";
      rev = "6951b09";
      sha256 = "0x7d0hsggbk92y89mpzp4n5ap8fsa2rkfv43nlcy0fhjv0ix2fdr";
    };
    ".config/nvim/init.vm".source = ./config/nvim/init.vim;
  };
}
