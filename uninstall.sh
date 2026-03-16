#!/bin/bash

SHELL_NAME=$(basename "$SHELL")

if [ "$SHELL_NAME" = "bash" ]; then
    CONFIG_FILE=~/.bashrc
    ALIASES_FILE=~/.bash_aliases
elif [ "$SHELL_NAME" = "zsh" ]; then
    CONFIG_FILE=~/.zshrc
    ALIASES_FILE=~/.zsh_aliases
else
    echo "Unsupported shell: $SHELL_NAME"
    echo "Please manually remove 'source ~/.ali/alias_manager.sh' from your shell configuration file."
    exit 1
fi

# Remove the source line from shell config
if [ -f "$CONFIG_FILE" ]; then
    if [[ "$(uname)" == "Darwin" ]]; then
        sed -i '' '/source ~\/.ali\/alias_manager.sh/d' "$CONFIG_FILE"
    else
        sed -i '/source ~\/.ali\/alias_manager.sh/d' "$CONFIG_FILE"
    fi
    echo "Removed ali from $CONFIG_FILE"
fi

# Remove the ~/.ali directory
if [ -d ~/.ali ]; then
    rm -rf ~/.ali
    echo "Removed ~/.ali directory."
fi

echo ""
echo "Ali has been uninstalled."
echo "Your aliases file ($ALIASES_FILE) has been preserved."
echo "Restart your terminal or run 'source $CONFIG_FILE' to apply changes."
