#!/bin/bash
# search by file contents and open with vim on the corresponding line number

# Works for most files...but there are some issues with ripgrep that I haven't
# figured out yet.  It sometimes skips over files and directories that should
# not be hidden or omitted

# First pipe ripgrep into fzf, which by itself greps by both file contents and name
result=
if [ "$1" == "-h" ] || [ "$1" == "--hidden" ]; then
    result=$(rg --line-number --hidden -g '!node_modules' -g '!.git' -g '!package-lock.json' -g '!bundle.js' "" | fzf -i)
elif [ "$1" == "-r" ] || [ "$1" == "--root" ]; then
    cd /
    result=$(rg --line-number -g '!home/' "" 2>/dev/null | fzf -i)
else
    result=$(rg --line-number -g '!node_modules' -g '!.git' -g '!package-lock.json' -g '!bundle.js' "" | fzf -i)
fi

# result is in the format: "path/to/file:line_number: matched_content"
file=$(echo "$result" | awk -F ':' '{print $1}')
line_number=$(echo "$result" | awk -F ':' '{print $2}')

# note: cd into the parent directory first to make the vim experience more pleasant
if [ -f "$file" ] && [ ! -d "$file" ]; then
    if [ "$1" == "-r" ] || [ "$1" == "--root" ]; then
        cd $(dirname "/$file")
        sudoedit "/$file"
    else
        cd $(dirname $file)
        nvim +"$line_number" "$HOME/$file"
    fi
fi

# just in case, but this shouldn't ever happen
if [ -d "$file" ]; then
    cd $(dirname $file)
    nvim "$HOME/file"
fi

# for keeping track of what files were edited/inspected
echo "$result"
