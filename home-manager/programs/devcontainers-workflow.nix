{pkgs, ...}:
let
  devc-nix-infect = pkgs.writeShellScriptBin "devc-nix-infect" ''
    devcontainer up --workspace-folder . && devcontainer exec --workspace-folder . -- bash -c "echo 'sandbox = false' > /tmp/nix.conf && \
        curl -L https://nixos.org/nix/install | bash -s -- --no-daemon --nix-extra-conf-file /tmp/nix.conf && \
        . \$HOME/.nix-profile/etc/profile.d/nix.sh"
  '';

  devc-shell = pkgs.writeShellScriptBin "devc-shell" ''
    devcontainer exec --workspace-folder . -- zsh -i
  '';

in {
  home.packages = [ 
    devc-nix-infect
    devc-shell
    pkgs.devcontainer
  ];
}
