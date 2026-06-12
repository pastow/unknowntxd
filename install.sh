#!/usr/bin/env bash
set -euo pipefail

ScriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ScriptDir"

# Сборка проекта
./build.sh Release

BIN_DIR="$HOME/.local/bin"
APP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons/hicolor/256x256/apps"
MIME_DIR="$HOME/.local/share/mime/packages"

echo "Creating directories..."
mkdir -p "$BIN_DIR" "$APP_DIR" "$ICON_DIR" "$MIME_DIR"

echo "Installing binary..."
cp build/UnknownTxd "$BIN_DIR/unknowntxd"
chmod +x "$BIN_DIR/unknowntxd"

echo "Installing icon..."
# Используем logo.png в качестве иконки
cp logo.png "$ICON_DIR/unknowntxd.png"

echo "Installing MIME type..."
cat << 'EOF' > "$MIME_DIR/unknowntxd-mime.xml"
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="application/x-renderware-txd">
    <comment>RenderWare Texture Dictionary</comment>
    <comment xml:lang="ru">Архив текстур RenderWare</comment>
    <glob pattern="*.txd"/>
    <glob pattern="*.TXD"/>
    <icon name="unknowntxd"/>
  </mime-type>
</mime-info>
EOF

echo "Installing Desktop Entry..."
cat << EOF > "$APP_DIR/unknowntxd.desktop"
[Desktop Entry]
Name=UnknownTxd
Comment=RenderWare Texture Dictionary Editor
Comment[ru]=Редактор архивов текстур RenderWare
Exec=$BIN_DIR/unknowntxd %f
Icon=unknowntxd
Terminal=false
Type=Application
Categories=Utility;Graphics;3DGraphics;
MimeType=application/x-renderware-txd;
EOF

echo "Updating system databases..."
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$APP_DIR"
fi

if command -v update-mime-database &> /dev/null; then
    update-mime-database "$HOME/.local/share/mime"
fi

if command -v gtk-update-icon-cache &> /dev/null; then
    gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor" || true
fi

echo "=================================================="
echo "Installation complete! 🎉"
echo "You can now open .txd files by double-clicking them in your file manager."
echo "You can also find UnknownTxd in your application launcher."
echo "Executable is located at: $BIN_DIR/unknowntxd"
echo "=================================================="
