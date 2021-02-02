# COPY
# cp -v ~/.dotfiles/erst/erst.bash ~/.bash_it/custom/

# ERST docker settings
export DOCKER_HOST="tcp://127.0.0.1:2375"

oc() {
    sudo echo "sudo OK"
    local itemname username passcode
    itemname="^ERST VPN$"
    # log into 1password
    opin
    # abort if login fails
    if [ "$?" -ne "0" ]; then
        return $?
    fi
    # get username from 1password
    username=$(opfield "$itemname" username)
    # pipe password on stdin
    # note: since openconnect expects the second line on stdin to specify the passcode,
    # we need to create an empty prompt for this, which will pause openconnect while it
    # waits for user input:
    (opfield "$itemname" password; read -s passcode; echo $passcode) | \
        sudo openconnect vpn.erst.dk -u "$username" --passwd-on-stdin
}
