#!/bin/bash

# Create the ~/.ali directory if it doesn't exist
mkdir -p ~/.ali

# Determine the shell being used
SHELL_NAME=$(basename "$SHELL")

# Backup and setup based on shell type
if [ "$SHELL_NAME" = "bash" ]; then
    # Backup the current .bashrc if it exists
    if [ -f ~/.bashrc ]; then
        cp ~/.bashrc ~/.bashrc.backup_$(date +%Y-%m-%d_%H%M%S)
    else
        touch ~/.bashrc
    fi
    
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
    
    CONFIG_FILE=~/.bashrc
elif [ "$SHELL_NAME" = "zsh" ]; then
    # Backup the current .zshrc if it exists
    if [ -f ~/.zshrc ]; then
        cp ~/.zshrc ~/.zshrc.backup_$(date +%Y-%m-%d_%H%M%S)
    else
        touch ~/.zshrc
    fi
    
    # Ensure ~/.zsh_aliases exists
    if [ ! -f ~/.zsh_aliases ]; then
        touch ~/.zsh_aliases
    fi
    
    # Define the path to your alias_manager.sh script
    ALIAS_MANAGER_PATH="~/.ali/alias_manager.sh"
    
    # Check if the alias_manager is already sourced in .zshrc; if not, append it
    if ! grep -q "source $ALIAS_MANAGER_PATH" ~/.zshrc; then
        echo "Adding source command to .zshrc"
        echo "source $ALIAS_MANAGER_PATH" >> ~/.zshrc
    else
        echo "alias_manager.sh is already sourced in your .zshrc"
    fi
    
    CONFIG_FILE=~/.zshrc
else
    echo "Unsupported shell: $SHELL_NAME"
    echo "Please manually add 'source ~/.ali/alias_manager.sh' to your shell configuration file."
    CONFIG_FILE=""
fi

# Copy alias_manager.sh to the ~/.ali directory
cp alias_manager.sh ~/.ali/alias_manager.sh
chmod +x ~/.ali/alias_manager.sh

# Source the configuration file to apply changes if it exists
if [ -n "$CONFIG_FILE" ]; then
    echo "A backup of your original $CONFIG_FILE has been created."
    echo "You can use ali now. You may need to restart your terminal or run 'source $CONFIG_FILE'."
fi
