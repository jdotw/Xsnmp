#!/bin/sh

sudo launchctl unload -w /Library/LaunchDaemons/com.xsnmp.xsnmp-agentx.plist
sudo launchctl unload -w /System/Library/LaunchDaemons/org.net-snmp.snmpd.plist
sudo rm -rf /Library/Xsnmp
sudo rm -rf /Library/PreferencePanes/Xsnmp.prefPane
sudo rm /Library/Preferences/com.xsnmp.xsnmp.plist
sudo cp /etc/snmp/snmpd.conf.default /etc/snmp/snmpd.conf

