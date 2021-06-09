# COPY
# cp -v ~/.dotfiles/erst/erst.bash ~/.bash_it/custom/

# ERST docker settings
export DOCKER_HOST="tcp://127.0.0.1:2375"

# Connect to ERST VPN using openconnect and 1Password
vpn() {
    local itemname username passcode
    sudo echo "sudo OK" &&
        itemname="^ERST SIT VPN$" &&
        opin && # log into 1password
        username=$(opfield "$itemname" username) && # get username from 1password
        # pipe password on stdin
        # note: since openconnect expects the second line on stdin to specify the passcode,
        # we need to create an empty prompt for this, which will pause openconnect while it
        # waits for user input:
        (opfield "$itemname" password; read -s passcode; echo $passcode) | \
            sudo ~/src/gitlab/openconnect/openconnect-add_local_id_option/openconnect ext2.statens-it.dk --passwd-on-stdin --user "$username" --local-id device_uniqueid="`lsblk -r -o mountpoint,uuid |  grep '^/ ' |  cut -c3- |  tr -d '\n' | sha1sum | cut -d\  -f1 | tr '[:lower:]' '[:upper:]'`"
}
