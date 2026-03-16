#!/bin/bash

# Create the ~/.ali directory if it doesn't exist
mkdir -p "$HOME/.ali"

# Determine the shell being used
SHELL_NAME=$(basename "$SHELL")

# Set paths based on shell type
if [ "$SHELL_NAME" = "bash" ]; then
    CONFIG_FILE="$HOME/.bashrc"
    ALIASES_FILE="$HOME/.bash_aliases"
elif [ "$SHELL_NAME" = "zsh" ]; then
    CONFIG_FILE="$HOME/.zshrc"
    ALIASES_FILE="$HOME/.zsh_aliases"
else
    echo "Unsupported shell: $SHELL_NAME"
    echo "Please manually add 'source \$HOME/.ali/alias_manager.sh' to your shell configuration file."
    exit 1
fi

# Backup the current config file
if [ -f "$CONFIG_FILE" ]; then
    cp "$CONFIG_FILE" "${CONFIG_FILE}.backup_$(date +%Y-%m-%d_%H%M%S)"
else
    touch "$CONFIG_FILE"
fi

# Ensure aliases file exists
[ -f "$ALIASES_FILE" ] || touch "$ALIASES_FILE"

# Add source line if not already present
ALIAS_MANAGER_PATH="\$HOME/.ali/alias_manager.sh"
if ! grep -q "source $ALIAS_MANAGER_PATH" "$CONFIG_FILE"; then
    echo "Adding source command to $CONFIG_FILE"
    echo "source $ALIAS_MANAGER_PATH" >> "$CONFIG_FILE"
else
    echo "alias_manager.sh is already sourced in your $CONFIG_FILE"
fi

# Copy alias_manager.sh to the ~/.ali directory
cp alias_manager.sh "$HOME/.ali/alias_manager.sh"
chmod +x "$HOME/.ali/alias_manager.sh"

echo "A backup of your original $CONFIG_FILE has been created."
echo "You can use ali now. You may need to restart your terminal or run 'source $CONFIG_FILE'."
