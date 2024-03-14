#!/bin/bash

# Function to add aliases
ali() {
    alias_name=$1
    shift
    command="$*"
    echo "alias $alias_name='$command'" >> ~/.bash_aliases
    source ~/.bash_aliases
}

# Function to list all custom aliases
alilist() {
    echo "Custom Aliases:"
    grep '^alias' ~/.bash_aliases || echo "No custom aliases found."
}

# Remove an alias by name
alidelete() {
    alias_name=$1
    sed -i "/alias $alias_name=/d" ~/.bash_aliases
    unalias $alias_name
    source ~/.bash_aliases
}

# Edit aliases
aliedit() {
    editor=${EDITOR:-nano}  # Fallback to nano if $EDITOR isn't set
    $editor ~/.bash_aliases
    source ~/.bash_aliases
}

# Find an alias
alifind() {
    search_term=$1
    echo "Searching for aliases containing '$search_term':"
    grep -i "$search_term" ~/.bash_aliases || echo "No aliases found containing '$search_term'."
}

# show last command and create an alias for it
alilast() {
    # Fetch the last command from history, excluding the call to alienter itself
    last_command=$(history 2 | awk 'NR==1 {sub(/[0-9]+\s+/, ""); print}')

    # Prompt the user to edit the last command or press enter to use it as is
    echo "Enter command for alias (last command shown as default):"
    read -e -i "$last_command" -p "> " input_command

    # Ask for the alias name
    read -p "Enter alias name: " alias_name

    # Create the alias
    echo "alias $alias_name='$input_command'" >> ~/.bash_aliases

    # Source the .bash_aliases to make the new alias available
    source ~/.bash_aliases

    echo "Alias '$alias_name' added for command: $input_command"
}
