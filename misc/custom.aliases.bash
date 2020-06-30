# COPY
# cp -v ~/.dotfiles/misc/custom.aliases.bash ~/.bash_it/aliases/

# Clipboard
alias c='xclip -sel clip'
alias v='xclip -o'

# Gradle:
alias gw='./gradlew'
alias gwcb='./gradlew clean bootRun'
alias gwcc='./gradlew clean check ; alert'
alias gwccc='./gradlew clean check -DENABLE_CLOVER=true ; alert'
alias gwct='./gradlew clean test integrationTest ; alert'
alias gwnarc='./gradlew codenarcAll ; alert'

# Nice path
alias path='echo -e ${PATH//:/\\n}'

# From: http://askubuntu.com/questions/409611/desktop-notification-when-long-running-commands-complete
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'