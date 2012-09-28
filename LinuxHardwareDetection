#!/bin/bash
# GHC Open Source Day project 2011
# Gabrielle Roth & Michelle Rowley
# Ava Gailliot

# Based on:
# System Information Generator v1.1
# Tim Burgess 28.11.07
# Linux hardware detection script for Kids on Computers 

#Check for superuser to ensure proper output of all commands
if [[ $EUID -ne 0 ]]; then
	echo "Permission denied (are you root?)."
	exit 1
fi

#######GLOBALVARS#######
export log=/$HOME/Desktop/linux-check.log

########################
date >> $log
echo -e "\nSystem Report\n------------------" >> $log

#######FUNCTIONS#######
checkRAM(){
	RAM=$(free -m | awk '/^Mem:/{print $2}')
	if [[ $RAM -le 500 ]]; then
		echo -e "This machine does not meet the memory requirements of KOC.\nRAM: ${RAM}M [FAIL]\n"
	else
		echo -e "RAM ${RAM}M [PASS]\n"
	fi				
}

checkDev(){
	echo -e "Present Devices\n-------------------"
	drives=( '/dev/cd*' '/dev/dvd*' '/dev/usb*' )
        for i in "${drives[@]}"
        do
                if  ls $i 1>/dev/null
                        then echo "${i}: Present"
                else
                        echo "${i}: Not present"
                fi
        done
}

getHardInfo(){
	echo -e "\nHardware Information\n-------------------"
	serial=$(dmidecode -t system | awk '/Serial/') #BIOS serial
	processor=$(awk '/processor|vendor_id|model name|mhz/' /proc/cpuinfo)
	opticals=$(wodim --devices | awk '/dev/{print $5 " " $6}')	
	drives=$(fdisk -l | awk '/Disk \//')
	usb=$(lsusb)
	#Use regex instead of IGNORECASE=1 which is for newer versions of awk
	network=$(lspci | cut -f2- -d ' ' | awk '/[Ee]thernet|[Ww]ireless|[Nn]etwork/')
	graphics=$(lspci | cut -f2- -d ' ' | awk '/[Vv]ideo|[Vv]ga|[Gg]raphics/')
	audio=$(lspci | cut -f2- -d ' ' | awk '/[Aa]udio/'
)
	echo -e "${serial}\n\nCPU:\n${processor}\n\n${drives}\nOptical drives: ${opticals}\n\nUSB ports:\n${usb}\n\n${network}\n${graphics}\n${audio}\n"
	
}

getSoftInfo(){
	echo -e "Software Information\n-------------------"
	os=$(uname -a | awk '{print $1 " " $2}')
	kernel=$(uname -r)	
	echo -e "OS: ${os}\nKernel version: ${kernel}\n"
}

#######EXECUTION#######

echo -e "\nGenerating system report..."
checkRAM >> $log 2>&1
echo "Checking devices..."
checkDev >> $log 2>&1
echo "Checking avalible hardware devices..."
getHardInfo >> $log 2>&1
echo "Checking software configuration..."
getSoftInfo >> $log 2>&1
echo -e "All Finished! Check ${log} for details.\n"
cat $log 
