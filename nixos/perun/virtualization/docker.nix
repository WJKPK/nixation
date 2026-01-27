{...}: {
  hardware.nvidia-container-toolkit.enable = true;
  virtualisation = {
    podman = {
      enable = true;
    };
    docker = {
      enable = true;
      enableOnBoot = true;
      daemon.settings = {
        data-root = "/vms/docker";
      };
    };
  };
}
