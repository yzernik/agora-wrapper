#!/bin/bash

DURATION=$(</dev/stdin)
if (($DURATION <= 10000 )); then
    exit 60
else
    curl --silent agora.embassy:8080 &>/dev/null
    RES=$?
    if test "$RES" != 0; then
        echo "The Agora UI is unreachable" >&2
        exit 1
    fi
fi
