#!/usr/bin/env bash
# start.sh — Kill any stale Mineradio Electron processes, then run npm start.
# Usage:  bash start.sh   (or  ./start.sh  after  chmod +x start.sh)

set -u
cd "$(dirname "$0")"
ROOT="$(pwd)"

OWN_PID="$$"

# ---- 1. Find and kill existing Electron processes for this project. ----
# Match the project's own node_modules/electron path so we never touch
# unrelated Electron apps the user may be running.
PIDS=$(ps -axo pid,command \
  | grep -F "$ROOT/node_modules/electron" \
  | grep -v "grep" \
  | awk '{print $1}' \
  | grep -v "^${OWN_PID}$" \
  | tr '\n' ' ')

if [ -n "$(echo "$PIDS" | tr -d ' ')" ]; then
  COUNT=$(echo "$PIDS" | tr -s ' ' '\n' | grep -c '.' || echo 0)
  echo "[start.sh] Killing $COUNT stale Electron process(es): $PIDS"
  kill $PIDS 2>/dev/null || true
  WAITED=0
  while [ $WAITED -lt 5 ]; do
    WAITED=$((WAITED + 1))
    sleep 1
    STILL_ALIVE=0
    for pid in $PIDS; do
      if kill -0 "$pid" 2>/dev/null; then STILL_ALIVE=1; fi
    done
    [ $STILL_ALIVE -eq 0 ] && break
  done
  for pid in $PIDS; do
    if kill -0 "$pid" 2>/dev/null; then
      echo "[start.sh] Force-killing pid $pid"
      kill -9 "$pid" 2>/dev/null || true
    fi
  done
else
  echo "[start.sh] No stale Electron processes."
fi

# ---- 2. Launch dev mode. exec replaces bash so Ctrl+C reaches npm directly. ----
echo "[start.sh] Starting: npm start (Ctrl+C to quit)"
exec npm start
