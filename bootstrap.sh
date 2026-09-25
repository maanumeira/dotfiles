#!/usr/bin/env bash
# Crea los symlinks de los dotfiles en $HOME. Idempotente: se puede
# ejecutar las veces que haga falta sin romper nada.
#
# Uso: bash bootstrap.sh
set -euo pipefail

DF="$(cd "$(dirname "$0")" && pwd)"

link() {
  local rel
  local src
  local dst
  rel="$1"
  # Guardia imprescindible: con $rel vacío, las rutas quedarían en "$HOME/"
  # y un mv/ln podría actuar sobre el home entero.
  if [ -z "$rel" ]; then
    echo "  ABORTA: se ha llamado a link() sin argumento" >&2
    return 1
  fi
  src="$DF/$rel"
  dst="$HOME/$rel"

  if [ ! -e "$src" ]; then
    echo "  omitido (no está en el repo): $rel"
    return 0
  fi

  mkdir -p "$(dirname "$dst")"

  # Si ya hay un fichero real (no un symlink), se aparta con fecha.
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.backup.$(date +%Y%m%d_%H%M%S)"
    echo "  backup del $rel existente"
  fi

  ln -sfn "$src" "$dst"
  echo "  ✓ $rel"
}

echo "Enlazando dotfiles desde $DF"
link ".zshrc"
link ".gitconfig"
link ".config/ghostty"
link ".config/starship.toml"
link ".config/micro"
link ".config/git/ignore"
link ".claude/CLAUDE.md"
link ".claude/settings.json"
link ".claude/statusline-command.sh"
link ".claude/skills"
link ".config/AutoRaise/config"
link "Library/LaunchAgents/com.sbmpost.autoraise.plist"

chmod +x "$DF/.claude/statusline-command.sh" 2>/dev/null || true

cat <<'SIGUIENTE'

Hecho. Pasos siguientes en una máquina nueva:
  1) brew bundle --file=Brewfile     # instala herramientas y apps
  2) bash macos/setup.sh             # ajustes del sistema
  3) Secretos: crear ~/.zshrc.local con las API keys (está fuera de git)
  4) Perfil: crear ~/.claude/user_context.md a partir de user_context.example.md
  5) Rectangle: conceder permiso en Ajustes > Privacidad > Accesibilidad
  6) AutoRaise: bash macos/autoraise.sh (compila desde fuente) + Accesibilidad
SIGUIENTE
