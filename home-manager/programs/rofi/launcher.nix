{ config, ...} : {
  home.file = {
  ".config/rofi/config.rasi" = {
    text = ''
      configuration{
        modes: "window,drun,combi";
        combi-modes: "window,drun";
        show-icons: true;
        terminal: "kitty";
        drun-display-format: "{icon} {name}";
        combi-display-format: "{mode} {text}";
        location: 0;
        disable-history: false;
        hide-scrollbar: true;
        display-drun: "   Apps ";
        display-run: "   Run ";
        display-window: " 󰕰  Window";
        display-combi: " ⚡︎ Combi";
        display-Network: " 󰤨  Network";
        sidebar-mode: true;
      }
      
      @theme "theme"
      
      element-text, element-icon , mode-switcher {
          background-color: inherit;
          text-color:       inherit;
      }
      
      window {
          height: ${toString config.rofi_settings.launcher_height}px;
          border: 2px;
          border-radius: 10px;
          border-color: @border-tb;
          background-color: @background;
          padding: 25px;
      }
      
      mainbox {
          background-color: @background;
      }
      
      inputbar {
          children: [prompt,entry];
          background-color: @background;
          border-radius: 5px;
          padding: 2px;
      }
      
      prompt {
          background-color: @accent;
          padding: 6px;
          text-color: @background;
          border-radius: 3px;
          margin: 20px 0px 0px 20px;
      }
      
      textbox-prompt-colon {
          expand: false;
          str: ":";
      }
      
      entry {
          padding: 6px;
          margin: 20px 0px 0px 10px;
          text-color: @foreground;
          background-color: @background;
      }
      
      listview {
          border: 0px 0px 0px;
          padding: 8px;
          border-radius: 0px 0px 15px 15px;
          padding: 6px 0px 0px;
          margin: 10px 0px 0px 20px;
          columns: 2;
          lines: 5;
          background-color: @background;
      }
      
      element {
          padding: 5px;
          background-color: @background;
          text-color: @foreground;
      }
      
      element-icon {
          size: 25px;
      }
      
      element selected {
          background-color:  @selected;
          text-color: @foreground;
          border-radius: 10px;
          border-color: @border-tb;
          border: 2px;
      }
      
      mode-switcher {
          spacing: 0;
        }
      
      button {
          padding: 10px;
          background-color: @background-tb;
          text-color: @foreground;
          vertical-align: 0.5; 
          horizontal-align: 0.5;
      }
      
      button selected {
        background-color: @background;
        text-color: @accent;
      }
      
      message {
          background-color: @background-tb;
          margin: 2px;
          padding: 2px;
          border-radius: 5px;
      }
      
      textbox {
          padding: 6px;
          margin: 20px 0px 0px 20px;
          text-color: @accent;
          background-color: @background-tb;
      }
      
    '';
    };
  };
}

