#/usr/bin/env bash
#TODO: write documentation and disclaimer about vm usage
#TODO: make sure that $1 exist - use vboxmanage list
# run vm
echo "run vm"
vboxmanage startvm $1 # -type headless
echo "sleep 3"
sleep 3
# push enter
echo "push enter"
vboxmanage controlvm $1 keyboardputscancode 1C 9C &
sshpass -p live user@localhost -p 2222 '
