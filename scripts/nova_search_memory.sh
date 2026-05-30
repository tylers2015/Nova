#!/bin/bash

QUERY="$*"

if [ -z "$QUERY" ]; then
  echo "Usage: nova_search_memory.sh search terms"
  exit 1
fi

grep -Rin --color=always "$QUERY" ~/Nova/projects ~/Nova/docs ~/Nova/logs 2>/dev/null
