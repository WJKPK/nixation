{ pkgs, ... }: {
  programs = {
    kitty = {
      enable = true;
      font = {
        name = "jetbrains mono nerd font";
        size = 12;
      };
      environment = { };
      keybindings = { };
      settings = {
        shell = "zsh";
        scrollback_lines = 10000;
        enable_audio_bell = false;
      };
      extraConfig = ''
        include theme.conf
      '';
    };
  };
  home.shellAliases = {
    ls = "eza --icons=always";
    ll="eza -l --icons=always --smart-group -F";
    nix-shell = "nix-shell --command zsh";
    nd = "nix develop --command zsh";
    ns = "nix shell --command zsh";
  };

  xdg.configFile."kitty/theme.conf".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/kitty/main/themes/frappe.conf";
    hash = "sha256-QVIxEu76Wuc3iAOr84dTVCgfV/88dOJ2ylo8yQZ7N6Y=";
  };
}
