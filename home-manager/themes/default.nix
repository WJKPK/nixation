{ pkgs, ... }: {
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
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  };
}
