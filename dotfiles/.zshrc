export PATH=$PATH:~/.local/bin/:$HOME/go/bin

eval "$(starship init zsh)"

source <(fzf --zsh)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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

alias zed='zeditor'

alias shutdown='systemctl poweroff'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

if [[ $(tty) == *"pts"* ]]; then
    fastfetch
fi
