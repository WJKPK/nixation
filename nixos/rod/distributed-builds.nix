{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.rod.distributedBuilds;
in {
  options.rod.distributedBuilds.enable = mkEnableOption "Enable distributed builds for rod";

  config = mkIf cfg.enable {
    nix.distributedBuilds = true;
    nix.settings.builders-use-substitutes = true;
    nix.buildMachines = [
      {
        hostName = "perun";
        sshUser = "remotebuild";
        sshKey = "/root/.ssh/remotebuilder";
        system = pkgs.stdenv.hostPlatform.system;
        supportedFeatures = ["nixos-test" "big-parallel" "kvm"];
      }
    ];
  };
}
