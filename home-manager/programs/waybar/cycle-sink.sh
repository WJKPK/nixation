set -euo pipefail

readonly SCRIPT_NAME="${0##*/}"

# Global array to cache sinks
declare -a SINKS=()

# Display usage information
usage() {
    cat << EOF
Usage: $SCRIPT_NAME [OPTIONS]
Cycle between available PipeWire audio sinks or select a specific sink.

OPTIONS:
    -h, --help         Show this help message
    -q, --quiet        Suppress output (exit codes only)
    -v, --verbose      Show detailed sink information
    -s, --sink-id ID   Switch to specific sink by ID

EXAMPLES:
    $SCRIPT_NAME           # Cycle to next sink
    $SCRIPT_NAME -q        # Silent operation
    $SCRIPT_NAME -v        # Show all available sinks
    $SCRIPT_NAME -s 42     # Switch to sink with ID 42

EXIT CODES:
    0  Success
    1  No sinks found or switch failed
    2  PipeWire/wpctl not available
    3  Invalid sink ID
EOF
}

# Check if required tools are available
check_dependencies() {
    command -v wpctl >/dev/null || {
        echo "Error: wpctl not found. Please install pipewire-utils." >&2
        exit 2
    }
}

# Extract sinks from wpctl status output
get_sinks() {
    local output
    output=$(wpctl status 2>/dev/null) || {
        echo "Error: Failed to execute wpctl status" >&2
        exit 1
    }

    # Parse sinks using awk
    readarray -t SINKS < <(echo "$output" | awk '
        /├─ Sinks:/ { in_sinks=1; next }
        in_sinks && /├─/ { exit }
        in_sinks && /^[[:space:]]*│[[:space:]]*\*?[[:space:]]*[0-9]+\./ {
            match($0, /[0-9]+/)
            id = substr($0, RSTART, RLENGTH)
            
            match($0, /[0-9]+\.[[:space:]]+([^[]+)/, arr)
            gsub(/[[:space:]]*$/, "", arr[1])
            name = arr[1]
            
            is_default = ($0 ~ /\*/) ? "1" : "0"
            print id ":" name ":" is_default
        }
    ')

    # Validate that we got valid sink data
    if [[ ${#SINKS[@]} -eq 0 ]]; then
        echo "Error: No valid audio sinks found in wpctl output" >&2
        exit 1
    fi
}

# Display all available sinks
show_sinks() {
    echo "Available audio sinks:"
    for sink in "${SINKS[@]}"; do
        local id="${sink%%:*}"
        local name="${sink#*:}"; name="${name%:*}"
        local is_default="${sink##*:}"
        
        if [[ "$is_default" == "1" ]]; then
            echo "  * $name (ID: $id) [current]"
        else
            echo "    $name (ID: $id)"
        fi
    done
}

# Main logic
main() {
    local quiet=0 verbose=0 sink_id=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage; exit 0 ;;
            -q|--quiet)
                quiet=1; shift ;;
            -v|--verbose)
                verbose=1; shift ;;
            -s|--sink-id)
                [[ -n "${2-}" ]] || { echo "Error: --sink-id requires an ID" >&2; exit 1; }
                sink_id="$2"; shift 2 ;;
            *)
                echo "Error: Unknown option '$1'" >&2
                echo "Use '$SCRIPT_NAME --help' for usage information." >&2
                exit 1 ;;
        esac
    done
    
    check_dependencies
    get_sinks  # Populate SINKS array
    
    if [[ ${#SINKS[@]} -eq 1 && -z "$sink_id" ]]; then
        [[ $quiet -eq 0 ]] && echo "Only one sink available, nothing to switch to"
        exit 0
    fi
    
    # Show verbose output if requested
    if [[ $verbose -eq 1 ]]; then
        show_sinks
        echo
    fi
    
    # Handle specific sink ID if provided
    if [[ -n "$sink_id" ]]; then
        local found=0
        for sink in "${SINKS[@]}"; do
            local id="${sink%%:*}"
            local name="${sink#*:}"; name="${name%:*}"
            if [[ "$id" == "$sink_id" ]]; then
                if wpctl set-default "$sink_id" 2>/dev/null; then
                    [[ $quiet -eq 0 ]] && echo "Switched to: $name"
                    exit 0
                else
                    [[ $quiet -eq 0 ]] && echo "Error: Failed to switch to '$name' (ID: $sink_id)" >&2
                    exit 1
                fi
                found=1
                break
            fi
        done
        [[ $quiet -eq 0 ]] && echo "Error: Sink ID '$sink_id' not found" >&2
        exit 3
    fi
    
    # Find current default sink
    local current_idx=0
    for i in "${!SINKS[@]}"; do
        [[ "${SINKS[i]##*:}" == "1" ]] && { current_idx=$i; break; }
    done
    
    # Calculate next sink (cycle through)
    local next_idx=$(( (current_idx + 1) % ${#SINKS[@]} ))
    
    local next_sink="${SINKS[next_idx]}"
    local next_id="${next_sink%%:*}"
    local next_name="${next_sink#*:}"; next_name="${next_name%:*}"
    
    # Show current sink in verbose mode before switching
    if [[ $verbose -eq 1 ]]; then
        local current_sink="${SINKS[current_idx]}"
        local current_name="${current_sink#*:}"; current_name="${current_name%:*}"
        [[ $quiet -eq 0 ]] && echo "Current sink: $current_name"
    fi
    
    # Switch to next sink
    if wpctl set-default "$next_id" 2>/dev/null; then
        [[ $quiet -eq 0 ]] && echo "Switched to: $next_name"
    else
        [[ $quiet -eq 0 ]] && echo "Error: Failed to switch to '$next_name' (ID: $next_id)" >&2
        exit 1
    fi
}

main "$@"
