{...}: let
  powermenu_config = builtins.path {
    path = ./power_style.rasi;
  };
in
{
  home.file = {
   ".config/rofi/power.sh" = {
     executable = true;
     text = ''
       #!/usr/bin/env bash
       # variables
       shutdown='󰐥'
       reboot='󰜉'
       lock=''
       suspend='󰤄'
       logout='󰍃'
       yes='󰸞'
       no='󱎘'
       
       rofi_cmd() {
         rofi -dmenu \
           -theme ${powermenu_config}
       }
       
       confirm_cmd() {
         rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
           -theme-str 'mainbox {children: [ "message", "listview" ];}' \
           -theme-str 'listview {columns: 2; lines: 1;}' \
           -theme-str 'element-text {horizontal-align: 0.5;}' \
           -theme-str 'textbox {text-color: @foreground; background-color: @background-tb; horizontal-align: 0.5;}' \
           -dmenu \
           -p 'Confirmation' \
           -mesg 'Are you sure?' \
           -theme ${powermenu_config}
       }
       
       confirm_exit() {
         echo -e "$yes\n$no" | confirm_cmd
       }
       
       run_rofi() {
         echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
       }
       
       # Execute Command
       run_cmd() {
         selected="$(confirm_exit)"
         if [[ "$selected" == "$yes" ]]; then
           if [[ $1 == '--shutdown' ]]; then
             systemctl poweroff
           elif [[ $1 == '--reboot' ]]; then
             systemctl reboot
           elif [[ $1 == '--suspend' ]]; then
             mpc -q pause
             hyprlock
             systemctl suspend
           elif [[ $1 == '--logout' ]]; then
             hyprctl dispatch exit
           elif [[ $1 == '--lock' ]]; then
             hyprlock
           fi
         else
           exit 0
         fi
       }
       
       # Actions
       chosen="$(run_rofi)"
       case "$chosen" in
       $shutdown)
         run_cmd --shutdown
         ;;
       $reboot)
         run_cmd --reboot
         ;;
       $lock)
         run_cmd --lock
         ;;
       $suspend)
         run_cmd --suspend
         ;;
       $logout)
         run_cmd --logout
         ;;
       esac
     '';
    };
  };
}

