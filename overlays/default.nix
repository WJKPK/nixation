# This file defines overlays
{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  #additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  nixGL-overlay = self: super: {
    wrapWithNixGLCommand = { wrapper, package, bin_name ? package.name }:
      self.runCommand bin_name {

        buildInputs = [ self.makeWrapper ];
      } ''
        mkdir -p "$out"/bin
        cat << EOF > "$out"/bin/${bin_name}
        #!${self.bash}/bin/bash
        set -e
        nixGL="\$(NIX_PATH=nixpkgs=${inputs.nixpkgs} nix-build ${inputs.nixgl} -A ${wrapper} --no-out-link)"/bin/*
        if [ -z \''${nixGL+x} ]; then
          >&2 echo 'Failed to install nix OpenGL wrapper, trying to run ${bin_name} anyway...'
          exec -a ${bin_name} ${
            self.lib.getBin package
          }/bin/${bin_name} "\$@"
        fi
        exec -a ${bin_name} \$nixGL ${
          self.lib.getBin package
        }/bin/${bin_name} "\$@"
        EOF
        chmod +x "$out"/bin/${bin_name}
      '';

    wrapWithNixGL = package:
      let
        wrappers = {
          "nvidia" = "nixGLNvidia";
          "nvidia-bumblebee" = "nixGLNvidiaBumblebee";
          "nvidia-vulkan" = "nixVulkanNvidia";
          "intel" = "nixGLIntel";
          "intel-vulkan" = "nixVulkanIntel";
        };
      in self.lib.mapAttrs' (n: v:
        self.lib.nameValuePair "${package.name}-${n}"
        (self.wrapWithNixGLCommand {
          inherit package;
          wrapper = v;
        })) wrappers;
  };
}
