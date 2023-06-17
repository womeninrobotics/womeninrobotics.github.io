#!/bin/sh

TRIES=3
BASEDIR=$(dirname "$0")

code=1
while [ "$TRIES" -ge 1 ]; do
  TRIES=$((TRIES-1))
  bundle exec ruby "$BASEDIR/htmlproofer.rb"
  code="$?"
  if [ "$code" -eq 0 ]; then
    break
  fi
  if [ "$TRIES" -ge 1 ]; then
    sleep 5
  fi
done

exit "$code"
