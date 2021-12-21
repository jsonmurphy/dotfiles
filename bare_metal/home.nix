{nix-doom-emacs, awesome-freedesktop, ... }:

{ pkgs, ... }:

{
  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.git = {
    enable = true;
    userName = "Jason Murphy";
    userEmail = "json.murphy@gmail.com";
    aliases = {
      st =  "status";
    };
  };

  programs.fish = {
    enable = true;
    shellInit = ''
    set fish_greeting
    direnv hook fish | source
    '';
    shellAliases = {
      denv = "echo 'use nix' > .envrc && direnv allow .";
      denv-local = "echo 'source_up' > .envrc && echo 'use nix' >> .envrc && direnv allow .";
    };
    functions = {
      fish_prompt = ''
      if test -n "$SSH_TTY"
          echo -n (set_color brred)"$USER"(set_color white)'@'(set_color yellow)(prompt_hostname)' '
      end

      echo -n (set_color blue)(prompt_pwd)' '

      set_color -o
      if fish_is_root_user
          echo -n (set_color red)'# '
      end
      echo -n (set_color red)'❯'(set_color yellow)'❯'(set_color green)'❯ '
      set_color normal
      '';
    };
  };

  imports = [ nix-doom-emacs.hmModule ];
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ../doom.d;
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
    texlive.combined.scheme-medium
    pavucontrol

    jetbrains.idea-community
    firefox
    evince
  ];

  home.file = {
    ".config/awesome/rc.lua".source = ../config/awesome/rc.lua;
    ".config/awesome/themes".source = ../config/awesome/themes;
    ".config/awesome/freedesktop".source = awesome-freedesktop;
    ".config/nvim/init.vim".source = ../config/nvim/init.vim;
    ".config/i3/config".source = ../config/i3/config;
    ".config/polybar".source = ../config/polybar;
    ".ideavimrc".source = ../config/ideavimrc;
    ".Xresources".source = ../config/Xresources;
    # Convert to flake input once submodules support is available
    ".config/awesome/lain".source = pkgs.fetchFromGitHub {
      owner = "lcpz";
      repo = "lain";
      rev = "33c0e0c";
      sha256 = "0i4kgm6n1qv643g384fa19fv1n9lm8jjpc88955dpf5mb6frhj10";
      fetchSubmodules = true;
    };

    "dev/rust/shell.nix".source = ../dev/rust/shell.nix;
    "dev/cpp/shell.nix".source = ../dev/cpp/shell.nix;
  };
}
