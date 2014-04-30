#!/bin/bash

function acceptConditions {
		curl -X POST --data "buttonClicked=4&redirect_url=&err_flag=0" -k https://1.1.1.1/login.html	
}

networksetup -setairportpower en0 off
networksetup -setairportpower en0 on
acceptConditions

if [ $? -ne 0 ]; then
        sleep 30
        acceptConditions
fi
