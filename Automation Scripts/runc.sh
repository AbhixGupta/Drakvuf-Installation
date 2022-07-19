#!/usr/bin/env bash

DISPLAY=:0 konsole --new-tab -e bash -c "sudo xl list;sleep 5" &
konsole --noclose --new-tab -e bash -c "gvncviewer localhost" &
konsole --noclose --new-tab -e bash -c "sudo bash /home/pc2/drakvuf/star_up.sh"
#konsole --noclose --new-tab -e bash -c "gvncviewer localhost"

#DISPLAY=:0 xterm -hold -e bash -c "" &
#xterm -hold -e bash -c "sudo bash /home/pc03/drakvuf/star_up.sh"
#sleep 5

#terminator -e 'sudo bash /home/pc03/drakvuf/star_up.sh' -p hold. 
#tab="--tab"
#cmd="bash -c 'sudo bash /home/pc03/Documents/final_script/star_up.sh';bash"
#foo=""

#for i in {1..1..1}; do
	
#      foo+=($tab -e "$cmd")   
          
#done
#echo "now running tracing script"
#gnome-terminal "${foo[@]}"
#echo "${foo[@]}"

#exit 0
