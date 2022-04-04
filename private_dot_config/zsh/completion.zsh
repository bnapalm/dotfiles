zstyle ':completion:*' completer _expand_alias _extensions _complete _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' menu select=5

zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'

# Group completions by type
zstyle ':completion:*' group-name ''

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# k8s completion
(( $+commands[helm] )) && source <(helm completion zsh)

if (( $+commands[kubectl] )); then
  source <(kubectl completion zsh)
  compdef __start_kubectl k
fi
