{ pkgs, config, ... }: {
	home.file.".config/rofi/config.rasi" = {
		source = ./config.rasi;
	};

	home.file.".local/share/rofi/themes/theme.rasi" = {
      text = ''
        * {
            bg-col:  #${config.colorScheme.palette.base00};
            bg-col-light: #${config.colorScheme.palette.base00};
            border-col: #${config.colorScheme.palette.base01};
            selected-col: #${config.colorScheme.palette.base01};
            blue: #${config.colorScheme.palette.base0D};
            fg-col: #${config.colorScheme.palette.base0F};
            fg-col2: #${config.colorScheme.palette.base0F};
            grey: #${config.colorScheme.palette.base04};
        
            width: 900;
            font: "JetBrainsMono Nerd Font 10";
        }
        
        element-text, element-icon , mode-switcher {
            background-color: inherit;
            text-color:       inherit;
        }
        
        window {
            height: 560px;
            border: 3px;
            border-radius: 10px;
            border-color: @border-col;
            background-color: @bg-col;
        }
        
        mainbox {
            background-color: @bg-col;
        }
        
        inputbar {
            children: [prompt,entry];
            background-color: @bg-col;
            border-radius: 5px;
            padding: 2px;
        }
        
        prompt {
            background-color: @blue;
            padding: 6px;
            text-color: @bg-col;
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
            text-color: @fg-col;
            background-color: @bg-col;
        }
        
        listview {
            border: 0px 0px 0px;
            padding: 8px;
            border-radius: 0px 0px 15px 15px;
            padding: 6px 0px 0px;
            margin: 10px 0px 0px 20px;
            columns: 2;
            lines: 5;
            background-color: @bg-col;
        }
        
        element {
            padding: 5px;
            background-color: @bg-col;
            text-color: @fg-col  ;
        }
        
        element-icon {
            size: 25px;
        }
        
        element selected {
            background-color:  @selected-col;
            text-color: @fg-col2;
            border-radius: 10px;
        }
        
        mode-switcher {
            spacing: 0;
          }
        
        button {
            padding: 10px;
            background-color: @bg-col-light;
            text-color: @grey;
            vertical-align: 0.5; 
            horizontal-align: 0.5;
        }
        
        button selected {
          background-color: @bg-col;
          text-color: @blue;
        }
        
        message {
            background-color: @bg-col-light;
            margin: 2px;
            padding: 2px;
            border-radius: 5px;
        }
        
        textbox {
            padding: 6px;
            margin: 20px 0px 0px 20px;
            text-color: @blue;
            background-color: @bg-col-light;
        }
      '';
	};

	home.packages = with pkgs; [
		rofi-wayland
	];
}
