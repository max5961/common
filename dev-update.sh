#!/usr/bin/env bash

CURR_BRANCH=$(git branch --show-current)

cd "$CURR_BRANCH"
git add .
git commit -m "automated dev update"
git checkout main
git merge "$CURR_BRANCH"
git push origin main
git checkout "$CURR_BRANCH"
