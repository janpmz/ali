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

# show history of commands, then create alias of desired command
alihist() {
    # Display the command history
    history

    # Ask the user to choose a command by its number
    read -p "Enter the number of the command you'd like to alias: " history_number

    # Extract the chosen command, avoiding the history number and trimming leading spaces
    selected_command=$(history | grep -P "^ *$history_number" | sed -E 's/^ *[0-9]+ *//')

    if [ -z "$selected_command" ]; then
        echo "Command not found in history."
        return 1
    fi

    # Prompt for an alias name
    read -p "Enter a name for your alias: " alias_name

    # Add the alias to .bash_aliases
    echo "alias $alias_name='$selected_command'" >> ~/.bash_aliases

    # Source .bash_aliases to make the alias available
    source ~/.bash_aliases

    echo "Alias '$alias_name' created for command: $selected_command"
}

# show the most frequent non-trivial commands of the history
alianalyze() {
    # Define the minimum command length for inclusion
    min_cmd_length=8

    # Extract commands, filter out those shorter than min_cmd_length, count, sort by frequency ascending
    history | cut -c 8- | awk -v min_len="$min_cmd_length" '{
        if (length($0) >= min_len) {
            CMD[$0]++;
        }
    }
    END {
        for (a in CMD)
            print CMD[a] " " a;
    }' | sort -n | awk '{print NR " " substr($0, index($0, $2))}' > /tmp/sorted_cmds_frequency.txt

    # Display the sorted, numbered list of commands
    cat /tmp/sorted_cmds_frequency.txt

    # Prompt the user to choose a command by its number
    read -p "Select the number for the command you'd like to alias: " cmd_number

    # Extract the chosen command
    selected_command=$(awk -v num=$cmd_number 'NR == num {for (i=2; i<=NF; i++) printf $i " "; print ""}' /tmp/sorted_cmds_frequency.txt)

    if [ -z "$selected_command" ]; then
        echo "Command not found."
        return 1
    fi

    # Prompt for an alias name
    read -p "Enter a name for your alias: " alias_name

    # Add the alias to .bash_aliases
    echo "alias $alias_name='$selected_command'" >> ~/.bash_aliases

    # Source .bash_aliases to make the alias available
    source ~/.bash_aliases

    echo "Alias '$alias_name' created for command: $selected_command"
}