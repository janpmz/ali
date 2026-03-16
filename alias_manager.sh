#!/bin/bash

# Determine the shell being used
_ALI_SHELL=$(basename "$SHELL")

# Set the aliases file based on shell
if [ "$_ALI_SHELL" = "zsh" ]; then
    _ALI_FILE=~/.zsh_aliases
else
    _ALI_FILE=~/.bash_aliases
fi

# Source aliases file
_ali_source() {
    if [ -f "$_ALI_FILE" ]; then
        source "$_ALI_FILE"
    fi
}

# Create a new alias
_ali_create() {
    local alias_name="$1"
    shift
    local command="$*"

    if [ -z "$alias_name" ] || [ -z "$command" ]; then
        echo "Usage: ali <name> <command>"
        return 1
    fi

    echo "alias $alias_name='$command'" >> "$_ALI_FILE"
    _ali_source
    echo "Alias '$alias_name' created for: $command"
}

# List all custom aliases
_ali_list() {
    if [ ! -f "$_ALI_FILE" ]; then
        echo "No custom aliases found."
        return
    fi
    echo "Custom Aliases:"
    grep '^alias' "$_ALI_FILE" || echo "No custom aliases found."
}

# Delete an alias by name
_ali_delete() {
    local alias_name="$1"

    if [ -z "$alias_name" ]; then
        echo "Usage: ali --delete <name>"
        return 1
    fi

    if ! grep -q "^alias ${alias_name}=" "$_ALI_FILE" 2>/dev/null; then
        echo "Alias '$alias_name' not found."
        return 1
    fi

    if [[ "$(uname)" == "Darwin" ]]; then
        sed -i '' "/^alias ${alias_name}=/d" "$_ALI_FILE"
    else
        sed -i "/^alias ${alias_name}=/d" "$_ALI_FILE"
    fi
    unalias "$alias_name" 2>/dev/null || true
    _ali_source
    echo "Alias '$alias_name' deleted."
}

# Edit aliases file in editor
_ali_edit() {
    local editor="${EDITOR:-nano}"
    $editor "$_ALI_FILE"
    _ali_source
}

# Search for aliases
_ali_find() {
    local search_term="$1"

    if [ -z "$search_term" ]; then
        echo "Usage: ali --find <term>"
        return 1
    fi

    echo "Searching for aliases containing '$search_term':"
    grep -i "$search_term" "$_ALI_FILE" || echo "No aliases found containing '$search_term'."
}

# Create alias from last command
_ali_last() {
    local last_command
    local input_command

    if [ "$_ALI_SHELL" = "zsh" ]; then
        last_command=$(fc -ln -1 | sed 's/^\s*//')
    else
        last_command=$(history 2 | awk 'NR==1 {sub(/[0-9]+\s+/, ""); print}')
    fi

    echo "Enter command for alias (last command shown as default):"
    if [ "$_ALI_SHELL" = "zsh" ]; then
        input_command="$last_command"
        vared -p "> " input_command
    else
        read -e -i "$last_command" -p "> " input_command
    fi

    local alias_name
    read -p "Enter alias name: " alias_name

    if [ -z "$alias_name" ] || [ -z "$input_command" ]; then
        echo "Alias name and command are required."
        return 1
    fi

    echo "alias $alias_name='$input_command'" >> "$_ALI_FILE"
    _ali_source
    echo "Alias '$alias_name' created for: $input_command"
}

# Create alias from history selection
_ali_hist() {
    history

    local history_number
    read -p "Enter the number of the command you'd like to alias: " history_number

    local selected_command
    if [ "$_ALI_SHELL" = "zsh" ]; then
        selected_command=$(fc -ln | grep -n . | grep "^$history_number:" | sed -E 's/^[0-9]+:\s*//')
    else
        selected_command=$(history | grep -P "^ *$history_number" | sed -E 's/^ *[0-9]+ *//')
    fi

    if [ -z "$selected_command" ]; then
        echo "Command not found in history."
        return 1
    fi

    local alias_name
    read -p "Enter a name for your alias: " alias_name

    if [ -z "$alias_name" ]; then
        echo "Alias name is required."
        return 1
    fi

    echo "alias $alias_name='$selected_command'" >> "$_ALI_FILE"
    _ali_source
    echo "Alias '$alias_name' created for: $selected_command"
}

# Analyze frequent commands for aliasing
_ali_analyze() {
    local min_cmd_length=8
    local tmp_history
    local tmp_sorted
    tmp_history=$(mktemp)
    tmp_sorted=$(mktemp)

    if [ "$_ALI_SHELL" = "zsh" ]; then
        fc -ln 1 > "$tmp_history"
    else
        history | cut -c 8- > "$tmp_history"
    fi

    awk -v min_len="$min_cmd_length" '{
        if (length($0) >= min_len) {
            CMD[$0]++;
        }
    }
    END {
        for (a in CMD)
            print CMD[a] " " a;
    }' "$tmp_history" | sort -n | awk '{print NR " " substr($0, index($0, $2))}' > "$tmp_sorted"

    rm -f "$tmp_history"

    cat "$tmp_sorted"

    local cmd_number
    read -p "Select the number for the command you'd like to alias: " cmd_number

    local selected_command
    selected_command=$(awk -v num="$cmd_number" 'NR == num {for (i=2; i<=NF; i++) printf $i " "; print ""}' "$tmp_sorted")

    rm -f "$tmp_sorted"

    if [ -z "$selected_command" ]; then
        echo "Command not found."
        return 1
    fi

    local alias_name
    read -p "Enter a name for your alias: " alias_name

    if [ -z "$alias_name" ]; then
        echo "Alias name is required."
        return 1
    fi

    echo "alias $alias_name='$selected_command'" >> "$_ALI_FILE"
    _ali_source
    echo "Alias '$alias_name' created for: $selected_command"
}

# Show help
_ali_help() {
    cat <<'EOF'
ali - Instant alias creation for bash and zsh

Usage:
  ali <name> <command>    Create a new alias
  ali --list              List all custom aliases
  ali --delete <name>     Delete an alias by name
  ali --edit              Edit aliases file in $EDITOR
  ali --find <term>       Search aliases by keyword
  ali --last              Create alias from last command
  ali --hist              Create alias from history selection
  ali --analyze           Analyze frequent commands for aliasing
  ali --help              Show this help message

Examples:
  ali gp git push         Create 'gp' alias for 'git push'
  ali --delete gp         Remove the 'gp' alias
  ali --find git          Find all aliases containing 'git'
EOF
}

# Main dispatch
ali() {
    case "${1:-}" in
        --list)     _ali_list ;;
        --delete)   shift; _ali_delete "$@" ;;
        --edit)     _ali_edit ;;
        --find)     shift; _ali_find "$@" ;;
        --last)     _ali_last ;;
        --hist)     _ali_hist ;;
        --analyze)  _ali_analyze ;;
        --help|-h)  _ali_help ;;
        "")         _ali_help ;;
        *)          _ali_create "$@" ;;
    esac
}

# Initial sourcing of aliases
_ali_source
