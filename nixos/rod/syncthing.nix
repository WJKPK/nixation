{...}: {
  services = {
    syncthing = {
      enable = true;
      user = "kruppenfield";
      configDir = "/home/kruppenfield/.config/syncthing";
      overrideDevices = false; # overrides any devices added or deleted through the WebUI
      overrideFolders = true; # overrides any folders added or deleted through the WebUI
      guiAddress = "0.0.0.0:8384";
      settings.folders = {
        gosia_phone = {
          path = "/md0/photos/photos/Gosia_redmi8t/Camera";
          type = "receiveonly";
        };
        wojtek_phone = {
          path = "/md0/photos/photos/Telefon_Wojtek";
          type = "receiveonly";
        };
      };
    };
  };
  networking.firewall.allowedTCPPorts = [8384 22000];
  networking.firewall.allowedUDPPorts = [22000 21027];
}
