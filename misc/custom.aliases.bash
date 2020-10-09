# COPY
# cp -v ~/.dotfiles/misc/custom.aliases.bash ~/.bash_it/aliases/

# Clipboard
alias c='xclip -sel clip'
alias v='xclip -o'

# Gradle:
alias gw='./gradlew -g ~/.gradle5'
alias gwcb='gw clean bootRun'
alias gwcc='gw clean check --continue ; alert'
alias gwccc='gw clean check -DENABLE_CLOVER=true --continue ; alert'
alias gwct='gw clean test integrationTest --continue; alert'
alias gwnarc='gw codenarcAll --continue; alert'

# Nice path
alias path='echo -e ${PATH//:/\\n}'

# From: http://askubuntu.com/questions/409611/desktop-notification-when-long-running-commands-complete
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
