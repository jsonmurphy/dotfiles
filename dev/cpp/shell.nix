{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
    gdbgui
    gcc
    ccls
    autoconf
    automake
    lldb
    nlohmann_json
  ];
}
