{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.perun.virtualization.docker;
in {
  options.perun.virtualization.docker = {
    enable = mkEnableOption "Enable container tooling on perun";
    enablePodman = mkOption {
      type = types.bool;
      default = true;
      description = "Toggle Podman support";
    };
    enableDocker = mkOption {
      type = types.bool;
      default = true;
      description = "Toggle Docker service";
    };
    enableNvidiaToolkit = mkOption {
      type = types.bool;
      default = config.nvidiaManagement.driver.enable;
      defaultText = "config.nvidiaManagement.driver.enable";
      description = "Enable NVIDIA container toolkit";
    };
    dockerDataRoot = mkOption {
      type = types.str;
      default = "/vms/docker";
      description = "Custom Docker data root";
    };
  };

  config = mkIf cfg.enable {
    hardware.nvidia-container-toolkit.enable = cfg.enableNvidiaToolkit;
    virtualisation = {
      podman.enable = cfg.enablePodman;
      docker = mkIf cfg.enableDocker {
        enable = true;
        enableOnBoot = true;
        daemon.settings = {
          data-root = cfg.dockerDataRoot;
        };
      };
    };
  };
}
