export GH_TOKEN=3785752661c0346e5c336d7231ba5af76894b819
export JOB_BASE_NAME=localtest
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3

# HELM Setting
export TILLER_NAMESPACE=tesla-staging
export RSLI_CHART_ROOT=${HOME}/Development/qem/charts
export RSLI_USERNAME=brad2913

prun() {
    run_call="poetry"
    if [ -e Pipfile ]; then
        run_call="pipenv"
    fi
    $run_call run "$@"
}

clean_pyc() {
    find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf
}


parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

merged_update() {
    current_branch=$(parse_git_branch)
    upstream_remote=${PROFILE_UPSTREAM_REMOTE:-upstream}
    merge_branch=${PROFILE_MERGE_BRANCH:-master}
    do_origin_push=${PROFILE_GMM_PUSH:-false}

    echo Updating "$merge_branch" with "$current_branch" post-merge
    git checkout "$merge_branch" && git pull "$upstream_remote" "$merge_branch" && git branch -d "$current_branch"
    if [ "$do_origin_push" = true ]; then
        git push origin "$merge_branch"
    fi

}
alias ,gmm='merged_update'

pr_bump() {
    currentbranch=$(parse_git_branch)
    prnum=$(echo "$currentbranch" | sed -E "s/^pr\/(.*)/\1/g")
    if ! [[ "$currentbranch" =~ pr/* ]]; then
        echo "$currentbranch" is not a PR Branch!
        return
    fi
    echo Updating "$currentbranch"
    git checkout master && git pr clean && git pr "$prnum" upstream
}

last_sun() {
    date -v -Sun -v -1w +%Y-%m-%d
}

master_merge() {
    git checkout master && git pull origin master && ,tb "$1" && git merge master
}

# Work-specific Aliases
alias .jjb='rm -rf ~/jjb && ./build-jobs.sh --test -o ~/jjb && ./build-jobs.sh --cluster --test -o ~/jjb'
alias .jirawk="jira-search-issues \"project in (DLA, DLB) and assignee = currentUser() and status changed after $(last_sun)\""
alias .jirarev="jira-search-issues \"project = (DLA, DLB) AND status != Closed AND Collaborators = currentUser()\""
alias xls="exa --long --header --git"
alias xlt="xls -T -L 2"
alias dcf="docker-compose --file docker-compose.ci.yml"
alias dcr="dcf run"
alias ghcs="ssh -p 2222 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null root@localhost"


# Random Helpers
function restoreMonitors() {
    displayplacer "id:8E5D699E-72D7-E0F7-1B96-4074678CDB4D res:3440x1440 hz:50 color_depth:8 scaling:off origin:(0,0) degree:0" "id:F38C2356-06EF-ADE3-1ADF-6B31FE209B31 res:1890x3360 hz:60 color_depth:8 scaling:on origin:(-1890,-1238) degree:90" "id:12050794-68E2-D325-D7B2-168DC0FA36D3 res:1890x3360 hz:60 color_depth:8 scaling:on origin:(3440,-716) degree:90"
}

function restoreSidecar() {
    displayplacer "id:8E5D699E-72D7-E0F7-1B96-4074678CDB4D res:3440x1440 hz:50 color_depth:8 scaling:off origin:(0,0) degree:0" "id:F38C2356-06EF-ADE3-1ADF-6B31FE209B31 res:1890x3360 hz:60 color_depth:8 scaling:on origin:(-1890,-1185) degree:90" "id:12050794-68E2-D325-D7B2-168DC0FA36D3 res:1890x3360 hz:60 color_depth:8 scaling:on origin:(3440,-816) degree:90" "id:6161706C-6950-6164-0000-053900000000 res:1302x1024 hz:60 color_depth:4 scaling:on origin:(1040,1440) degree:0"
}

function resetQL() {
    xattr -d -r com.apple.quarantine ~/Library/QuickLook
    qlmanage -r
}

# branch searcher
function tb() {
    git branch | sed -n -e 's/^.* //' -e /"$1"/p | xargs -n 1 git checkout
}
alias ,tb=tb

# GH assign
function gta () {
    FLAG="-a"
    if [ "$SHELL" = "/bin/zsh" ]; then
        FLAG="-A"
    fi
    IFS=':' read -r $FLAG assignees <<< "$GH_ASSIGNEES"
    gt-assign-pr "$GH_OWNER" "$GH_REPO" "$1" "${assignees[@]}"
}

# tmux helpers
function join_by { local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}";  }

_tmux_send_keys_all_panes_ () {
    # to_send=`join_by " Space " "$@"`
    to_send="$*"
    for _pane in $(tmux list-panes -F '#P'); do
        tmux send-keys -t "${_pane}" "$to_send" Enter
    done
}
alias tmpp="_tmux_send_keys_all_panes_"


get_env_vars() {
    set -a
    eval "$(~/.local/bin/set_local_creds.py "$1")"
}

set_aws_creds() {
    aws-mfa --profile "$1"
}

aws_init() {
    set_aws_creds "$1"
    get_env_vars "$1"
}


ops() {
    eval "$(op signin my)"
}

op-unitas() {
    op list items --tags=unitas,ldap | op get item - | jq -r '.details.fields | map(select(.designation == "password")) | .[0].value'
}

alias vpn='/opt/cisco/anyconnect/bin/vpn'

op-vpn() {
    ops
    PW=$(op-unitas)
    expect "${HOME}/dotfiles/vpn.exp" "$PW"
}

op-aws() {
    TK=$(op list items --tags=aws,nrccua | op get totp -)
    if [ "$1" = "--cli" ]; then
        echo "$TK"
        exit
    fi
    echo "$TK" | pbcopy
    echo "Token copied successfully!"
}

aws-init() {
    ops
    TK=$(op-aws --cli)
    yes "$TK" | aws-mfa --profile brad.brown
}
