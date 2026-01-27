{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.utilities.television;
in {
  options.utilities.television = with types; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable television.";
    };
  };

  config = mkIf cfg.enable {
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
        distrobox-list = {
          metadata = {
            name = "distrobox-list";
            description = "A channel to select a container from distrobox";
            requirements = [
              "distrobox"
              "bat"
            ];
          };

          source = {
            command = "distrobox list | awk -F '|' '{ gsub(/ /, \"\", $2); print $2}' | tail --lines=+2";
          };

          preview = {
            command = "(distrobox list | column -t -s '|' | awk -v selected_name={} 'NR==1 || $0 ~ selected_name') && echo && distrobox enter -d {} | bat --plain --color=always -lbash";
          };

          keybindings = {
            ctrl-e = "actions:distrobox-enter";
            ctrl-l = "actions:distrobox-list";
            ctrl-r = "actions:distrobox-rm";
            ctrl-s = "actions:distrobox-stop";
            ctrl-u = "actions:distrobox-upgrade";
          };

          actions = {
            distrobox-enter = {
              description = "Enter a distrobox";
              command = "distrobox enter {}";
              mode = "execute";
            };

            distrobox-list = {
              description = "List a distrobox";
              command = "distrobox list | column -t -s '|' | awk -v selected_name={} 'NR==1 || $0 ~ selected_name'";
              mode = "execute";
            };

            distrobox-rm = {
              description = "Remove a distrobox";
              command = "distrobox rm {}";
              mode = "execute";
            };

            distrobox-stop = {
              description = "Stop a distrobox";
              command = "distrobox stop {}";
              mode = "execute";
            };

            distrobox-upgrade = {
              description = "Upgrade a distrobox";
              command = "distrobox upgrade {}";
              mode = "execute";
            };
          };
        };
        env = {
          metadata = {
            name = "env";
            description = "A channel to select from environment variables";
          };

          source = {
            command = "printenv";
            output = "{split:=:1..}"; # output the value
          };

          preview = {
            command = "echo '{split:=:1..}'";
          };

          ui = {
            layout = "portrait";
            preview_panel = {
              size = 20;
              header = "{split:=:0}";
            };
          };

          keybindings = {
            shortcut = "f3";
          };
        };
        openocd-all = {
          metadata = {
            name = "openocd-all";
            description = "Browse all OpenOCD configurations with categories";
            requirements = [
              "openocd"
              "bat"
            ];
          };

          source = {
            command = ''
              cd $OPENOCD_PATH/share/openocd/scripts
              for dir in board target interface chip cpu cpld fpga; do
                if [ -d "$dir" ]; then
                  find "$dir" -name '*.cfg' | while read -r file; do
                    printf "[%s] %-40s :: %s\n" "$dir" "$(basename "$file")" "$OPENOCD_PATH/share/openocd/scripts/$file"
                  done
                fi
              done | sort
            '';
            output = "{split: :: :1}";
          };

          preview = {
            command = ''
              fullpath=$(echo {} | awk -F ' :: ' '{print $2}')
              category=$(echo {} | sed -n 's/^\[\(.*\)\].*/\1/p')
              filename=$(echo {} | awk '{print $2}')

              echo "📂 Category: $category"
              echo "📄 File: $filename"
              echo "📍 Path: $fullpath"
              echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
              echo ""
              bat --color=always --style=numbers --language=tcl "$fullpath"
            '';
          };

          keybindings = {
            ctrl-o = "actions:open-location";
            ctrl-y = "actions:copy-path";
          };

          actions = {
            open-location = {
              description = "Open config directory in file manager";
              command = ''
                fullpath=$(echo {} | awk -F ' :: ' '{print $2}')
                xdg-open "$(dirname "$fullpath")"
              '';
              mode = "execute";
            };

            copy-path = {
              description = "Copy full path to clipboard";
              command = ''
                fullpath=$(echo {} | awk -F ' :: ' '{print $2}')
                echo -n "$fullpath" | xclip -selection clipboard
              '';
              mode = "execute";
            };
          };
        };
      };
    };
  };
}
