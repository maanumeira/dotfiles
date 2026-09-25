# ===========================================================================
# Basado en github.com/alejandroferreiraiglesias/dotfiles (.zshrc)
# Adaptado: eliminadas rutas y aliases del autor (conda/Antigravity/proyectos).
# ===========================================================================

# Editor por defecto (git commit, crontab, etc.)
export EDITOR="micro"
export VISUAL="micro"

# Binarios locales del usuario
export PATH="$HOME/.local/bin:$PATH"

# ===========================================================================
# CAPA 1 — Historial robusto
# ===========================================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000          # entradas en memoria durante la sesión
SAVEHIST=100000          # entradas persistidas en disco

setopt EXTENDED_HISTORY       # guarda timestamp + duración de cada comando
setopt SHARE_HISTORY          # historial compartido en vivo entre pestañas
setopt INC_APPEND_HISTORY     # escribe cada comando al ejecutarlo, no al salir
setopt HIST_IGNORE_ALL_DUPS   # al añadir un dup, elimina las apariciones previas
setopt HIST_SAVE_NO_DUPS      # no escribe duplicados en el fichero
setopt HIST_FIND_NO_DUPS      # al buscar, no muestra el mismo comando repetido
setopt HIST_IGNORE_SPACE      # comandos que empiezan por espacio no se guardan
setopt HIST_REDUCE_BLANKS     # normaliza espacios sobrantes antes de guardar

# ===========================================================================
# compinit — el sistema de completado debe estar activo ANTES de cargar
# zsh-autosuggestions (usa su estrategia 'completion') y la integración de fzf.
# ===========================================================================
autoload -Uz compinit && compinit

# ===========================================================================
# CAPA 2 — Predicción de comandos (zsh-autosuggestions)
# Las variables deben fijarse ANTES del source del plugin.
# ===========================================================================
ZSH_AUTOSUGGEST_STRATEGY=(history completion)   # primero historial, luego completado
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'    # Catppuccin Mocha overlay0
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Aceptar la sugerencia palabra a palabra: 'forward-word' está en la lista de
# widgets de aceptación parcial del plugin, así que avanza consumiendo la
# sugerencia token a token. Se enlazan varias secuencias por robustez entre
# terminales (Ghostty, Terminal.app, iTerm2, VS Code...).
bindkey '^[[1;3C' forward-word   # Option + →
bindkey '^[[1;5C' forward-word   # Ctrl + →
bindkey '^[f'     forward-word   # fallback estilo emacs para Option + →

# ===========================================================================
# CAPA 3 — Búsqueda difusa del historial (fzf)
# Integración oficial: reconfigura Ctrl+R (historial difuso), Ctrl+T y Alt+C.
# ===========================================================================
# Colores del selector — tema oficial Catppuccin Mocha
export FZF_DEFAULT_OPTS="
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  --color=selected-bg:#45475a
  --color=border:#6c7086,label:#cdd6f4
  --height=40% --layout=reverse --border"
eval "$(fzf --zsh)"

# Tab inteligente — se define DESPUÉS de fzf porque su integración reengancha
# Tab; si no, fzf pisaría este binding. Si hay sugerencia visible (POSTDISPLAY
# = texto gris) la acepta; si no, delega en fzf-completion (que a su vez cae al
# completado normal cuando no usas el trigger '**'), conservando ambos mundos.
_tab_accept_or_complete() {
  if [[ -n "$POSTDISPLAY" ]]; then
    zle autosuggest-accept
  elif (( ${+widgets[fzf-completion]} )); then
    zle fzf-completion
  else
    zle expand-or-complete
  fi
}
zle -N _tab_accept_or_complete
bindkey '^I' _tab_accept_or_complete   # ^I es Tab

# ===========================================================================
# CAPA 4 — Herramientas CLI modernas
# ===========================================================================
# eza (reemplazo de ls): iconos y carpetas primero
alias ls='eza --icons=auto --group-directories-first'
alias ll='eza -l --icons=auto --group-directories-first --git'
alias la='eza -la --icons=auto --group-directories-first --git'
alias lt='eza --tree --level=2 --icons=auto'
# bat (reemplazo de cat) con colores de sintaxis; en pipe se comporta como cat
alias cat='bat --paging=never'
# zoxide: 'z <fragmento>' salta a carpetas ya visitadas; 'zi' elige con fzf
eval "$(zoxide init zsh)"
# Starship: prompt con git + entorno (config en ~/.config/starship.toml)
eval "$(starship init zsh)"
# direnv: carga variables por proyecto (.envrc). Va tras Starship.
eval "$(direnv hook zsh)"

# ===========================================================================
# conda (miniconda) — el prompt lo pinta Starship, por eso changeps1=false.
# Va ANTES de syntax-highlighting, que debe quedar el último del fichero.
# ===========================================================================
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# ===========================================================================
# zsh-syntax-highlighting — DEBE ser lo último del .zshrc para envolver
# correctamente todos los widgets definidos arriba.
# ===========================================================================
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Secretos y ajustes por máquina (API keys…): fichero fuera de git.
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
