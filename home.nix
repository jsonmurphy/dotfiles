{nix-doom-emacs, awesome-freedesktop, ... }:

{ pkgs, ... }:

{
  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.direnv.enableNixDirenvIntegration = true;

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
    direnv hook fish | source
    '';
    shellAliases = {
      denv = "echo 'use nix' > .envrc && direnv allow .";
    };
  };

  imports = [ nix-doom-emacs.hmModule ];
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
  };

  home.packages = with pkgs; [
    nix-prefetch-scripts
    nix-prefetch-github

    unzip
    git
    ripgrep
    rnix-lsp
    tree
    nixfmt

    jetbrains.idea-community
  ];

  home.file = {
    ".config/awesome/rc.lua".source = ./config/awesome/rc.lua;
    ".config/awesome/themes".source = ./config/awesome/themes;
    ".config/awesome/freedesktop".source = awesome-freedesktop;
    ".config/nvim/init.vim".source = ./config/nvim/init.vim;
    ".ideavimrc".source = ./config/ideavimrc;
    # Convert to flake input once submodules support is available
    ".config/awesome/lain".source = pkgs.fetchFromGitHub {
      owner = "lcpz";
      repo = "lain";
      rev = "33c0e0c";
      sha256 = "0i4kgm6n1qv643g384fa19fv1n9lm8jjpc88955dpf5mb6frhj10";
      fetchSubmodules = true;
    };
  };
}
