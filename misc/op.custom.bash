# 1Password sign in
# Specify -f or --force to sign in even if a session token is present
opsi() {
    if [ -z "$OP_SESSION_my" ] || [ "$1" == '--force' ] || [ "$1" == '-f' ]; then
        token=$(op signin my --raw) && \
        export OP_SESSION_my=$token
    fi
}

opso() {
    op signout
    # make sure session token is reset since its used by opsi to check for active session
    export OP_SESSION_my=''
}

# 1Password get password with name
oppwx() {
    opsi
    if [ "$?" -eq "0" ]; then
        found=$(opls "$1" | head -n 1)
        if [ -z "$found" ]; then
            printf "No items found matching \"$1\"" >&2
            return 1
        fi
        echo "$found"
        oppw "$found"
    fi
}

oppw() {
    opsi && \
    op get item "$1" \
        | jq '.details.fields | map(select(.designation == "password").value)[0]' \
        | trim \" \
        | tr -d '\n'
}

opls() {
    opsi && \
    op list items | jq '.[].overview | { title | opalias }' | trim \" | ([ -z "$1" ] && cat || grep -i $1)
}