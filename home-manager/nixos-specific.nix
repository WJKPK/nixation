{ pkgs, ... }: {
 imports = [
    ./wallpapers
  ];

  services.syncthing = {
    enable = true;
  };

  home.packages = with pkgs; [
    firefox
    stable.pavucontrol
    mpc-cli
    brightnessctl
    pamixer
    openscad
#    cura
    unzip
    grim
    slurp
    wl-clipboard
    gparted
    transmission_3-gtk
    distrobox
  ];
}
