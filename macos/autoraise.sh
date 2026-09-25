#!/usr/bin/env bash
# Compila e instala AutoRaise (foco sigue al ratón) desde el código fuente.
#
# NO usar el tap de Homebrew 'sbmpost/autoraise': la fórmula lleva sin
# actualizarse desde 2023, mientras el proyecto sigue vivo.
#
# Uso: bash macos/autoraise.sh
set -euo pipefail

BUILD_DIR="$(mktemp -d)"
trap 'rm -rf "$BUILD_DIR"' EXIT

echo "Clonando..."
git clone --depth 1 -q https://github.com/sbmpost/AutoRaise.git "$BUILD_DIR/AutoRaise"
cd "$BUILD_DIR/AutoRaise"

echo "Compilando..."
# 'make build' compila con -DOLD_ACTIVATION_METHOD -DEXPERIMENTAL_FOCUS_FIRST.
# El segundo es IMPRESCINDIBLE: sin él, focusDelay no funciona y AutoRaise
# reordena las ventanas en vez de solo pasar el foco. Un 'make' a secas no
# incluye esos flags.
make build

echo "Instalando en /Applications..."
make install

echo "Registrando el arranque al inicio de sesión..."
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.sbmpost.autoraise.plist" 2>/dev/null || true

echo
echo "Hecho. Falta un paso manual:"
echo "  Ajustes del Sistema > Privacidad y seguridad > Accesibilidad > activar AutoRaise"
