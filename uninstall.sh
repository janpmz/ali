#!/bin/bash

SHELL_NAME=$(basename "$SHELL")

if [ "$SHELL_NAME" = "bash" ]; then
    CONFIG_FILE="$HOME/.bashrc"
    ALIASES_FILE="$HOME/.bash_aliases"
elif [ "$SHELL_NAME" = "zsh" ]; then
    CONFIG_FILE="$HOME/.zshrc"
    ALIASES_FILE="$HOME/.zsh_aliases"
else
    echo "Unsupported shell: $SHELL_NAME"
    echo "Please manually remove 'source \$HOME/.ali/alias_manager.sh' from your shell configuration file."
    exit 1
fi

# Remove the source line from shell config
if [ -f "$CONFIG_FILE" ]; then
    if [[ "$(uname)" == "Darwin" ]]; then
        sed -i '' '/source \$HOME\/.ali\/alias_manager.sh/d' "$CONFIG_FILE"
    else
        sed -i '/source \$HOME\/.ali\/alias_manager.sh/d' "$CONFIG_FILE"
    fi
    echo "Removed ali from $CONFIG_FILE"
fi

# Remove the ~/.ali directory (with confirmation)
if [ -d "$HOME/.ali" ]; then
    read -r -p "Remove $HOME/.ali directory? This cannot be undone. [y/N] " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        rm -rf "$HOME/.ali"
        echo "Removed $HOME/.ali directory."
    else
        echo "Kept $HOME/.ali directory."
    fi
fi

echo ""
echo "Ali has been uninstalled."
echo "Your aliases file ($ALIASES_FILE) has been preserved."
echo "Restart your terminal or run 'source $CONFIG_FILE' to apply changes."
