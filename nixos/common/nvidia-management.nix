{ lib, pkgs, config, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf mkMerge;
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in {
  options.nvidiaManagement = {
    driver.enable = mkEnableOption "Whether to enable VFIO passthrough for NVIDIA GPU";
    vfio = {
      enable = mkEnableOption "Whether to enable VFIO passthrough for NVIDIA GPU";
      gpuIDs = mkOption { description = "List of PCI IDs for NVIDIA GPU and its audio component";
        type = lib.types.listOf lib.types.str;
        default = [
        ];
        example = [
          "10de:1b81" # GTX 1070 Graphics
          "10de:10f0" # GTX 1070 Audio
        ];
      };
    };
    
    optimus = {
      enable = mkEnableOption "Whether to enable NVIDIA Optimus (Prime) support";
      intelBusId = mkOption {
        description = "PCI bus ID of the Intel GPU";
        type = lib.types.str;
        default = "";
      };
      
      nvidiaBusId = mkOption {
        description = "PCI bus ID of the NVIDIA GPU";
        type = lib.types.str;
        default = "";
      };
    };
  };

  config = let cfg = config.nvidiaManagement;
  in mkMerge [
    (mkIf cfg.driver.enable {
      services.xserver.videoDrivers = [ "nvidia" ];
      boot = {
        kernelParams = [ "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
      };
      hardware.nvidia = {
        powerManagement.enable = true;
        modesetting.enable = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    })

    (mkIf cfg.vfio.enable {
      boot = {
        extraModprobeConfig = ''
          softdep nvidia pre: vfio vfio_pci
        '';
        initrd.kernelModules = [
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ];
        kernelParams = [
          "amd_iommu=on"
          "vfio-pci.ids=${lib.concatStringsSep "," cfg.vfio.gpuIDs}"
        ];
      };
    })

    (mkIf cfg.optimus.enable {
      hardware.nvidia = {
        prime = {
          offload.enable = true;
          inherit (cfg.optimus) intelBusId nvidiaBusId;
        };
      };

      environment.systemPackages = [ nvidia-offload ];
    })
  ];
}
