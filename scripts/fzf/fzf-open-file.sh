#!/bin/bash

# file=$(find . -type d -name 'node_modules' -prune -o -type d -name '.git' -prune -o -type d -print 2>/dev/null | fzf -i)
#
# find home or cwd
# find . -name 'node_modules' -prune -o -name '.git' -prune -o -name 'bundle.js' -prune -o -print | fzf -i
#
# find root
# find / -path /home/* -prune -o -print 2>/dev/null | fzf -i
#
# find (including hidden)
# find . | fzf -i
#
file=
# -l flag in ripgrep to only grep filenames
if [ "$1" == "-h" ] || [ "$1" == "--hidden" ]; then
    file=$(find . | fzf -i)
elif [ "$1" == "-r" ] || [ "$1" == "--root" ]; then
    file=$(find / -path /home/* -prune -o -print 2>/dev/null | fzf -i)
else
    file=$(find . -name 'node_modules' -prune -o -name '.git' -prune -o -name 'bundle.js' -prune -o -print | fzf -i)
fi

if [ -f "$file" ]; then
    if [ "$1" == "-r" ] || [ "$1" == "--root" ]; then
        # fzf outputs without the preceding /
        cd $(dirname "/$file")
        sudoedit "/$file"
    else
        cd $(dirname $file)
        nvim "$HOME/$file"
    fi
elif [ "$file" == "" ]; then
    exit 0
fi

# for keeping track of what files were edited/inspected
echo "$file"
