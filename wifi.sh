#!/bin/bash

networksetup -setairportpower en0 off
networksetup -setairportpower en0 on
curl -X POST --data "buttonClicked=4&redirect_url=&err_flag=0" -k https://1.1.1.1/login.html
if [ $? -ne 0 ]; then
        sleep 30
        curl -X POST --data "buttonClicked=4&redirect_url=&err_flag=0" -k https://1.1.1.1/login.html
fi




