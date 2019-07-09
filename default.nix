{ nixpkgs ? import ./nixpkgs.nix
, dev ? false
}:

let
  pkgs = import nixpkgs { overlays = [ (import ./overlay.nix) ]; };
  github = pkgs.haskellPackages.callCabal2nix "github" ./. { };
  githubOpenSSL = pkgs.haskell.lib.overrideCabal github (drv: {
    libraryHaskellDepends = drv.libraryHaskellDepends ++ (with pkgs.haskellPackages; [
      # These are behind a flag that that is enabled in the `cabal.project` file.
      http-client-openssl
      HsOpenSSL
      HsOpenSSL-x509-system
    ]);
  });

  hp = pkgs.haskellPackages;

  shellDrv = pkgs.haskell.lib.overrideCabal githubOpenSSL (drv': {
    buildDepends =
      (drv'.buildDepends or []) ++
      [ (hp.hoogleLocal {
          packages =
            (drv'.libraryHaskellDepends or []) ++
            (drv'.executableHaskellDepends or []) ++
            (drv'.testHaskellDepends or []) ;
        })
        pkgs.cabal-install
        hp.ghcid
      ];
  });
in
  if dev then shellDrv else githubOpenSSL
