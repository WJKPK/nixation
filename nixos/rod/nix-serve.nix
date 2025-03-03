# Run on destination nixos installation
# export DIR_NIXSERVE=/home/kruppenfield/nix-serve
# mkdir -p $DIR_NIXSERVE && cd $DIR_NIXSERVE
# nix-store --generate-binary-cache-key $(hostname).$(hostname -d) cache-priv-key.pem cache-pub-key.pem
#
# curl localhost:5050/nix-cache-info
{ pkgs, ...}:
let
    serve_port = 5050;
in {
  services = {
    nix-serve = {
      enable = true;
      secretKeyFile = "/home/kruppenfield/nix-serve/cache-priv-key.pem";
      package = pkgs.nix-serve-ng;
      port = serve_port;
    };
  };
  networking.firewall = {
    allowedTCPPorts = [ serve_port ];
  };
}

