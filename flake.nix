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

    nixosConfigurations.valhalla = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ({ pkgs, ... }: {
            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
        })
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.pedantic = import ./home.nix {
            inherit nix-doom-emacs awesome-freedesktop;
          };
        }
      ];
    };
  };
}
