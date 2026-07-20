set PATH ~/scripts ~/.local/bin ~/.cargo/bin /var/lib/snapd/snap/bin ~/.config/emacs/bin ~/scripts ~/.babashka/bbin/bin ~/go/bin ~/.fly/bin/ ~/.atuin/bin /usr/local/bin $PATH

if status is-interactive
    direnv hook fish | source
    atuin init fish | source
    fzf --fish | source
    if type -q zoxide
        zoxide init fish --cmd j | source
    end
    cowsay -f (cowsay -l | tail -n +2 | string split ' ' | shuf -n1) (fortune) | lolcat
    # Commands to run in interactive sessions can go here
    if type -q starship
        starship init fish | source
    end
end

set LSP_USE_PLISTS true
set -gx EDITOR nvim
set -gx RIPGREP_CONFIG_PATH ~/.config/ripgrep/ripgreprc

alias b 'bruno --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto'
alias e emacs
alias g ghostty
alias ls 'eza --icons'
alias p python
alias v nvim
alias z zellij
