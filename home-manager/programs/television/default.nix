{ pkgs, inputs, ... }: {
  programs.bat.enable = true;
  programs.television = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      ui = {
        theme = "gruvbox-dark";
        use_nerd_font_icons = true;
        show_preview_panel = false;
      };
      keybindings = {
        esc = "quit";
        ctrl-c = "quit";
      };
      shell-integration = {
        fallback_channel = "files";
        channel_triggers = {
          "env" = ["export" "unset"];
          "dirs" = ["cd" "ls" "rmdir"];
          "files" = ["mv" "cp" "nvim"];
          "docker-images" = ["docker run"];
        };
      };
    };
    channels = {
      files = {
        metadata = {
          name = "files";
          description = "A channel to select files and directories";
          requirements = [
            "fd"
            "bat"
          ];
        };
        source = {
          command = [
            "fd -t f"
            "fd -t f -H"
          ];
        };
        preview = {
          command = "bat -n --color=always '{}'";
          env = {
            BAT_THEME = "ansi";
          };
        };
        keybindings = {
          shortcut = "f1";
          f12 = "actions:edit";
        };
        actions = {
          edit = {
            description = "Opens the selected entries with the default editor (falls back to vim)";
            command = "${inputs.lavix.packages.${pkgs.system}.default}/bin/nvim {}";
            mode = "execute";
          };
        };
      };
      docker = {
        metadata = {
          name = "docker";
          description = "A channel to list Docker containers";
          requirements = [
            "docker"
            "jq"
          ];
        };
        source = {
          command = "docker ps -a --format \"{{.ID}} {{.Names}} {{.Status}} {{.Image}}\"";
        };
        preview = {
          command = "docker inspect {0} | jq '.[0]' 2>/dev/null || echo \"Container not found\"";
        };
      };
      docker-images = {
        metadata = {
          name = "docker-images";
          description = "A channel to select from Docker images";
          requirements = [
            "docker"
            "jq"
          ];
        };
      
        source = {
          command = "docker images --format \"{{.Repository}}:{{.Tag}} {{.ID}}\"";
          # original output = "{split: :-1}"
          output = "{ split: :-1; }";
        };
      
        preview = {
          command = "docker image inspect '{split: :-1}' | jq -C";
        };
      };
      nix = {
        metadata = {
          name = "nix";
          description = "A channel to list installed Nix packages";
          requirements = [
            "nix"
          ];
        };
        source = {
          command = ''
            {
              # Get system packages
              nix-store --query --requisites /run/current-system 2>/dev/null | 
                sed -E 's|/nix/store/[^-]+-||' | 
                grep -vE '\.(patch|tar\.|zip|gz|bz2|xz)$|source$|\.drv$' | 
                sort | uniq
              
              # Get home-manager packages if profile exists
              if [[ -L "$HOME/.nix-profile" ]]; then
                nix-store --query --requisites "$HOME/.nix-profile" 2>/dev/null | 
                  sed -E 's|/nix/store/[^-]+-||' | 
                  grep -vE '\.(patch|tar\.|zip|gz|bz2|xz)$|source$|\.drv$' | 
                  sort | uniq
              fi
            } | sort | uniq | grep -v '^$'
          '';
        };
        preview = {
          command = ''
            echo "📦 Package: {}"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo ""

            # Try to get package info from different sources
            echo "🔍 Searching package information..."
            echo ""

            # Search in nixpkgs
            nix search nixpkgs#{} 2>/dev/null | head -10 || \
            nix search nixpkgs {} || echo "Package information not found in search"

            echo ""
            echo "📋 Store path information:"
            nix-store --query --roots /nix/store/*{}* 2>/dev/null | head -5 || echo "No store information available"
          '';
        };
      };
    };
  };
}
