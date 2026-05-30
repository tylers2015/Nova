#!/bin/bash
MESSAGE="$*"
espeak-ng -s 165 -p 65 -v en-us+f4 "$MESSAGE"
