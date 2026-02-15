{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.rod.services.homeAssistant;
  hashedPassword = "$7$101$Mq/uMfhrXi1kUnUm$EplnirSvU7VEv5LonBkOcIaGYJcsMUk79i5e0A6AJeDzETCOn3xdEFlQ6/xpT6g9OZYqdv7ysrq8ZBSAV2ufvg==";
in {
  options.rod.services.homeAssistant.enable = mkEnableOption "Enable Home Assistant stack";

  config = mkIf cfg.enable {
    services.home-assistant = {
      enable = true;
      openFirewall = true;
      extraComponents = [
        "default_config"
        "met"
        "esphome"
        "radio_browser"
        "mqtt"
        "lovelace"
        "zha"
      ];
      config = {
        default_config = {};
        "automation ui" = "!include automations.yaml";
      };
      customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [apexcharts-card];
    };

    services.zigbee2mqtt = {
      enable = true;
      settings = {
        homeassistant = lib.mkOverride 1000 config.services.home-assistant.enable;
        serial = {
          adapter = "ember";
          port = "/dev/ttyUSB0";
        };
        mqtt = {
          server = "mqtt://localhost:1883";
          user = "zigbee2mqtt";
          password = "!/etc/systemd/zigbee2mqtt.yaml password";
        };
        frontend = {
          enable = true;
          address = "0.0.0.0";
          port = 8072;
        };
        advanced.log_level = "info";
      };
    };

    systemd.services."zigbee2mqtt.service".requires = ["mosquitto.service"];
    systemd.services."zigbee2mqtt.service".after = ["mosquitto.service"];

    services.mosquitto = {
      enable = true;
      persistence = true;
      listeners = [
        {
          users = {
            zigbee2mqtt = {
              acl = ["readwrite #"];
              hashedPassword = hashedPassword;
            };
            home_assistant = {
              acl = ["readwrite #"];
              hashedPassword = hashedPassword;
            };
          };
          settings.allow_anonymous = false;
        }
      ];
    };

    networking.firewall.allowedTCPPorts = [8072 1883 8123];
  };
}
