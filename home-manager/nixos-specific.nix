{ pkgs, ... }: {
 imports = [
    ./wallpapers
  ];

  services.syncthing = {
    enable = true;
  };

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
    wl-clipboard
    gparted
    transmission-gtk
    distrobox
  ];
}
