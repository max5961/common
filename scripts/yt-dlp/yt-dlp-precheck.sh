#!/usr/bin/env bash

API='https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest'
LATEST=$(curl -s $API | jq '.["tag_name"]' | sed 's/"//g')
CURRENT=$(yt-dlp --version)

[[ $CURRENT == $LATEST ]] && echo "yt-dlp is up to date [$LATEST]" && exit 0

echo "yt-dlp is not up to date [current: $CURRENT, latest: $LATEST]"
echo "Upgrading"
pipx install yt-dlp=="$LATEST" --force

