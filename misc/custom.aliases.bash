# COPY
# cp -v ~/.dotfiles/misc/custom.aliases.bash ~/.bash_it/aliases/

# Clipboard
alias c='xclip -sel clip'
alias v='xclip -o'

# Gradle:
alias gw='./gradlew --info'
alias gwb='gw bootRun'
alias gwcb='gw clean bootRun'
alias gwct='gw clean test codenarcAll --continue; alert'
alias gwcc='gw clean check --continue; alert'
alias gwnarc='gw codenarcAll --continue; alert'

# Grails:
alias grw='./grailsw'
alias grwc='grw clean-all && grw compile'
alias grwcr='grw clean-all && grw compile && grw run-app'
alias grwct='grw clean-all && grw compile && grw test-app'

# Nice path
alias path='echo -e ${PATH//:/\\n}'

# Docker compose
alias dc='docker-compose'

function dcr() {
    docker-compose stop $@ &&
    docker-compose up -d --build $@
}

function dcrf() {
    dcr $@ && dc logs -f $@
}

# From: http://askubuntu.com/questions/409611/desktop-notification-when-long-running-commands-complete
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
