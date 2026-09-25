# dotfiles

Configuración de mi Mac: terminal, shell, editor y Claude Code.
Versionada para poder reconstruirla en otra máquina sin repetir decisiones.

Punto de partida: el repo de [@alejandroferreiraiglesias](https://github.com/alejandroferreiraiglesias/dotfiles),
adaptado a mi perfil y a mi máquina. Lo que no entendía o no usaba, fuera.

## Qué hay dentro

| Ruta | Qué configura |
|---|---|
| `.zshrc` | Shell: historial, autocompletado, búsqueda difusa, prompt |
| `.gitconfig` | Identidad y `delta` como visor de diffs |
| `.config/ghostty/` | Terminal Ghostty + shaders de cursor (GLSL) |
| `.config/starship.toml` | Prompt |
| `.config/micro/` | Editor de terminal |
| `.claude/` | Claude Code: instrucciones globales, ajustes, statusline y skills |
| `Brewfile` | Herramientas y apps instaladas vía Homebrew |
| `macos/setup.sh` | Ajustes del sistema (Dock, tiling, Rectangle) |
| `bootstrap.sh` | Crea los symlinks en una máquina nueva |

## Instalación en una máquina nueva

```bash
git clone https://github.com/maanumeira/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
bash bootstrap.sh                  # symlinks
brew bundle --file=Brewfile        # herramientas y apps
bash macos/setup.sh                # ajustes del sistema
```

Después: crear `~/.zshrc.local` con las API keys, copiar
`.claude/user_context.example.md` a `~/.claude/user_context.md` y rellenarlo,
y dar permiso de Accesibilidad a Rectangle.

## Decisiones

**Symlinks, no copias.** `bootstrap.sh` mueve el enlace, no el contenido.
Editar `~/.zshrc` es editar el fichero del repo. Con copias acabas con dos
versiones divergentes y ninguna manda.

**Los secretos nunca entran en git.** El `.zshrc` termina cargando
`~/.zshrc.local`, que está en `.gitignore`. Las API keys van ahí. Lo que entra
en el historial de git se queda, aunque lo borres en un commit posterior.

**El perfil personal tampoco.** `.claude/user_context.md` lleva datos míos y
está ignorado; en el repo solo queda la plantilla vacía.

**Orden en el `.zshrc`.** No es arbitrario: `compinit` antes que
`zsh-autosuggestions` (usa su estrategia de completado), fzf antes del binding
de Tab (si no, fzf lo pisa), y `zsh-syntax-highlighting` el último de todo
para que envuelva los widgets ya definidos.

**Tab inteligente.** Si hay sugerencia gris visible la acepta; si no, delega en
`fzf-completion`, que a su vez cae al completado normal. Así no hay que elegir
entre autosuggestions y fzf.

**Ctrl+Opt+Flecha-arriba maximiza.** Por defecto era "mitad superior". Es un
compromiso consciente: maximizar se usa mucho más. Está comentado en
`macos/setup.sh`.

**El tiling nativo de macOS está desactivado.** Competía con Rectangle por el
mismo gesto (arrastrar al borde). Solo se desactiva el arrastre; los atajos
nativos `Fn+Ctrl+flechas` siguen funcionando.

**Los hooks del repo original no están.** Uno de ellos bloqueaba el primer
Grep/Read de cada sesión de Claude Code para forzar el uso de un MCP que no
tengo instalado.
