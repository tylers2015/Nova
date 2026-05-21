#!/bin/bash

MESSAGE="$*"

espeak-ng -s 165 -v en-us "$MESSAGE"
