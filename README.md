# dotfiles

My configurations for different semi-automatic nixos setups

## Bare metal

### Rebuild

``` sh
sudo nixos-rebuild switch --impure --flake .#bare
```

`--impure` because it needs to access `/etc/nixos/hardware-configuration.nix` 

### Wifi

If wifi connection is needed edit `./wsl/wireless.json`. NEVER commit after editing


## WSL

### Build tarball (on existing nix system)

``` sh
nix build ~/dev/dotfiles#nixosConfigurations.wsl.config.system.build.tarball
```

1. Download tarball on windows
2. Enable WSL
3. Import as follows:

``` powershell
wsl --import NixOS .\NixOS\ nixos-system-x86_64-linux.tar.gz --version 2
```

### Rebuild

``` sh
sudo nixos-rebuild switch --flake .#wsl
```


