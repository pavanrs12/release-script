#!/usr/bin/env bash

# Quote nesting works as described here: http://stackoverflow.com/a/6612417/4972
# SCRIPT_DIR via http://www.ostricher.com/2014/10/the-right-way-to-get-the-directory-of-a-bash-script/
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $(basename $0) = "wait_for_deploy.sh" ]]; then
    set -euf -o pipefail

    # Default variables to empty if not present. Necessary due to the -u option specified above.
    # For more information on this, look here:
    # http://redsymbol.net/articles/unofficial-bash-strict-mode/#solution-positional-parameters

    # These need to be defined to something to be referenced, but ${1:-} will be empty if it's not supplied
    REPO_DIR="${1:-}"
    HASH_URL="${2:-}"
    WATCH_BRANCH="${3:-}"

    if [[ -z "$REPO_DIR" ]]; then
        echo "You must specify your git repo directory as the first argument."
        exit 1
    fi

    if [[ "$HASH_URL" != https* ]]; then
        echo "You must specify a hash URL to compare with the release candidate."
        echo "For example, for micromasters https://micromasters-rc.herokuapp.com/static/hash.txt"
        exit 1
    fi

    if [[ -z "$WATCH_BRANCH" ]]
    then
        echo "You must specify a branch whose latest commit will match the deployed hash"
        echo "for example release-candidate or release"
        exit 1
    fi

    REPO_URL=$(git --git-dir "$REPO_DIR"/.git remote get-url origin)

    python3 "$SCRIPT_DIR"/wait_for_deploy.py "$REPO_URL" "$HASH_URL" "$WATCH_BRANCH"
fi