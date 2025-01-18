{pkgs, inputs, outputs, lib, config, ...} :
let
  udevRules = pkgs.callPackage ./udev.nix { inherit pkgs; };
in {
  imports = [
    ./nvidia-management.nix
    ./gui.nix
    ./fonts.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = [
        "electron-27.3.11" # logseq dep
      ];
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
    blueman.enable = true;
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
