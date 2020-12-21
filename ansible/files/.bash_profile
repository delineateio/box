# shellcheck shell=bash
source /etc/skel/.bashrc # maintains colours :)
# shellcheck shell=bash
source /etc/environment # resets PATH
# shellcheck source=/dev/null
source "$HOME/.colours"
# shellcheck source=/dev/null
source "$HOME/.cargo/env"
# <!-- source END -->

alias clear="clear && figlet delineate.io | lolcat --seed 18" # overrides clear
alias home="cd ~/ && clear" # overrides clear
alias profile="bat ~/.bash_profile" # overrides clear
# <!-- alias END -->

export PATH=$PATH:/go/bin # golang
export PATH=$PATH:$HOME/.local/bin # pip3
# <!-- path END -->

export BAT_CONFIG_PATH="$HOME/.config/bat.conf"
GPG_TTY="$(tty)"
export GPG_TTY
# <!-- env END -->

# evals
eval "$(starship init bash)"
# <!-- eval END -->

clear
