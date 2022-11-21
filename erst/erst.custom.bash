# COPY
# cp -v ~/.dotfiles/erst/erst.bash ~/.bash_it/custom/

alias t69='clear && ssh s-app-t69'

#export GRAILS_OPTS="-Xmx4G -Xms512m -Dfile.encoding=UTF-8 -Djava.encoding=UTF-8"
export GRAILS_OPTS="-Xmx4G -Xms512m -XX:MaxPermSize=512m -Dfile.encoding=UTF-8 -Djava.encoding=UTF-8" # Fixes issues with Grails 2/Java 7 PermGen during compile

# Connect to ERST VPN using openconnect and 1Password
vpn() {
    local itemname username passcode
    # Check connection before asking for passwords to avoid having to enter them multiple times.
    checkconnection &&
        sudo echo "sudo OK" &&
        itemname="ERST SIT VPN" &&
        opin && # log into 1password
        username=$(op item get "$itemname" --fields username) &&
        # pipe password on stdin line 1, passcode on line 2
        (echo $(op item get "$itemname" --fields password); echo $(op item get "$itemname" --otp)) | \
            sudo ~/src/gitlab/openconnect/openconnect/openconnect ext3.statens-it.dk --passwd-on-stdin --user "$username" --local-id device_uniqueid="`lsblk -r -o mountpoint,uuid |  grep '^/ ' |  cut -c3- |  tr -d '\n' | sha1sum | cut -d\  -f1 | tr '[:lower:]' '[:upper:]'`"
}

# Connect to ERST VPN using openconnect and 1Password - manual OTP prompt
vpnmanual() {
    local itemname username passcode
    # Check connection before asking for passwords to avoid having to enter them multiple times.
    checkconnection && 
        sudo echo "sudo OK" &&
        itemname="ERST SIT VPN" &&
        opin && # log into 1password
        username=$(op item get "$itemname" --fields username) &&
        # pipe password on stdin
        # note: since openconnect expects the second line on stdin to specify the passcode,
        # we need to create an empty prompt for this, which will pause openconnect while it
        # waits for user input:
        (echo $(op item get "$itemname" --fields password); read -s passcode; echo $passcode) | \
            sudo ~/src/gitlab/openconnect/openconnect/openconnect ext2.statens-it.dk --passwd-on-stdin --user "$username" --local-id device_uniqueid="`lsblk -r -o mountpoint,uuid |  grep '^/ ' |  cut -c3- |  tr -d '\n' | sha1sum | cut -d\  -f1 | tr '[:lower:]' '[:upper:]'`"
}

checkconnection() {
    wget -q --spider http://google.com || (echo "No internet connection!"; exit 1)
}

kodestandard() {
    local tmpdir
    tmpdir=/tmp/$(uuidgen) &&
    mkdir "$tmpdir" &&
    echo "$tmpdir" &&
    ([[ -n "$@" ]] &&
        # clone specific branch if specified in arguments:
        git clone git@rep.erst.dk:sector9/sector9-kodestandard.git "$tmpdir" --depth=1 --quiet --branch "$@" ||
        # otherwise clone default branch:
        git clone git@rep.erst.dk:sector9/sector9-kodestandard.git "$tmpdir" --depth=1 --quiet) &&
    cp -r "$tmpdir/gradle-templates/"* gradle &&
    cp "$tmpdir/.editorconfig" .
}
