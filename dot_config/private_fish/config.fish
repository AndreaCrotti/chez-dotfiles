set PATH ~/scripts ~/.local/bin ~/.cargo/bin ~/.jenv/bin /var/lib/snapd/snap/bin ~/.config/emacs/bin ~/.screenlayout ~/scripts ~/.babashka/bbin/bin ~/go/bin $PATH
status --is-interactive; and jenv init - | source

if status is-interactive
    source /opt/asdf-vm/asdf.fish
    direnv hook fish | source
    atuin init fish | source
    cowsay (fortune)
    # Commands to run in interactive sessions can go here
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f ~/.config/fish/google-cloud-sdk/path.fish.inc ]; . ~/.config/fish/google-cloud-sdk/path.fish.inc; end
set LSP_USE_PLISTS true

starship init fish | source
