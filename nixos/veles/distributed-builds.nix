{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.veles.distributedBuilds;
in {
  options.veles.distributedBuilds.enable = mkEnableOption "Enable distributed builds on veles";

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
