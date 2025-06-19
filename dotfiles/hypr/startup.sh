#!/usr/bin/env bash

wallpaper=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --wallpaper)
            wallpaper="$2"
            shift 2
            ;;
        *)
            echo "Unknown parameter: $1"
            exit 1
            ;;
    esac
done

if [[ -z "$wallpaper" ]]; then
    echo "Error: --wallpaper argument is required."
    exit 1
fi

swww init &
sleep 1
swww img "${wallpaper}" &
waybar &
