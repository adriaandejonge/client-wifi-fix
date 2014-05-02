#!/bin/bash

function acceptConditions {
		curl -X POST --data "buttonClicked=4&redirect_url=&err_flag=0" -k https://1.1.1.1/login.html	
}

function doIteration {
	networksetup -setairportpower en0 off
	networksetup -setairportpower en0 on
	acceptConditions

	if [ $? -ne 0 ]; then
	        sleep 30
	        acceptConditions
	fi
}

for i in {1..50}
do
   echo "Do it: $i"
   doIteration
   echo "Wait: $i"
   sleep 1500
done