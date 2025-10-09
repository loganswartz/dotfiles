#!/usr/bin/env bash

WOBSOCK="${WOBSOCK:-$XDG_RUNTIME_DIR/wob.sock}"
echo "Attempting to create wob socket at $WOBSOCK..." >&2

pkill wob
rm -f "$WOBSOCK"

if ! mkfifo "$WOBSOCK"; then
  echo "Failed to create wob socket at $WOBSOCK" >&2
  exit 1
fi

tail -f "$WOBSOCK" | wob &
echo "Created wob socket at $WOBSOCK" >&2
