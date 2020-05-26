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

# Lists all items in 1Password
opls() {
    opin && \
    op list items | jq -r '.[].overview.title' | sort | ([ -z "$1" ] && cat || grep -i $1)
}

# 1Password get password with name
pwfind() {
    opin
    if [ "$?" -eq "0" ]; then
        found=$(opls "$1" | head -n 1)
        if [ -z "$found" ]; then
            printf "No items found matching \"$1\"" >&2
            return 1
        fi
        echo "Found \"$found\""
        pwget "$found"
    fi
}

# Gets a specific password by its exact title (case insensitive)
pwget() {
    opin && \
    op get item "$1" \
        | jq '.details.fields | map(select(.designation == "password").value)[0]' \
        | trim \" \
        | tr -d '\n'
}

pwcopy() {
    pwfind "$1" | xclip -sel clip
}