{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  name = "udev-rules";

  src = ./rules/.;

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    cp *.rules $out/lib/udev/rules.d
  '';
}
