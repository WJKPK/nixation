{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.utilities.git;
in {
  options.utilities.fzf = with types; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable fzf tooling.";
    };
  };

  config = mkIf cfg.enable {
    programs.fzf= {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
