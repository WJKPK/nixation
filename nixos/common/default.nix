{pkgs, inputs, outputs, lib, config, ...} :
let
  udevRules = pkgs.callPackage ./udev.nix { inherit pkgs; };
in {
  imports = [
    ./nvidia-management.nix
    ./nvidia-undervolt.nix
    ./gui.nix
    ./fonts.nix
    ./wireless.nix
    ./ai.nix
    ./monitors.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
      inputs.nur.overlays.default
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = [
        "segger-jlink-qt4-796s"
        "segger-jlink-qt4-810"
      ];
      segger-jlink.acceptLicense = true;
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
      trusted-users = [
        "root" "kruppenfield"
      ];
      trusted-substituters = [ "http://rod" ];
      substituters = [ 
        "https://cuda-maintainers.cachix.org"
      ];
      trusted-public-keys = [
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "rod-1:X4DIb22/yZroa+tm0DLZgtgq2EEBhm28EtrwbHUxT+0="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  users = {
    groups = {
      plugdev = { };
      spice = { };
    };
    users.kruppenfield = {
      isNormalUser = true;
      shell = pkgs.zsh;
      description = "kruppenfield";
      extraGroups = [ "networkmanager" "wheel" "dialout" "plugdev" "spice" ];
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  boot = {
    loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = { "vm.swappiness" = 5;};
  };

  environment.systemPackages = with pkgs; [
    man
    vim
    wget
    usbutils
    pciutils
    coreutils
    gawk
    git
  ];

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";
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
  };

  services = {
    udev.packages = [ udevRules ];
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  console.keyMap = "pl2";
}
