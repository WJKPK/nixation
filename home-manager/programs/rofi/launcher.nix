{ config, ...} : {
  home.file = {
  ".config/rofi/config.rasi" = {
    text = ''
      configuration{
        font: "JetBrainsMono Nerd Font 14";
        modes: "combi";
        combi-modes: "window,drun";
        show-icons: true;
        terminal: "kitty";
        drun-display-format: "{icon} {name}";
        combi-display-format: "{mode} {text}";
        location: 0;
        disable-history: false;
        hide-scrollbar: true;
        display-drun: "   Apps ";
        display-window: " 󰕰  Window";
        display-combi: " ⚡︎ Combi";
      }
      
      @theme "theme"
      
      element-text, element-icon , mode-switcher {
          background-color: inherit;
          text-color:       inherit;
      }
      
      window {
          transparency: "background";
          height: ${toString config.rofi_settings.launcher_height}px;
          width: ${toString config.rofi_settings.launcher_width}px;
          border: 2px;
          border-radius: 0px;
          border-color: @accent;
          background-color: @background;
          padding: 5px;
      }
      
      mainbox {
          background-color: @background;
      }
      
      inputbar {
          children: [prompt,entry];
          background-color: @background;
          border-radius: 0px;
          padding: 8px;
      }
      
      prompt {
          background-color: @foreground;
          padding: 6px;
          text-color: @background;
          border-radius: 3px;
          margin: 6px 0px 0px 6px;
      }
      
      textbox-prompt-colon {
          expand: false;
          str: ":";
      }
      
      entry {
          padding: 2px;
          placeholder: "Search...";
          margin: 10px 0px 0px 10px;
          text-color: @foreground;
          background-color: @background;
      }
      
      listview {
          border: 0px 0px 0px;
          padding: 8px;
          border-radius: 0px 0px 0px 0px;
          padding: 6px 0px 0px;
          margin: 10px 0px 0px 20px;
          columns: 2;
          lines: 5;
          background-color: @background;
      }
      
      element {
          padding: 3px;
          background-color: @background;
          text-color: @foreground;
      }
      
      element-icon {
          size: 30px;
      }
      
      element selected {
          text-color: @selected;
          background-color: @foreground;
          border-radius: 2px;
      }
    '';
    };
  };
}

