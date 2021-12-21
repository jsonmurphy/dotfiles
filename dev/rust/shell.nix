{ pkgs ? import <nixpkgs> { } }:

with pkgs;

mkShell {
  buildInputs = [ rustup rust-analyzer gdbgui lldb crate2nix qemu ];
  shellHook = "export PATH=~/.cargo/bin:$PATH";
}
