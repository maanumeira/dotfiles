#!/usr/bin/env bash
# Ajustes de macOS reproducibles. Idempotente.
# Ejecutar DESPUÉS de instalar las apps (brew bundle). Uso: bash macos/setup.sh
#
# Cada ajuste se revierte con 'defaults delete <dominio> <clave>'.
set -euo pipefail

echo "Dock / Spaces..."
# Al arrastrar una ventana contra el borde lateral, macOS cambia de escritorio
# tras 0,75 s. Es una causa habitual de "se me ha ido la ventana". Subir el
# retardo a 60 s lo desactiva en la práctica sin tocar la función.
defaults write com.apple.dock workspaces-edge-delay -float 60

echo "Tiling nativo de macOS..."
# macOS trae su propio gestor de ventanas por arrastre al borde, que compite
# con Rectangle por el MISMO gesto. Con los dos activos el resultado es
# impredecible. Se desactiva el de macOS y manda Rectangle.
# Los atajos de teclado nativos (Fn+Ctrl+flechas) NO se tocan.
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false

echo "Rectangle..."
# Set de atajos "recomendado" de Rectangle = Ctrl+Opt+flechas.
# (Con esta clave en false usaría el set estilo Spectacle: Cmd+Opt+flechas.)
defaults write com.knollsoft.Rectangle alternateDefaultShortcuts -bool true

# Al repetir el mismo atajo, en vez de ciclar anchos (1/2 -> 1/3 -> 2/3),
# manda la ventana al monitor contiguo. Solo útil con varios monitores.
defaults write com.knollsoft.Rectangle subsequentExecutionMode -int 1

# "Casi maximizar" deja la ventana al 90% por defecto; a 1.0 la deja al 100%.
defaults write com.knollsoft.Rectangle almostMaximizeWidth -float 1.0
defaults write com.knollsoft.Rectangle almostMaximizeHeight -float 1.0

# Maximizar en Ctrl+Opt+Flecha-arriba (keyCode 126).
# COMPROMISO CONSCIENTE: esa combinación era "mitad superior" por defecto.
# Se cede topHalf a cambio de maximizar con la flecha arriba, que se usa mucho
# más. La mitad inferior (Ctrl+Opt+abajo) sigue intacta.
# modifierFlags 786432 = Control (262144) + Option (524288).
defaults write com.knollsoft.Rectangle maximize -dict-add keyCode -float 126 modifierFlags -float 786432

# Ctrl+Opt+Return (keyCode 36) era el "maximizar" de fábrica de Rectangle.
# Se le asigna "casi maximizar", que está al 100%, para conservar esa memoria
# muscular. Resultado: dos atajos que maximizan, a propósito.
defaults write com.knollsoft.Rectangle almostMaximize -dict-add keyCode -float 36 modifierFlags -float 786432

echo "conda..."
# El prompt lo pinta Starship (tiene módulo [conda]); sin esto el nombre del
# entorno saldría duplicado.
conda config --set changeps1 false 2>/dev/null || true

killall Rectangle Dock 2>/dev/null || true
echo
echo "Ajustes aplicados. Recuerda dar permiso de Accesibilidad a Rectangle en"
echo "Ajustes del Sistema > Privacidad y seguridad > Accesibilidad."
