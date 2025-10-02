{pkgs, ...}:
let
  devc-nix-infect = pkgs.writeShellScriptBin "devc-nix-infect" ''
    set -euo pipefail
    
    echo "Starting DevContainer..."
    devcontainer up --workspace-folder . || {
      echo "Error: Failed to start DevContainer" >&2
      exit 1
    }
    
    echo "Installing Nix in DevContainer..."
    devcontainer exec --workspace-folder . -- bash -c '
      set -euo pipefail
      
      # Check if already installed
      if [ -d /nix/store ]; then
        echo "✓ Nix already installed"
        exit 0
      fi
      
      # Configure Nix
      mkdir -p "$HOME/.config/nix"
      cat > "$HOME/.config/nix/nix.conf" <<EOF
  sandbox = false
  experimental-features = nix-command flakes
  EOF
      
      # Install Nix
      curl -L https://nixos.org/nix/install | sh -s -- --no-daemon \
        --nix-extra-conf-file "$HOME/.config/nix/nix.conf" || {
        echo "✗ Nix installation failed" >&2
        exit 1
      }
      
      # Load Nix environment
      [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] || {
        echo "✗ Nix profile script not found" >&2
        exit 1
      }
      
      . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      echo "✓ Nix installed ($(nix --version))"
    '
    
    echo "✓ DevContainer ready"
  '';
  devc-shell = pkgs.writeShellScriptBin "devc-shell" ''
    devcontainer exec --workspace-folder . -- sh -c 'zsh -i || bash -i' -c '. $HOME/.nix-profile/etc/profile.d/nix.sh && . $HOME/.nix-profile/etc/profile.d/nix-daemon.sh'
  '';

in {
  home.packages = [ 
    devc-nix-infect
    devc-shell
    pkgs.devcontainer
  ];
}
