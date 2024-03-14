# Ali

Instant ALIAS creation in Ubuntu.

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

Turn last command to alias (allows commands with pipes, without entering quotes) 
```
alilast
```

Show history, then create alias for an chosen entry
```
alihist
```

Show the most frequent, non-trivial commands of the history
```
alianalyze
```

## Backup
Your original .bashrc is backed up during installation to
```
~/.bashrc.backup_<timestamp>
```




