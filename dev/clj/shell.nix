{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
    clojure
    jdk11
    cfr
  ];
}
