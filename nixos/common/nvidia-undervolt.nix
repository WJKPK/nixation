{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.nvidia-undervolt;
  pythonEnv = pkgs.python3.withPackages (ps: [ps.nvidia-ml-py]);
  undervoltScript = pkgs.writeScriptBin "nvidia-undervolt" ''
    #!${pythonEnv}/bin/python

    from pynvml import *

    nvmlInit()
    device = nvmlDeviceGetHandleByIndex(0)

    nvmlDeviceSetGpuLockedClocks(device, ${toString cfg.minClock}, ${toString cfg.maxClock})
    nvmlDeviceSetGpcClkVfOffset(device, ${toString cfg.vfOffset})
    nvmlDeviceSetPowerManagementLimit(device, ${toString cfg.powerLimit})
  '';
in {
  options.nvidia-undervolt = {
    enable = mkEnableOption "Nvidia GPU undervolting service";

    minClock = mkOption {
      type = types.int;
      default = 210;
      description = "Minimum GPU clock in MHz";
    };

    maxClock = mkOption {
      type = types.int;
      default = 1695;
      description = "Maximum GPU clock in MHz";
    };

    vfOffset = mkOption {
      type = types.int;
      default = 220;
      description = "Voltage-frequency curve offset in MHz";
    };

    powerLimit = mkOption {
      type = types.int;
      default = 315000;
      description = "Power limit in milliwatts";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.nvidia-undervolt = {
      description = "NVIDIA GPU Undervolt Service";
      wantedBy = ["multi-user.target"];
      after = ["display-manager.service"];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${undervoltScript}/bin/nvidia-undervolt";
        Restart = "no";
      };
    };
  };
}
