#!/usr/bin/env bash
#TODO: write documentation and disclaimer about vm usage
#TODO: make sure that $1 exist - use vboxmanage list
SCANCODES=$HOME/src/scancodes/scancodes
# run vm
echo "run vm"
vboxmanage startvm $1 # -type headless
echo "sleep 3"
sleep 3
# push enter
echo "push enter"
vboxmanage controlvm $1 keyboardputscancode 1C 9C &
sleep 45
# cat host pub key to guest .ssh/authorized_keys
pub_key=$(cat $HOME/.ssh/id_rsa.pub)
pkey_scancodes=$(echo -en $pub_key|$SCANCODES)
# echo "
echo_sc="12 92 2e ae 23 a3 18 98 39 b9 2a 28 a8 aa 1c 9c"
# " >
gt_sc="2a 28 a8 aa 39 b9 2a 34 b4 aa 1c 9c"
# mkdir -p $HOME/.ssh
mkdir_ssh_pt="32 b2 25 a5 20 a0 17 97 13 93 39 b9 0c 8c 19 99 39 b9 2a 05 85 aa 2a 23 a3 aa 2a 18 98 aa 2a 32 b2 aa 2a 12 92 aa 35 b5 34 b4 1f 9f 1f 9f 23 a3 1c 9c"
# $HOME/.ssh/authorized_keys
auth_keys_sc="2a 05 85 aa 2a 23 a3 aa 2a 18 98 aa 2a 32 b2 aa 2a 12 92 aa 35 b5 34 b4 1f 9f 1f 9f 23 a3 35 b5 1e 9e 16 96 14 94 23 a3 18 98 13 93 17 97 2c ac 12 92 20 a0 2a 0c 8c aa 25 a5 12 92 15 95 1f 9f 1c 9c"
sc_send () {
    IFS=' ' read -a array <<< "$2"
    for (( i=0; i<${#array[@]}; i=i+2));do
        echo "$1: send ${array[$i]} ${array[$i+1]}"
        vboxmanage controlvm $1 keyboardputscancode ${array[$i]} ${array[$i+1]} &
        sleep 1
    done
}

sc_send $1 "$mkdir_ssh_pt"
sc_send $1 "$echo_sc"
sc_send $1 "$pkey_scancodes"
sc_send $1 "$gt_sc"
sc_send $1 "$auth_keys_sc"
