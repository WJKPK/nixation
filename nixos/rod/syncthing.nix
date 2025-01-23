{ ... }: {
  services = {
    syncthing = {
      enable = true;
      user = "kruppenfield";
      configDir = "/home/kruppenfield/.config/syncthing";
      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      overrideFolders = true; # overrides any folders added or deleted through the WebUI
      guiAddress = "0.0.0.0:8384";
      settings.folders = {
        photos = {
          path = "/md0/photos/photos/RX100";
          type = "receiveonly";
        };
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}
