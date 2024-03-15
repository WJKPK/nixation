{ pkgs, ... }: {
 imports = [
    ./wallpapers
  ];

  services.syncthing = {
    enable = true;
  };

  home.packages = with pkgs; [
    unstable.firefox
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
