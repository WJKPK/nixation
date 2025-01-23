{ ... }: {
  services.immich = {
      enable = true;
      port = 2283;
      database.enable = true;
      redis.enable = true;
      machine-learning.enable = true;
      machine-learning.environment = { };
      host = "0.0.0.0";
#     mediaLocation = "";
  };
  users.users.immich.extraGroups = [ "video" "render" ];

  networking.firewall = {
    allowedTCPPorts = [ 2283 ];
  };
}
