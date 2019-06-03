{nixpkgs ? import ../gh-stats/nixpkgs.nix}:
# let
#   pkgs = import nixpkgs { config.allowBroken = true; };
#   hp = pkgs.haskellPackages.override rec {
#     overrides = self: super: with pkgs.haskell.lib; rec {
#       binary-instances-1 = doJailbreak super.binary-instances-1;
#       QuickCheck = super.QuickCheck_2_13_1;
#       quickcheck-instances = super.quickcheck-instances_0_3_21;
#       binary-orphans = super.binary-orphans_1_0_1;
#     };
#   };
#   drv = hp.callPackage ./. {};
# in
#   drv.env
let
  pkgs = import nixpkgs {};
  ghcWithP = pkgs.haskellPackages.ghcWithPackages (hp: with hp; [
    pkgs.cabal-install
    ghcid
    zlib
  ]);
in
  pkgs.mkShell {
    buildInputs = [ghcWithP];
  }
