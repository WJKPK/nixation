{ pkgs, ... }: {
  services.syncthing = {
    enable = true;
  };

  home.packages = with pkgs; [
    stable.firefox-esr
    pavucontrol
    pwvucontrol
    brightnessctl
    pamixer
    openscad
    prusa-slicer
    unzip
    grim
    slurp
    wl-clipboard
    transmission_3-gtk
    distrobox
    procps
    hyprshot
    satty
  ];
}
