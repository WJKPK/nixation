{pkgs, ...}:
let
  start-devcontainer = pkgs.writeShellScriptBin "start-devcontainer" ''
    WORKSPACE_DIR="''${1:-.}"
    ${pkgs.devcontainer}/bin/devcontainer up \
      --remove-existing-container \
      --mount "type=bind,source=/tmp/.X11-unix,target=/tmp/.X11-unix" \
      --workspace-folder "$WORKSPACE_DIR"
  '';

setup-devcontainer = pkgs.writeShellScriptBin "setup-devcontainer" ''
    WORKING_DIR="''${1:-.}"
    CONTAINER_USER="''${2:-vscode}"
    
    echo "Setting up environment in: $WORKING_DIR"
    echo "Using container user: $CONTAINER_USER"

    # Install system dependencies
    ${pkgs.devcontainer}/bin/devcontainer exec \
      --workspace-folder "$WORKING_DIR" \
      bash -c "sudo apt update && sudo apt install -y xclip curl git"

    # Install Nix
    ${pkgs.devcontainer}/bin/devcontainer exec \
      --workspace-folder "$WORKING_DIR" \
      bash -c "command -v nix >/dev/null 2>&1 && echo 'Nix is already installed' || { echo 'Installing Nix...' && curl -L https://nixos.org/nix/install | sh -s -- --no-daemon --nix-extra-conf-file <(echo 'sandbox = false') && . $HOME/.nix-profile/etc/profile.d/nix.sh; }"

    # Install home-manager
    ${pkgs.devcontainer}/bin/devcontainer exec \
      --workspace-folder "$WORKING_DIR" \
      bash -c "command -v home-manager >/dev/null 2>&1 && echo 'home-manager is already installed' || { echo 'Installing home-manager...' && nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager && nix-channel --update && nix-shell '<home-manager>' -A install; }"

    echo "Apply personal configuration"
    ${pkgs.devcontainer}/bin/devcontainer exec \
      --workspace-folder "$WORKING_DIR" \
      bash -c "[ -d 'nixation' ] && (cd nixation && git pull --ff-only) || git clone https://github.com/WJKPK/nixation && \
      cd nixation && home-manager switch --flake .#minimal-nvim --extra-experimental-features 'nix-command flakes' && \
      cd -- && rm -rf nixation"
  '';

  shell-devcontainer = pkgs.writeShellScriptBin "shell-devcontainer" ''
      ${pkgs.devcontainer}/bin/devcontainer exec --workspace-folder . --remote-env DISPLAY=$DISPLAY bash -i
  '';

in {
  home.packages = [ 
    start-devcontainer
    setup-devcontainer
    shell-devcontainer
    pkgs.devcontainer
    ];
}
