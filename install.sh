#!/bin/bash

# Create the ~/.ali directory if it doesn't exist
mkdir -p ~/.ali

# Backup the current .bashrc
cp ~/.bashrc ~/.bashrc.backup_$(date +%Y-%m-%d_%H%M%S)

# Copy alias_manager.sh to the ~/.ali directory
cp alias_manager.sh ~/.ali/alias_manager.sh

# Ensure ~/.bash_aliases exists
if [ ! -f ~/.bash_aliases ]; then
    touch ~/.bash_aliases
fi

# Define the path to your alias_manager.sh script
ALIAS_MANAGER_PATH="~/.ali/alias_manager.sh"

# Check if the alias_manager is already sourced in .bashrc; if not, append it
if ! grep -q "source $ALIAS_MANAGER_PATH" ~/.bashrc; then
    echo "Adding source command to .bashrc"
    echo "source $ALIAS_MANAGER_PATH" >> ~/.bashrc
else
    echo "alias_manager.sh is already sourced in your .bashrc"
fi

# Source the .bashrc to apply changes
. ~/.bashrc

echo "A backup of your original .bashrc has been created."
echo "You can use ali now."