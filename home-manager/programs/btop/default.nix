{config, ...} : {
  programs.btop = {
      enable = true;
      settings.color_theme = "theme";
  };
  home.file = {
    ".config/btop/themes/theme.theme" = {
      text = ''
        theme[main_bg]="#${config.colorScheme.palette.base00}"
        theme[main_fg]="#${config.colorScheme.palette.base05}"
        theme[title]="#${config.colorScheme.palette.base05}"
        theme[hi_fg]="#${config.colorScheme.palette.base0D}"
        theme[selected_bg]="#${config.colorScheme.palette.base02}"
        theme[selected_fg]="#${config.colorScheme.palette.base0D}"
        theme[inactive_fg]="#${config.colorScheme.palette.base03}"
        theme[graph_text]="#${config.colorScheme.palette.base0A}"
        theme[meter_bg]="#${config.colorScheme.palette.base02}"
        theme[proc_misc]="#${config.colorScheme.palette.base0A}"
        theme[cpu_box]="#${config.colorScheme.palette.base0C}"
        theme[mem_box]="#${config.colorScheme.palette.base0B}"
        theme[net_box]="#${config.colorScheme.palette.base0E}"
        theme[proc_box]="#${config.colorScheme.palette.base0F}"
        theme[div_line]="#${config.colorScheme.palette.base04}"
        theme[temp_start]="#${config.colorScheme.palette.base0A}"
        theme[temp_mid]="#${config.colorScheme.palette.base09}"
        theme[temp_end]="#${config.colorScheme.palette.base08}"
        theme[cpu_start]="#${config.colorScheme.palette.base0C}"
        theme[cpu_mid]="#${config.colorScheme.palette.base0C}"
        theme[cpu_end]="#${config.colorScheme.palette.base0B}"
        theme[free_start]="#${config.colorScheme.palette.base0B}"
        theme[free_mid]="#${config.colorScheme.palette.base0B}"
        theme[free_end]="#${config.colorScheme.palette.base0B}"
        theme[cached_start]="#${config.colorScheme.palette.base0F}"
        theme[cached_mid]="#${config.colorScheme.palette.base0F}"
        theme[cached_end]="#${config.colorScheme.palette.base0E}"
        theme[available_start]="#${config.colorScheme.palette.base0A}"
        theme[available_mid]="#${config.colorScheme.palette.base0F}"
        theme[available_end]="#${config.colorScheme.palette.base0F}"
        theme[used_start]="#${config.colorScheme.palette.base09}"
        theme[used_mid]="#${config.colorScheme.palette.base09}"
        theme[used_end]="#${config.colorScheme.palette.base08}"
        theme[download_start]="#${config.colorScheme.palette.base07}"
        theme[download_mid]="#${config.colorScheme.palette.base07}"
        theme[download_end]="#${config.colorScheme.palette.base0E}"
        theme[upload_start]="#${config.colorScheme.palette.base07}"
        theme[upload_mid]="#${config.colorScheme.palette.base07}"
        theme[upload_end]="#${config.colorScheme.palette.base0E}"
        theme[process_start]="#${config.colorScheme.palette.base0C}"
        theme[process_mid]="#${config.colorScheme.palette.base0C}"
        theme[process_end]="#${config.colorScheme.palette.base0B}"
      '';
    };
  };
}

