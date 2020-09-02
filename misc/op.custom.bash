# NOTE: Requires "jq" command line json parser

# 1Password sign in
# Specify -f or --force to sign in even if a session token is present
opin() {
    if [ -z "$OP_SESSION_my" ] || [ "$1" == '--force' ] || [ "$1" == '-f' ]; then
        token=$(op signin my --raw) && \
        export OP_SESSION_my=$token
    fi
}

opout() {
    op signout
    # make sure session token is reset since its used by opsi to check for active session
    export OP_SESSION_my=''
}

# Lists titles of all items in 1Password, or, if a pattern is specified, items whose titles match the pattern
opls() {
    opin
    if [ "$?" -ne "0" ]; then
        return $?
    fi
    op list items | jq -r '.[].overview.title' | sort | ([ -z "$1" ] && cat || grep -i "$1")
}

# Gets the password of the first matching item title (uses regular expression via grep) 
opfind() {
    local OPTIND silent displayUserName opt
    while getopts ":su" opt; do
        case "${opt}" in
            s)
                silent=yes
                ;;
            u)
                displayUserName=yes
                ;;
        esac
    done
    shift $((OPTIND-1))

    if [ -z "$1" ]; then
        echo "You must specify a search criterium" >&2
        return 1
    fi

    opin
    if [ "$?" -ne "0" ]; then
        return $?
    fi
    found=$(opls "$1" | head -n 1)
    if [ -z "$found" ]; then
        echo "No items found matching \"$1\"" >&2
        return 2
    fi
    if [ -z "$silent" ]; then
        echo "Found \"$found\"" >&2
    fi
    if [ -z "$displayUserName" ]; then
        opget "$found"
    else
        opget -u "$found"
    fi
}

# Gets a specific password by its exact title (case insensitive)
opget() {
    local OPTIND displayUserName opt
    while getopts ":u" opt; do
        case "${opt}" in
            u)
                displayUserName=yes
                ;;
        esac
    done
    shift $((OPTIND-1))

    opin
    if [ "$?" -ne "0" ]; then
        return $?
    fi
    item=$(op get item "$1")
    user=$(printf "$item" | jq '.details.fields | map(select(.designation == "username").value)[0]' | trim \")
    pw=$(printf "$item" | jq '.details.fields | map(select(.designation == "password").value)[0]' | trim \" | tr -d '\n')
    if [ -n "$displayUserName" ]; then
        echo "$user"
    fi
    printf "$pw"
}

# Copies the first password found by its title (reg.ex.)
opcopy() {
    opin
    if [ "$?" -ne "0" ]; then
        return $?
    fi
    opfind -s "$1" | xclip -sel clip
}