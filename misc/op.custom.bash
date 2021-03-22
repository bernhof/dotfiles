# NOTE: Requires "jq" command line json parser

# 1Password sign in
# Specify -f to sign in even if a session token is present
opin() {
  local time_since_login session_duration_seconds
  time_since_login="$(bc <<<"$(date +%s) - ${OP_SESSION_CREATED:-0}")"
  session_duration_seconds=1800 # 30 minutes
  if [ -z "$OP_SESSION_my" ] || [ "$time_since_login" -ge "$session_duration_seconds" ] || [ "$1" == '-f' ]; then
    token=$(op signin my --raw) &&
      export OP_SESSION_my="$token" &&
      export OP_SESSION_CREATED="$(date +%s)"
  fi
}

opout() {
  op signout && export OP_SESSION_my='' && export OP_SESSION_CREATED=0
}

opfield() {
  local title field uuid
  opin &&
    title=${1/\"/\\\"} &&
    field=${2/\"/\\\"} &&
    # get uuid of item:
    uuid=$(op list items |
      jq -r ".[] | select(.overview.title|test(\"(?i)$title\")) | .uuid") &&
    op get item "$uuid" | # print value of specified field
      jq -r ".details.fields | map(select(.designation==\"$field\").value)[0]"
}

# Lists titles of all items in 1Password, or, if a pattern is specified, items whose titles match the pattern
opls() {
  opin &&
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
  shift $((OPTIND - 1))

  [ -z "$1" ] &&
    echo "You must specify a search criterium" >&2 &&
    return 1

  opin || return $?
  found=$(opls "$1" | head -n 1)

  [ -z "$found" ] &&
    echo "No items found matching \"$1\"" >&2 &&
    return 2

  [ -z "$silent" ] && echo "Found \"$found\"" >&2
  ([ -z "$displayUserName" ] && opget "$found") || opget -u "$found"
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
  shift $((OPTIND - 1))

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
  opin &&
    opfind -s "$1" | xclip -sel clip
}
