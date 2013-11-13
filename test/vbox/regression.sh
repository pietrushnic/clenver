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
	 echo $line
      done
    else
        ssh -oStrictHostKeyChecking=no user@localhost -p 2222 'wget -O - bit.ly/1hASabs|bash'
        ssh -oStrictHostKeyChecking=no user@localhost -p 2222 'bash -l -c "clenver"'
    fi
}

eval "$@"
