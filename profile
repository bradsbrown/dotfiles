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
    current_branch=`parse_git_branch`
    upstream_remote=${PROFILE_UPSTREAM_REMOTE:-upstream}
    merge_branch=${PROFILE_MERGE_BRANCH:-master}
    do_origin_push=${PROFILE_GMM_PUSH:-true}

    echo Updating $merge_branch with $current_branch post-merge
    git checkout $merge_branch && git pull $upstream_remote $merge_branch && git branch -d $current_branch && git push origin --delete $current_branch
    if [ "$do_origin_push" = true ]; then
        git push origin $merge_branch
    fi

}
alias ,gmm='merged_update'

pr_bump() {
    currentbranch=`parse_git_branch`
    prnum=$(echo $currentbranch | sed -E "s/^pr\/(.*)/\1/g")
    if ! [[ $currentbranch =~ pr/* ]]; then
        echo $currentbranch is not a PR Branch!
        return
    fi
    echo Updating $currentbranch
    git checkout master && git pr clean && git pr $prnum upstream
}

last_sun() {
    date -v -Sun -v -1w +%Y-%m-%d
}

master_merge() {
    git checkout master && git pull origin master && ,tb $1 && git merge master
}

# Work-specific Aliases
alias .jjb='rm -rf ~/jjb && ./build-jobs.sh --test -o ~/jjb && ./build-jobs.sh --cluster --test -o ~/jjb'
alias .jirawk="jira-search-issues \"project = QERBA and assignee = currentUser() and status changed after `last_sun`\""
alias .jirarev="jira-search-issues \"project = QERBA AND status != Closed AND Collaborators = currentUser()\""
alias xls="exa --long --header --git"
alias xlt="xls -T -L 2"
alias dcf="docker-compose --file docker-compose.ci.yml"
alias dcr="dcf run"

# ARIC Login
function ,aric() {
    aric_env=$1
    shift
    pushd ~/Development/rba/rba_roast/
    $(pipenv run ./bin/identity.py $aric_env aric_api_admin)
    if [ "$aric_env" = "production" ]; then
        leader=""
    else
        leader="${aric_env}."
    fi
    open https://${leader}rba.rackspace.com/login.ashx?xauthtoken=${TOKEN}
    popd
}


function dev() {
    pushd ~/Development/qem/docker
    ./dev "$@"
    popd
}

# branch searcher
function ,tb() {
    git branch | sed -n -e 's/^.* //' -e /"$1"/p | xargs -n 1 git checkout
}

# GH assign
function gta () {
    FLAG="-a"
    if [ "$SHELL" = "/bin/zsh" ]; then
        FLAG="-A"
    fi
    IFS=':' read -r $FLAG assignees <<< "$GH_ASSIGNEES"
    gt-assign-pr $GH_OWNER $GH_REPO $1 "${assignees[@]}"
}

# tmux helpers
function join_by { local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}";  }

_tmux_send_keys_all_panes_ () {
    # to_send=`join_by " Space " "$@"`
    to_send="$*"
    for _pane in $(tmux list-panes -F '#P'); do
        tmux send-keys -t ${_pane} $to_send Enter
    done
}
alias tmpp="_tmux_send_keys_all_panes_"

