export PATH=$PATH:~/.local/bin/

source <(fzf --zsh)

# zsh history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

alias c='clear'
alias ff='fastfetch'
alias ls='eza -a --icons=always'
alias ll='eza -al --icons=always'
alias lt='eza -a --tree --level=1 --icons=always'
alias paru='yay'
alias s='yay -S'
alias ss='yay -Ss'
alias shutdown='systemctl poweroff'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

if [[ $(tty) == *"pts"* ]]; then
    fastfetch
fi
