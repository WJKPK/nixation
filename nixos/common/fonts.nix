{pkgs, ...}: {
  fonts.enableDefaultPackages = true;
  fonts.fontDir.enable = true;

  fonts.fontconfig = {
    enable = true;
    includeUserConf = true;

    defaultFonts = {
      monospace = ["Jetbrains Mono Nerd Fonts" "Iosevka" "Source Code Pro"];
      sansSerif = ["Source Sans Pro" "Noto Sans"];
      serif = ["Source Serif Pro" "Noto Serif"];
      emoji = ["Noto Color Emoji"];
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    jetbrains-mono
    iosevka
    monaspace
    cascadia-code

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-lgc-plus
    noto-fonts-color-emoji
    noto-fonts-emoji-blob-bin

    source-code-pro
    source-sans-pro
    source-han-sans
    source-serif-pro
    source-han-serif
    source-han-mono

    stix-two
    xits-math
  ];
}
