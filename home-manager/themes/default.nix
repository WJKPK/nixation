{pkgs, ...}: {
  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 12;
  };
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "macchiato";
        accent = "maroon";
      };
      name = "Papirus-Dark";
    };
    colorScheme = "dark";
    gtk2.extraConfig = ''
      gtk-cursor-theme-size = 12
      gtk-cursor-theme-name = "capitaine-cursors"
    '';
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-cursor-theme-size = 12;
      gtk-cursor-theme-name = "capitaine-cursors";
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
}
