{pkgs, inputs, outputs, lib, config, ...} :
let
  udevRules = pkgs.callPackage ./udev.nix { inherit pkgs; };
in { nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.stable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = { "vm.swappiness" = 5;};
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };
  };

  users.groups.plugdev = { };
  users.groups.spice = { };
  users.users.kruppenfield = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "kruppenfield";
    extraGroups = [ "networkmanager" "wheel" "dialout" "plugdev" "spice" ];
  };

  environment.systemPackages = with pkgs; [
    man
    vim
    wget
    usbutils
    pciutils
    coreutils
    polkit_gnome
    gawk
    home-manager
    libsForQt5.kdeconnect-kde
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
  ];

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  hardware.graphics = {
    enable = true;  
    enable32Bit = true;
  };

  programs = {
    dconf.enable = lib.mkDefault true;
    zsh.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
    };
    kdeconnect.enable = true;
    xfconf.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      xdg-desktop-portal-kde
    ];
  };

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
  };

#  services.mpd = {
#    enable = true;
#    user = "kruppenfield";
#    inherit musicDirectory;
#
#    extraConfig = ''
#      audio_output {
#        type "pipewire"
#        name "MPD PipeWire Output"
#      }
#    '';
#  };
#  systemd.services.mpd = {
#    environment = {
#      # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
#      XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.kruppenfield.uid}"; # User-id must match above user. MPD will look inside this directory for the PipeWire socket.
#    };
#    serviceConfig.SupplementaryGroups = [ "pipewire" ];
#  };

  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "${import ./sddm-theme.nix { inherit pkgs; }}";
    };
    xserver = {
      enable = true;
      xkb = {
        layout = "pl";
        variant = "";
      };
    };
    flatpak.enable = true;

    udev.packages = [ udevRules ];

    blueman.enable = true;
    printing.enable = true;
    gvfs.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };

  console.keyMap = "pl2";

  security = {
    rtkit.enable = true;
    pam.services = {
    };
    polkit.enable = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
