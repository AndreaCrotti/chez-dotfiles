set PATH ~/scripts ~/.local/bin ~/.cargo/bin /var/lib/snapd/snap/bin ~/.config/emacs/bin ~/scripts ~/.babashka/bbin/bin ~/go/bin ~/.fly/bin/ ~/.atuin/bin /usr/local/bin $PATH

if status is-interactive
    direnv hook fish | source
    atuin init fish | source
    cowsay -f (cowsay -l | tail -n +2 | string split ' ' | shuf -n1) (fortune) | lolcat
    # Commands to run in interactive sessions can go here
    if type -q starship
        starship init fish | source
    end
end

set LSP_USE_PLISTS true
