{ ... }: {
  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    daemon.settings = {
      data-root = "/vms/docker";
    };
  };
}
