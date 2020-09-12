let
  pkgs = import (builtins.fetchTarball {
    url    = "https://github.com/NixOS/nixpkgs/archive/32b46dd897ab2143a609988a04d87452f0bbef59.tar.gz";
    sha256 = "1gzfrpjnr1bz9zljsyg3a4zrhk8r927sz761mrgcg56dwinkhpjk";
  }) { };

in with pkgs; mkShell {
  buildInputs = [
    pkgs.haskell.compiler.ghc865
    cabal-install

    xorg.libX11
    xorg.libXext
    xorg.libXft
    xorg.libXinerama
    xorg.libXpm
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver

    pkgconfig
    autoconf
  ];

  shellHook = ''
    rm -rf .ghc.environment.*
    # Generate the configure script in X11:
    ( test -d x11 && cd x11 && autoreconf -f )
  '';
}
