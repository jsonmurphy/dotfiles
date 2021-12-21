{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
    awesome-freedesktop = {
      url = "github:lcpz/awesome-freedesktop";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-doom-emacs, awesome-freedesktop }: {


    nixosConfigurations.bare = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./bare_metal/configuration.nix
        ({ pkgs, ... }: {
            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
        })
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.pedantic = import ./bare_metal/home.nix {
            inherit nix-doom-emacs awesome-freedesktop;
          };
        }
      ];
    };

    nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./wsl/configuration.nix
        ./wsl/build-tarball.nix
        ({ pkgs, ... }: {
            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
        })
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.pedantic = import ./wsl/home.nix {
            inherit nix-doom-emacs awesome-freedesktop;
          };
        }
      ];
    };
  };
}
