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
listali() {
    echo "Custom Aliases:"
    grep '^alias' ~/.bash_aliases || echo "No custom aliases found."
}

