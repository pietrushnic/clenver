#!/bin/bash
#TODO: write documentation and disclaimer about vm usage
#TODO: make sure that $1 exist - use vboxmanage list
SCANCODES=$HOME/src/scancodes/scancodes
pub_key=$(cat $HOME/.ssh/id_rsa.pub)
pkey_scancodes=$(echo -en $pub_key|$SCANCODES)

sc_send () {
    for (( i=0; i<${#2}; i++ )); do
        echo ">${2:$i:1}<"
        c=$(echo -en "${2:$i:1}"|$SCANCODES)
        echo "$1: send ${c}"
        vboxmanage controlvm $1 keyboardputscancode $c
        if [[ $i -eq $(expr ${#2} - 1) ]]; then
            c=$(echo -en "\n"|$SCANCODES)
            echo "$1: send ${c}"
            vboxmanage controlvm $1 keyboardputscancode $c
        fi
    done
}

startvm() {
    echo "startvm $1"
    vboxmanage startvm $1 # -type headless
}

ssh_cmd () {
    echo "ssh_cmd: $1"
    ssh -oStrictHostKeyChecking=no user@localhost -p 2222 $1
}

scp_cmd () {
    echo "scp_cmd: $1 $2"
    scp -P 2222 -oStrictHostKeyChecking=no $1 user@localhost:$2
}

bash_cmd () {
    st="bash -l -c '"
    nd="$1"
    rd="'"
    echo "bash_cmd: $st$nd$rd"
    ssh_cmd "$st$nd$rd"
}

no_pass_ssh () {
    startvm $1
    sleep 3
    vboxmanage controlvm $1 keyboardputscancode 1C 9C
    sleep 45
    # cat host pub key to guest .ssh/authorized_keys
    sc_send $1 'mkdir -p $HOME/.ssh'
    st_pt=' > $HOME/.ssh/authorized_keys'
    nd_pt="echo $pub_key"
    echo "$nd_pt$st_pt"
    sc_send $1 "$nd_pt$st_pt"
}

clenver_install() {
    no_pass_ssh $1
    if [[ $# -ge 2 ]]; then
        cat $2 | while read line; do
            sc_send $1 "$line"
        done
    else
        ssh_cmd 'wget -O - bit.ly/1hASabs|bash'
        ssh_cmd 'bash -l -c "clenver"'
    fi
}

init_general () {
   clenver_install $1
   #ssh_cmd 'bash -l -c "clenver init http://bit.ly/1cpqEqp"'
   ssh_cmd 'git clone https://github.com/pietrushnic/clenver_projects.git src/clenver_projects'
   ssh_cmd 'bash -l -c "clenver init src/clenver_projects/general.yml"'
}

init_custom () {
    no_pass_ssh $1
    scp_cmd $2 /home/user
    home_v='$HOME'
    nd_pt="/${2##*/}"
    # use local gem
    if [[ $# -ge 3 ]]; then
        scp_cmd $3 /home/user
        nd_pt="$nd_pt $3"
        echo "nd_pt: $nd_pt"
    fi
    bash_cmd "$home_v$nd_pt"
    ssh_cmd "git clone https://github.com/pietrushnic/clenver_projects.git src/clenver_projects"
    bash_cmd "clenver init $home_v/src/clenver_projects/general.yml"
}

eval "$@"
