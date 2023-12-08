{ pkgs, lib, config, ... }:
let
    nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec -a "$0" "$@"
    '';
in {
  options.gpu.enable = with lib; mkOption {
      description = "Enable Optimus GPU";
      type = types.bool;
      default = false;
  };

  config = let cfg = config.gpu;
  in {
    services.xserver.videoDrivers = lib.mkIf cfg.enable [ "nvidia" ];

    hardware.nvidia = lib.mkIf cfg.enable {
      powerManagement.enable = true;
      modesetting.enable = true;
      prime = {
        offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = lib.mkIf cfg.enable [
      nvidia-offload
    ];
  };
}

