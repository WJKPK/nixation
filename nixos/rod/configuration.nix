{ pkgs, inputs, outputs, ... }: {
  imports = [
    ../common
    ./home-assistant.nix
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; isNixos = true; };
    users.kruppenfield = import ../../home-manager/rod.nix;
  };

  users.users.kruppenfield = {
    extraGroups = [ "docker" "networkmanager" "wheel" "libvirtd" ];
  };

  networking = {
    hostName = "rod";
    dhcpcd.denyInterfaces = [ "macvtap*" ];
  };

  boot.kernelPackages = pkgs.linuxPackages;
  nvidiaManagement = {
      driver.enable = false;
  };

  environment.systemPackages = with pkgs; [
    docker-compose  
  ];
}
