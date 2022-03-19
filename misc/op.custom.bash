# 1Password sign in
# Specify -f to sign in even if a session token is present
opin() {
  local time_since_login session_duration_seconds
  time_since_login="$(bc <<<"$(date +%s) - ${OP_SESSION_CREATED:-0}")"
  session_duration_seconds=1800 # 30 minutes
  if [ -z "$OP_SESSION_my" ] || [ "$time_since_login" -ge "$session_duration_seconds" ] || [ "$1" == '-f' ]; then
    token=$(op signin --account my --raw) &&
      export OP_SESSION_my="$token" &&
      export OP_SESSION_CREATED="$(date +%s)"
  fi
}

opout() {
  op signout && export OP_SESSION_my='' && export OP_SESSION_CREATED=0
}
