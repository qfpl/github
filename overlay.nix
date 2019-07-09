_: pkgs: {
  haskellPackages = pkgs.haskellPackages.override (old: {
    overrides = pkgs.lib.composeExtensions (old.overrides or (_: _: {})) (self: super: with pkgs.haskell.lib; {

      # binary-instances gets the versions it needs thanks to this overlay, so is no longer broken.
      binary-instances = overrideCabal super.binary-instances (drv: {
        broken = false;
      });

      # Newer versions of things.
      ansi-terminal = super.ansi-terminal_0_9_1;
      binary-orphans = super.binary-orphans_1_0_1;
      concurrent-output = super.concurrent-output_1_10_10;
      # hashable is here because of the constraint in the cabal.project file.
      hashable = super.hashable_1_3_0_0;
      QuickCheck = super.QuickCheck_2_13_1;
      quickcheck-instances = super.quickcheck-instances_0_3_21;
      # semigroups is here because of the constraint in the cabal.project file.
      semigroups = super.semigroups_0_19;
      tasty = super.tasty_1_2_2;
      time-compat = super.time-compat_1_9_2_2;
      unordered-containers = super.unordered-containers_0_2_10_0;

      # Things that work with newer versions of dependencies but don't know it yet.
      ChasingBottoms = doJailbreak super.ChasingBottoms;
      hspec-core = dontCheck (doJailbreak super.hspec-core);
      optparse-applicative = doJailbreak super.optparse-applicative;
      psqueues = doJailbreak super.psqueues;
      vault = doJailbreak super.vault;

      # Revision 1 removes upper bound on hashable. This is what latest hackage-packages.nix has.
      # We missed the update by a couple of days.
      uniplate = overrideCabal super.uniplate (old: {
        sha256 = "1dx8f9aw27fz8kw0ad1nm6355w5rdl7bjvb427v2bsgnng30pipw";
        revision = "1";
        editedCabalFile = "0gsrs2mk58jg3x36dyzxi4y46isd5p6q0rd6m9l834h5r7ds6a54";
      });

      # Break infinite recursion through QuickCheck test dep
      splitmix = dontCheck super.splitmix;
    });
  });
}