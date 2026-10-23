#!/usr/bin/env bash
# Собирает архив для загрузки в консоль Яндекс Игр: выключает TEST_MODE и пакует index.html.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf dist && mkdir -p dist/game
sed 's/^const TEST_MODE = true;/const TEST_MODE = false;/' index.html > dist/game/index.html
grep -q '^const TEST_MODE = false;' dist/game/index.html || { echo "Не нашёл строку TEST_MODE в index.html" >&2; exit 1; }
(cd dist/game && zip -q ../pirate-treasures.zip index.html)
echo "Готово: dist/pirate-treasures.zip"
