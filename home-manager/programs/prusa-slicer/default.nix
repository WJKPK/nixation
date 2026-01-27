{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.utilities.prusaSlicer;
  #let
  #  prusa-slicer-wrapped = pkgs.symlinkJoin {
  #    name = "prusa-slicer-wrapped";
  #    paths = [pkgs.prusa-slicer];
  #    buildInputs = [pkgs.makeWrapper];
  #    # Apply the same GLX vendor library workaround as in the KiCad config
  #    postBuild = ''
  #      wrapProgram $out/bin/prusa-slicer \
  #        --set __GLX_VENDOR_LIBRARY_NAME mesa \
  #        --set __EGL_VENDOR_LIBRARY_FILENAMES ${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json
  #    '';
  #  };
  #in
in {
  options.utilities.prusaSlicer = with types; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable PrusaSlicer.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.prusa-slicer];
  };
}
