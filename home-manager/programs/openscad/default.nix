{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.utilities.openscad;
  bosl2 = builtins.fetchGit {
    url = "https://github.com/BelfrySCAD/BOSL2.git";
    rev = "eda0cd75b5b23e6d745e64052b9835b878a4c28b";
  };
in {
  options.utilities.openscad = with types; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable OpenSCAD resources.";
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables.OPENSCADPATH = "${config.xdg.dataHome}/OpenSCAD/libraries";
    home.file."${config.xdg.dataHome}/OpenSCAD/libraries/BOSL2" = {
      source = bosl2;
    };
  };
}
