#!/usr/bin/env bash
  #sudo xl create /etc/xen/win7.cfg
  #ID=$(sudo xl list | grep -oP '(?<=windows7-sp1)[^33]*')
  #ID= echo ${ID%%*( )}
  #echo "creating VM..."
  #echo "creation done..."
  #DISPLAY=:0 konsole --noclose -e bash -c "gvncviewer localhost"
  #sudo gvncviewer localhost
  #sleep 50
  #sudo /bin/bash/env bash /home/pc03/Documents/Bash Scripts/runn.sh
  #gnome-terminal -- /bin/sh -c 'sudo /bin/bash/env bash /home/pc03/Documents/Bash_Scripts/sample.sh'

ID=$(sudo xl list | grep -oP '(?<=windows7-sp1)[^33]*' |  cut -c 34)
ID= echo ${ID%%*( )}
var=$(sudo vmi-process-list windows7-sp1 | grep -h "explorer.exe" | cut -c 3-6)
echo "explorer id = $var"
var1="vif$ID.0-emu"
echo $var1
  # echo "Enter the Number: "  
  #read i  
  #echo "The Current File Name is $i"
  upd=$(cat /home/pc2/drakvuf/lfile.txt | cut -c 1-4)
for (( i=$upd; i<=1120; i++ ))
 do
 state1=$(sudo xl list |   grep -h "windows7-sp1" | cut -c 64)
 state2=$(sudo xl list |   grep -h "windows7-sp1" | cut -c 65)
   if [[ "$state1" == "r" ]] || [[ "$state2" == "b" ]]
   then 
  	echo "Loop ID is = $i"
  	$(sudo /home/pc2/drakvuf/src/drakvuf -r /root/windows7-sp1.json -d $ID -x socketmon -t 120 -i $var -e "E:\\zeroaccess\\zeroaccess$i.exe" > /home/pc2/Desktop/malware/logs_text/zeroaccess$i.txt & sudo tcpdump -G 120 -W 1 -w "/home/pc2/Desktop/malware/logs_network/zeroaccess$i.pcap" -i $var1)
  	er=$(sudo head -1 /home/pc2/Desktop/malware/logs_text/zeroaccess$i.txt | sudo grep -o STATUS:Error)

  	if [[ "$er" == "STATUS:Error" ]]
  	 then
  	   echo "Error Present : $er"
  	   mv /home/pc2/Desktop/malware/logs_network/zeroaccess$i.pcap -i $var1 /home/pc2/Desktop/malware/logs_network/ne$i.pcap
  	   mv /home/pc2/Desktop/malware/logs_text/zeroaccess$i.txt /home/pc2/Desktop/malware/logs_text/ne$i.txt
	
  	 # elif [[ "$err" == "Domain is not running, failed to get domID from name!" ]]
  	 
  	 #then
  	  # echo "Error Present : $er"
  	   #rm /home/pc03/Desktop/logs/Malware/network/winwebsec$i.pcap
  	   #rm /home/pc03/Desktop/logs/Malware/logs/winwebsec$i.txt
     
  	   #sudo xl destroy $ID
  	   #echo "destroying..."
     
  	   #sudo xl create /etc/xen/win7.cfg
  	   #echo "New VM is Created..."
  	fi
  	sleep 5
  	
  	
   else
   	echo "$i" | cat > /home/pc2/drakvuf/lfile.txt
   	echo "echo VM Crashed rebooting.....;sleep 10"
 	sudo reboot
    fi
 done
