#!/usr/bin/env bash
# Собирает архив для загрузки в консоль Яндекс Игр: выключает TEST_MODE, подключает шрифты из папки fonts
# вместо Google Fonts (в архиве всё должно лежать рядом с игрой) и пакует index.html.
# ./build.sh --test собирает тестовый архив: TEST_MODE остаётся включённым.
set -euo pipefail
cd "$(dirname "$0")"
test=${1:-}
name=pirate-treasures; mode=false
[ "$test" = "--test" ] && { name=pirate-treasures-test; mode=true; }
rm -rf dist/game && mkdir -p dist/game
sed -e "s/^const TEST_MODE = true;/const TEST_MODE = $mode;/" \
    -e '/<link rel="preconnect" href="https:\/\/fonts\./d' \
    -e 's#<link rel="stylesheet" href="https://fonts.googleapis.com/[^"]*">#<link rel="stylesheet" href="fonts/fonts.css">#' \
    index.html > dist/game/index.html
grep -q "^const TEST_MODE = $mode;" dist/game/index.html || { echo "Не нашёл строку TEST_MODE в index.html" >&2; exit 1; }
grep -q 'fonts.googleapis' dist/game/index.html && { echo "В index.html осталась ссылка на Google Fonts" >&2; exit 1; }
cp -r fonts dist/game/
rm -f "dist/$name.zip"
(cd dist/game && zip -qr "../$name.zip" index.html fonts)
echo "Готово: dist/$name.zip"
