#!/usr/bin/env bash

CURR_BRANCH=$(git branch | grep -E '\* *' | cut -d ' ' -f 2)

git add .
git commit -m "automated dev update"
git checkout main
git merge "$CURR_BRANCH"
git push origin main
git checkout "$CURR_BRANCH"
