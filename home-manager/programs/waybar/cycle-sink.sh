set -euo pipefail

readonly SCRIPT_NAME="${0##*/}"

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
    -n, --sink-name    Switch to sink by name (fuzzy match)

EXAMPLES:
    $SCRIPT_NAME              # Cycle to next sink
    $SCRIPT_NAME -q           # Silent operation
    $SCRIPT_NAME -v           # Show all available sinks
    $SCRIPT_NAME -s 42        # Switch to sink with ID 42
    $SCRIPT_NAME -n HDMI      # Switch to sink matching "HDMI"

EXIT CODES:
    0  Success
    1  No sinks found or switch failed
    2  Required tools not available
    3  Invalid sink ID/name
EOF
}

# Check if required tools are available
check_dependencies() {
    local missing=()
    command -v pw-dump >/dev/null || missing+=("pw-dump (pipewire)")
    command -v wpctl >/dev/null || missing+=("wpctl (wireplumber)")
    command -v jq >/dev/null || missing+=("jq")
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "Error: Missing required tools: ${missing[*]}" >&2
        exit 2
    fi
}

# Get all audio sinks as JSON array
get_sinks_json() {
    pw-dump 2>/dev/null | jq -c '
        [
            .[] | 
            select(
                .type == "PipeWire:Interface:Node" and
                .info.props."media.class" == "Audio/Sink"
            ) |
            {
                id: .id,
                name: (.info.props."node.name" // ""),
                description: (.info.props."node.description" // .info.props."node.name" // "")
            }
        ]
    '
}

# Get current default sink ID from metadata
get_default_sink() {
    pw-dump 2>/dev/null | jq -r '
        .[] |
        select(.type == "PipeWire:Interface:Metadata") |
        .metadata[] |
        select(.key == "default.audio.sink") |
        .value.name
    ' | head -n1
}

# Get sink ID by name
get_sink_id_by_name() {
    local name="$1"
    pw-dump 2>/dev/null | jq -r --arg name "$name" '
        .[] |
        select(
            .type == "PipeWire:Interface:Node" and
            .info.props."media.class" == "Audio/Sink" and
            .info.props."node.name" == $name
        ) |
        .id
    ' | head -n1
}

# Display all available sinks
show_sinks() {
    local default_name
    default_name=$(get_default_sink)
    
    if [[ -z "$default_name" ]]; then
        echo "Error: Could not determine default sink" >&2
        return 1
    fi
    
    echo "Available audio sinks:"
    get_sinks_json | jq -r --arg default "$default_name" '
        .[] |
        if .name == $default then
            "  * \(.description) (ID: \(.id)) [current]"
        else
            "    \(.description) (ID: \(.id))"
        end
    '
}

# Get sink count
get_sink_count() {
    get_sinks_json | jq 'length'
}

# Get sink by ID
get_sink_by_id() {
    local target_id="$1"
    get_sinks_json | jq --arg id "$target_id" '
        .[] | select(.id == ($id | tonumber))
    '
}

# Get sink by name pattern (fuzzy match)
get_sink_by_pattern() {
    local pattern="$1"
    get_sinks_json | jq --arg pattern "$pattern" '
        [.[] | select(
            (.name // "" | ascii_downcase | contains($pattern | ascii_downcase)) or
            (.description // "" | ascii_downcase | contains($pattern | ascii_downcase))
        )] | first
    '
}

# Get next sink in cycle
get_next_sink() {
    local current_name="$1"
    get_sinks_json | jq --arg current "$current_name" '
        . as $sinks |
        (. | to_entries | map(select(.value.name == $current)) | .[0].key) as $current_idx |
        if $current_idx == null then
            .[0]
        else
            .[(($current_idx + 1) % length)]
        end
    '
}

# Switch to sink by ID
switch_to_sink() {
    local sink_id="$1"
    wpctl set-default "$sink_id" 2>/dev/null
}

# Main logic
main() {
    local quiet=0 verbose=0 sink_id="" sink_name=""
    
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
            -n|--sink-name)
                [[ -n "${2-}" ]] || { echo "Error: --sink-name requires a name" >&2; exit 1; }
                sink_name="$2"; shift 2 ;;
            *)
                echo "Error: Unknown option '$1'" >&2
                echo "Use '$SCRIPT_NAME --help' for usage information." >&2
                exit 1 ;;
        esac
    done
    
    check_dependencies
    
    local sink_count
    sink_count=$(get_sink_count)
    
    if [[ "$sink_count" -eq 0 ]]; then
        [[ $quiet -eq 0 ]] && echo "Error: No audio sinks found" >&2
        exit 1
    fi
    
    if [[ "$sink_count" -eq 1 && -z "$sink_id" && -z "$sink_name" ]]; then
        [[ $quiet -eq 0 ]] && echo "Only one sink available, nothing to switch to"
        exit 0
    fi
    
    # Show verbose output if requested
    if [[ $verbose -eq 1 ]]; then
        show_sinks
        [[ -n "$sink_id" || -n "$sink_name" ]] && echo
    fi
    
    # Handle specific sink name/pattern if provided
    if [[ -n "$sink_name" ]]; then
        local sink
        sink=$(get_sink_by_pattern "$sink_name")
        
        if [[ "$sink" == "null" || -z "$sink" ]]; then
            [[ $quiet -eq 0 ]] && echo "Error: No sink matching '$sink_name' found" >&2
            exit 3
        fi
        
        sink_id=$(echo "$sink" | jq -r '.id')
    fi
    
    # Handle specific sink ID if provided
    if [[ -n "$sink_id" ]]; then
        local sink
        sink=$(get_sink_by_id "$sink_id")
        
        if [[ "$sink" == "null" || -z "$sink" ]]; then
            [[ $quiet -eq 0 ]] && echo "Error: Sink ID '$sink_id' not found" >&2
            exit 3
        fi
        
        local desc
        desc=$(echo "$sink" | jq -r '.description')
        
        if switch_to_sink "$sink_id"; then
            [[ $quiet -eq 0 ]] && echo "Switched to: $desc"
            exit 0
        else
            [[ $quiet -eq 0 ]] && echo "Error: Failed to switch to '$desc' (ID: $sink_id)" >&2
            exit 1
        fi
    fi
    
    # Cycle to next sink
    local current_name next_sink
    current_name=$(get_default_sink)
    
    if [[ -z "$current_name" ]]; then
        [[ $quiet -eq 0 ]] && echo "Error: Could not determine current sink" >&2
        exit 1
    fi
    
    next_sink=$(get_next_sink "$current_name")
    
    if [[ "$next_sink" == "null" || -z "$next_sink" ]]; then
        [[ $quiet -eq 0 ]] && echo "Error: Could not determine next sink" >&2
        exit 1
    fi
    
    local next_id next_desc
    next_id=$(echo "$next_sink" | jq -r '.id')
    next_desc=$(echo "$next_sink" | jq -r '.description')
    
    if [[ $verbose -eq 1 ]]; then
        local current_sink current_desc
        current_sink=$(get_sinks_json | jq --arg name "$current_name" '.[] | select(.name == $name)')
        current_desc=$(echo "$current_sink" | jq -r '.description')
        [[ $quiet -eq 0 ]] && echo "Current sink: $current_desc"
    fi
    
    if switch_to_sink "$next_id"; then
        [[ $quiet -eq 0 ]] && echo "Switched to: $next_desc"
    else
        [[ $quiet -eq 0 ]] && echo "Error: Failed to switch to '$next_desc' (ID: $next_id)" >&2
        exit 1
    fi
}

main "$@"
