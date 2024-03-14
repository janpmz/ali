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
