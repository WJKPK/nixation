{ pkgs, ... }: rec {
  qt.style.catppuccin = {
    enable = true;
    accent = "lavender";
    apply = true;
  };
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 20;
  };
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "frappe";
        accent = "lavender";
      };
      name = "Papirus-Dark";
    };
    theme = {
      name = "Catppuccin-Frappe-Compact-Flamingo-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "flamingo" ];
        size = "compact";
        variant = "frappe";
      };
    };
    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = true;
    '';
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
  home.sessionVariables.GTK_THEME = gtk.theme.name;
}
