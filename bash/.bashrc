# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# claude を常に auto mode で起動
alias claude='claude --permission-mode auto'

# --- .zshrc と揃える設定 (Omarchy の rc で未カバーの分だけ) ---
# zsh の SHARE_HISTORY 相当: コマンドごとに履歴を書き出し、他のシェルの新しい分を取り込む
# (histappend / HISTSIZE / HISTCONTROL=ignoreboth は Omarchy の rc が設定済み)
PROMPT_COMMAND="history -a; history -n${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
# zsh の bindkey -e 相当 (bash の既定値だが明示)
set -o emacs
# zsh と同じ色付き ls / grep。ls は Omarchy が eza に置き換えるので、eza が無い時だけ
command -v eza >/dev/null 2>&1 || alias ls='ls --color=auto'
alias grep='grep --color=auto'
