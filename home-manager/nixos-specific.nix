{ pkgs, ... }: {
 imports = [
    ./wallpapers
  ];

  services.syncthing = {
    enable = true;
  };

  home.packages = with pkgs; [
    stable.firefox-esr
    pavucontrol
    pwvucontrol
    mpc-cli
    brightnessctl
    pamixer
    openscad
#    cura
    prusa-slicer
    unzip
    grim
    slurp
    wl-clipboard
    gparted
    transmission_3-gtk
    distrobox
    procps
    hyprshot
    satty
  ];
}
