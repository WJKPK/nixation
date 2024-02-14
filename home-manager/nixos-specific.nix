{ pkgs, ... }: {
 imports = [
    ./wallpapers
  ];

  home.packages = with pkgs; [
    firefox
    pavucontrol
    mpc-cli
    brightnessctl
    pamixer
    openscad
    cura
    unzip
    grim
    slurp
    gparted
    transmission-gtk
    distrobox
  ];
}
