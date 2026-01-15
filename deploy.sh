#!/bin/bash
# Deploy decks to SharePoint folder
# Reads destination from .env.local (gitignored)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env.local"

# Load config
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: .env.local not found"
    echo "Copy .env.local.example to .env.local and set your SharePoint path"
    exit 1
fi

source "$ENV_FILE"

if [ -z "$SHAREPOINT_DECKS_PATH" ]; then
    echo "Error: SHAREPOINT_DECKS_PATH not set in .env.local"
    exit 1
fi

# Check destination exists
if [ ! -d "$SHAREPOINT_DECKS_PATH" ]; then
    echo "Error: SharePoint folder not found: $SHAREPOINT_DECKS_PATH"
    echo "Make sure the folder is synced and mounted"
    exit 1
fi

# Deploy specific file or all
if [ -n "$1" ]; then
    # Deploy specific file
    if [ ! -f "$SCRIPT_DIR/docs/$1" ]; then
        echo "Error: File not found: docs/$1"
        exit 1
    fi
    cp "$SCRIPT_DIR/docs/$1" "$SHAREPOINT_DECKS_PATH"
    echo "✓ Deployed: $1"
else
    # Deploy all decks
    count=0
    for f in "$SCRIPT_DIR/docs/"*.html; do
        if [ -f "$f" ]; then
            cp "$f" "$SHAREPOINT_DECKS_PATH"
            echo "✓ $(basename "$f")"
            count=$((count + 1))
        fi
    done
    echo ""
    echo "Deployed $count decks to SharePoint"
fi
