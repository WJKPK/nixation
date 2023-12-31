let
  # GTX 1070
  gpuIDs = [
    "10de:1b81" # Graphics
    "10de:10f0" # Audio
  ];
in { pkgs, lib, config, ... }: {
  options.vfio.enable = with lib; mkOption {
      description = "Whether to enable VFIO";
      type = types.bool;
      default = true;
    };

  config = let cfg = config.vfio;
  in {
    boot = {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        "vfio_virqfd"

        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];

      kernelParams = [
        # enable IOMMU
        "amd_iommu=on"
      ] ++ lib.optional cfg.enable
        # isolate the GPU
        ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);
    };
  };
}

