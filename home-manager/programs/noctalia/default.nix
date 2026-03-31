{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.desktop.environment.noctalia;
  wallpaperDir = builtins.path {
    path = ../../wallpapers;
  };
  tortoise = builtins.path {
    path = ../../wallpapers/tortoise.jpg;
  };
in {
  options.desktop.environment.noctalia = with types; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Noctalia.";
    };
  };
  config = mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;
      package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.override {calendarSupport = true;};
      plugins = {
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];
        states = lib.listToAttrs (map (plugin:
            lib.nameValuePair plugin {
              enabled = true;
              sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
            })
          [
            "screen-recorder"
            "privacy-indicator"
            "weekly-calendar"
            "network-manager-vpn"
          ]);
      };
      pluginSettings = {
        privacy-indicator = {
          hideInactive = false;
        };
        screen-recorder = {
          hideInactive = false;
          filenamePattern = "recording_yyyyMMdd_HHmmss";
          frameRate = "60";
          audioCodec = "opus";
          videoCodec = "h264";
          quality = "very_high";
          showCursor = true;
          copyToClipboard = true;
          audioSource = "default_output";
          videoSource = "portal";
          resolution = "original";
        };
      };
      settings = {
        audio = {
          preferredPlayer = "kew";
        };
        ui = {
          fontDefault = "JetBrainsMono Nerd Font Mono";
          fontFixed = "JetBrainsMono Nerd Font Mono";
        };
        location = {
          name = "Wroclaw, Poland";
        };
        colorSchemes = {
          useWallpaperColors = true;
          generationMethod = "muted";
        };
        templates = {
          activeTemplates = [
            "gtk"
            "qt6ct"
            "niri"
          ];
        };
        wallpaper = {
          enabled = true;
          directory = wallpaperDir;
        };
        nightLight = {
          enabled = true;
          nightTemp = "4000";
          dayTemp = "6500";
          manualSunrise = "07:00";
          manualSunset = "19:45";
        };
        dock = {
          enabled = false;
        };
        idle = {
          enabled = true; #currently swayidle is more reliable
          lockTimeout = 360;
          screenOffTimeout = 380;
          suspendTimeout = 400;
          fadeDuration = 2;
          suspendCommand = ''
            ${pkgs.procps}/bin/pgrep qemu ||
            noctalia-shell ipc call sessionMenu lockAndSuspend
          '';
        };
        general = {
          radiusRatio = 0.5;
          iRadiusRatio = 0.5;
          boxRadiusRatio = 0.5;
          screenRadiusRatio = 0.5;
          avatarImage = tortoise;
          lockOnSuspend = true;
        };
        bar = {
          marginHorizontal = 5;
          marginVertical = 5;
          outerCorners = false;
          showOutline = false;
          density = "comfortable";
          useSeparateOpacity = true;
          backgroundOpacity = 0.2;

          widgets = {
            center = [
              {
                id = "Workspace";
                characterCount = 16;
                colorizeIcons = false;
                enableScrollWheel = true;
                followFocusedScreen = false;
                groupedBorderOpacity = 1;
                hideUnoccupied = false;
                iconScale = 0.8;
                labelMode = "name";
                showApplications = true;
                showLabelsOnlyWhenOccupied = false;
                unfocusedIconsOpacity = 1;
              }
            ];

            left = [
              {
                id = "Clock";
                customFont = "";
                formatHorizontal = "HH:mm ddd, MMM dd";
                useCustomFont = false;
              }
              {
                id = "plugin:weekly-calendar";
              }
              {
                id = "SystemMonitor";
                compactMode = false;
                diskPath = "/";
                showCpuTemp = true;
                showCpuUsage = true;
                showDiskUsage = true;
                showGpuTemp = false;
                showLoadAverage = false;
                showMemoryAsPercent = false;
                showMemoryUsage = true;
                showNetworkStats = false;
                useMonospaceFont = true;
                usePrimaryColor = false;
              }
              {
                id = "AudioVisualizer";
              }
            ];

            right = [
              {
                id = "ActiveWindow";
                colorizeIcons = false;
                hideMode = "hidden";
                maxWidth = 145;
                scrollingMode = "hover";
                showIcon = true;
                useFixedWidth = false;
              }
              {
                id = "plugin:privacy-indicator";
              }
              {
                id = "plugin:screen-recorder";
              }
              {
                id = "Network";
                displayMode = "alwaysShow";
              }
              {
                id = "plugin:network-manager-vpn";
              }
              {
                id = "Bluetooth";
                displayMode = "alwaysShow";
              }
              {
                id = "Volume";
                displayMode = "alwaysShow";
              }
              {
                id = "Battery";
                displayMode = "alwaysShow";
                hideIfNotDetected = true;
                showNoctaliaPerformance = false;
                showPowerProfiles = true;
                warningThreshold = 30;
              }
              {
                id = "ControlCenter";
                colorizeDistroLogo = false;
                colorizeSystemIcon = "none";
                enableColorization = true;
                useDistroLogo = true;
              }
            ];
          };
        };
      };
    };
  };
}
