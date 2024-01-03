{ pkgs, ... }: {
  gtk = {
    enable = true;
    iconTheme = {
      name = "Catppuccin-Frappe-Standard-Flamingo-Dark";
      package = pkgs.catppuccin-gtk.override {
        variant = "frappe";
        accents = [ "flamingo" ];
      };
    };
    theme = {
      name = "Catppuccin-Frappe-Standard-Flamingo-Dark";
      package = pkgs.catppuccin-gtk.override {
        variant = "frappe";
        accents = [ "flamingo" ];
      };
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  };
}
