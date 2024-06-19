{ ... }: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    enableNvidia = true;
    daemon.settings = {
      data-root = "/vms/docker";
    };
  };

  # libnvidia-container does not support cgroups v2 (prior to 1.8.0)
  # https://github.com/NVIDIA/nvidia-docker/issues/1447
  systemd.enableUnifiedCgroupHierarchy = false;
}
