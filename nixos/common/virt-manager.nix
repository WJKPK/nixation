{ pkgs, ... }: {
  virtualisation.libvirtd.enable = true;
  programs.dconf = {
    enable = true; # virt-manager requires dconf to remember settings
  };
  environment.systemPackages = with pkgs; [ virt-manager spice-gtk spice-vdagent ];
  virtualisation.spiceUSBRedirection.enable = true;
  # after 23.11
  # virtualisation.libvirtd.enable = true;
  # programs.virt-manager.enable = true;
}
