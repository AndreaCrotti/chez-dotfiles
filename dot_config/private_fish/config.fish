set PATH ~/scripts ~/.local/bin ~/.cargo/bin ~/.jenv/bin /var/lib/snapd/snap/bin ~/.config/emacs/bin ~/.screenlayout ~/scripts ~/.babashka/bbin/bin ~/go/bin $PATH

if status is-interactive
    if test -e /opt/asdf-vm/asdf.fish
        source /opt/asdf-vm/asdf.fish
    end
    direnv hook fish | source
    atuin init fish | source
    cowsay (fortune)
    # Commands to run in interactive sessions can go here
    if type -q starship
        starship init fish | source
    end
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f ~/.config/fish/google-cloud-sdk/path.fish.inc ]; . ~/.config/fish/google-cloud-sdk/path.fish.inc; end
set LSP_USE_PLISTS true
