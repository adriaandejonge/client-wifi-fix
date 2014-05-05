#!/bin/bash

# Uncomment below to enable debug
#set -x
set -e
#set -u

declare -r LOG_DEFAULT_COLOR="\033[0m"
declare -r LOG_ERROR_COLOR="\033[1;31m"

function log {
  echo "[$(date +"%Y-%m-%d %H:%M:%S %Z")] ${1}";
}
function info {
  echo -e "$(log $1)";
}
function error {
  echo -e "${LOG_ERROR_COLOR}$(info $1)${LOG_DEFAULT_COLOR}";
}

# Generic waitFor function
# Accepts two parameters:
# - ${1} is condition to wait for
# - ${2} is wait time, defaults to 30 retries (=~ seconds)
function waitFor {
  retries=${2:-30}
  while [ $retries -gt 0 ]; do
    ${1} && info "${1} success" && return 0
    retries=$((retries - 1))
    info "Waiting for ${1}"
    sleep 1
  done
  error "${1} failed"
  return 1
}

# Check if wifi has connection
function hasWifi {
  #ping -q -t 1 -c 1 $(netstat -nr | grep default | awk '{print $2}') >/dev/null 2>&1
  nc -G 2 -w 2 -z 1.1.1.1 80 >/dev/null 2>&1
}

# Accepts Stater Wifi usage terms
function acceptTerms {
  curl -X POST --data "buttonClicked=4&redirect_url=&err_flag=0" -k https://1.1.1.1/login.html >/dev/null 2>&1
}

# Restart wifi and wait till it's available
function bounceWifi {
  info "Bouncing wifi"
  networksetup -setairportpower en0 off
  networksetup -setairportpower en0 on

  waitFor hasWifi
  info "Bouncing connected"
}

# Check if wifi is connected, bounce otherwise
hasWifi || bounceWifi
# Accept terms
waitFor acceptTerms
