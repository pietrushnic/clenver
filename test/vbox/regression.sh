#!/bin/bash
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
sleep 40
# cat host pub key to guest .ssh/authorized_keys
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

sc_send $1 'mkdir -p $HOME/.ssh'
st_pt=' > $HOME/.ssh/authorized_keys'
nd_pt="echo $pub_key"
echo "$nd_pt$st_pt"
sc_send $1 "$nd_pt$st_pt"
ssh -oStrictHostKeyChecking=no user@localhost -p 2222 'wget -O - bit.ly/1hASabs|bash'
ssh -oStrictHostKeyChecking=no user@localhost -p 2222 'clenver'

