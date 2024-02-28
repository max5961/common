#!/bin/bash

# not sure which option to commit to so choose one

# greps for hidden FILES
# file=$(rg --hidden -l "" | fzf -i)

# greps for directories only, including hidden (excluding node_modules/.git)
file=$(find . -type d -name 'node_modules' -prune -o -type d -name '.git' -prune -o -type d -print 2>/dev/null | fzf -i)

cd "$file"
