#!/bin/bash
# Git for Windows 최신 버전 다운로드 스크립트

RELEASE=$(curl -s https://api.github.com/repos/git-for-windows/git/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
VERSION=$(echo "$RELEASE" | sed 's/v//;s/\.windows\..*//')
URL="https://github.com/git-for-windows/git/releases/download/${RELEASE}/Git-${VERSION}-64-bit.exe"

echo "다운로드 중: Git-${VERSION}-64-bit.exe"
wget -q --show-progress "$URL" -O "Git-${VERSION}-64-bit.exe"
echo "완료: Git-${VERSION}-64-bit.exe"
