#!/bin/bash
# A UNIX / Linux shell script to send a SMS message through Twillo API.
# Tested in Debian and Raspbian.
# -------------------------------------------------------------------------
# Copyright (c) 2016 David Trigo <david.trigo@gmail.com>
# This script is licensed under GNU GPL version 3.0 or above
# -------------------------------------------------------------------------
# Last updated on : Dec-2015 - Script created.
# -------------------------------------------------------------------------


# Sends text messages using twilio api
# to alert webmaster of banning.
#
# Requires one argument, one of the following:
#  start
#  stop
#  ban
#  unban
#
# Optional second argument: IP for ban/unban



# Include file with the following content:
#   sid=<twilio account sid>
#   token=<twilio auth token>
#   from=<phone number>
#   to=<phone number>
source /root/scripts/secret.conf



# Display usage information
function show_usage {
  echo "Usage: $0 action <ip>"
  echo "Where action is start, stop, ban, unban"
  echo "and ip is optional passed to ban, unban"
  exit
}



# Actually send sms
# Expects the sms content (body) to be passed
# as argument.
function send_sms {
  /usr/bin/curl -X POST "https://api.twilio.com/2010-04-01/Accounts/$sid/SMS/Messages.json" -d "From=$from" -d "To=$to" -d "Body=$1" -u "$sid:$token" >> '/dev/null'    
  exit
}



# Check for script arguments
if [ $# -lt 1 ]
then
  show_usage
fi



# Take action depending on argument
if [ "$1" = 'start' ]
then
  message='Fail2ban+just+started.'
  send_sms $message
elif [ "$1" = 'stop' ]
then
  message='Fail2ban+just+stopped.'
  send_sms $message
elif [ "$1" = 'ban' ]
then
  message=$([ "$2" != '' ] && echo "Fail2ban+just+banned+$2" || echo 'Fail2ban+just+banned+an+ip.' )
  send_sms $message
elif [ "$1" = 'unban' ]
then
  message=$([ "$2" != '' ] && echo "Fail2ban+just+unbanned+$2" || echo "Fail2ban+just+unbanned+an+ip." )
  send_sms $message
else
  show_usage
fi
