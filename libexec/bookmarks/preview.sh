#!/usr/bin/env sh

set -eu

browser="$1"
location="$2"
title="$3"
url="$4"
host="${url#*://}"
host="${host%%/*}"

printf 'Browser  : %s\n' "$browser"
printf 'Location : %s\n' "$location"
printf 'Title    : %s\n' "$title"
printf 'Host     : %s\n' "${host:-N/A}"
printf 'URL      : %s\n' "$url"
