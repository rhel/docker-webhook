#!/bin/sh

set -e

if [ -n "$UID"  ] && [ -n "$GID" ]; then
    # be sure that $UID and $GID variables are integers
    _UID=$(echo "$UID" | awk '{ print $1 + 0 }')
    _GID=$(echo "$GID" | awk '{ print $1 + 0 }')

    exec su-exec $_UID:$_GID "$@"
fi

exec "$@"