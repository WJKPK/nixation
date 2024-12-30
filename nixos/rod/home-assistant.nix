{ ... }: {
  services.home-assistant = {
     enable = true;
     openFirewall = true;
     extraComponents = [
       # List of components required to complete the onboarding
       "default_config"
       "met"
       "esphome"
       "radio_browser"
     ];
     config = {
       default_config = { };
     };
   };

   networking.firewall = {
     allowedTCPPorts = [ 8123 ];
   };
}
