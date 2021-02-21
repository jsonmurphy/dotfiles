{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.03";

  outputs = { self, nixpkgs }: {

    nixosConfigurations.valhalla = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        (import ./configuration.nix)
      ];
    };
  };
}
