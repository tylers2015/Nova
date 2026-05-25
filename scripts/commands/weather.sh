#!/bin/bash

WEATHER=$(curl -s "wttr.in/Fort+Mill?format=Current+weather:+%C+%t")

/home/ai/Nova/scripts/speak.sh "$WEATHER"

