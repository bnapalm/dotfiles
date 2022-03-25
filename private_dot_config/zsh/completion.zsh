zstyle ':completion:*' completer _expand_alias _extensions _complete _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' menu select=5

# k8s completion
(( $+commands[helm] )) && source <(helm completion zsh)

if (( $+commands[kubectl] )); then
  source <(kubectl completion zsh)
  compdef __start_kubectl k
fi
