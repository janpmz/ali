# Ali

Instant ALIAS creation in Ubuntu and macOS.

![](ali_example_gif.gif)


```
ali <alias_name> <command>
```

## Examples:

```
ali gp git push
gp
```

```
ali run npm start
run
```

```
# use quotes for pipes (or use alilast instead)
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

List aliases
```
alilist
```

Delete alias by name
```
alidelete <name>
```

Edit aliases
```
aliedit
```

Find an alias
```
alifind <word>
```

Turn last command to alias (works with pipes, quotes not required)
```
alilast
```

Show history, choose entry, create alias
```
alihist
```

Show the most frequent, non-trivial commands of the history
```
alianalyze
```

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
Ali now works with both bash (Ubuntu/Linux) and zsh (macOS default) shells. It automatically detects your shell and configures itself accordingly.
