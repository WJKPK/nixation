{ ... }: {
  services.adguardhome = {
    enable = true;
    port = 3000;
    settings = {
      dns = {
        upstream_dns = [
          "9.9.9.9#dns.quad9.net"
          "149.112.112.112#dns.quad9.net"
          # Uncomment the following to use a local DNS service (e.g. Unbound)
          # Additionally replace the address & port as needed
          # "127.0.0.1:5335"
        ];
      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;

        parental_enabled = false;
        safe_search = {
          enabled = false;
        };
      };
      filters = map(url: { enabled = true; url = url; }) [
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
        "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"
        "https://adaway.org/hosts.txt"
        "https://big.oisd.nl"
      ];
    };
  };
  networking.firewall = {
    allowedTCPPorts = [ 3000 ];
  };
}
