# Ali

Instant alias creation for bash and zsh (Ubuntu, macOS).

![](ali_example_gif.gif)

```
ali <alias_name> <command>
```

## Examples

```
ali gp git push
gp
```

```
ali run npm start
run
```

```
# use quotes for pipes (or use ali --last instead)
ali hist "history | grep"
hist <searchterm>
```

## Installation

```
git clone https://github.com/janpmz/ali.git
cd ali
chmod +x install.sh
sh install.sh
```

## Commands

Create an alias
```
ali <name> <command>
```

List aliases
```
ali --list
```

Delete alias by name
```
ali --delete <name>
```

Edit aliases
```
ali --edit
```

Find an alias
```
ali --find <word>
```

Turn last command into an alias (works with pipes, quotes not required)
```
ali --last
```

Show history, choose entry, create alias
```
ali --hist
```

Show the most frequent, non-trivial commands of the history
```
ali --analyze
```

Show help
```
ali --help
```

## Uninstall

```
chmod +x uninstall.sh
sh uninstall.sh
```

Your aliases file is preserved during uninstall.

## Backup

Your original shell configuration file (.bashrc or .zshrc) is backed up during installation to
```
~/.bashrc.backup_<timestamp>
```
or
```
~/.zshrc.backup_<timestamp>
```

## Compatibility

Ali works with both bash (Ubuntu/Linux) and zsh (macOS default) shells. It automatically detects your shell and configures itself accordingly.
