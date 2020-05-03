let
  pkgs = import (builtins.fetchTarball {
    url    = "https://github.com/NixOS/nixpkgs/archive/32dcb6051a9a2fa687283f4883d3552c3a46c081.tar.gz";
    sha256 = "1dvgk1cvai79yxn9lk9fnzqsqwi236y99ldxky6v999dx33nzygb";
  }) { };

in with pkgs; mkShell {
  buildInputs = [
    pkgs.haskell.compiler.ghc861
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
