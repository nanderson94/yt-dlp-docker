#!/bin/sh

FAIL=0

for validate_cmd in ffmpeg ffprobe yt-dlp; do
  if command -v $validate_cmd > /dev/null 2>&1; then
    echo "[PASS] ${validate_cmd} is available"
  else
    echo "[FAIL] ${validate_cmd} is missing"
    FAIL=1
  fi
done

if [ $FAIL -ne 0 ]; then
  exit 2
fi
