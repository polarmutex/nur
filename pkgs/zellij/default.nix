{
  pkgs ? import <nixpkgs> {},
  src,
}:
pkgs.callPackage ./derivation.nix {
  inherit src;
}
