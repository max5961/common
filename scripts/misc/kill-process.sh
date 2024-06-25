#!/bin/bash

if [ -z "$1" ]; then
	echo "No argument provided"
	exit 1
fi

kill -9 $(pgrep -f "$1")
