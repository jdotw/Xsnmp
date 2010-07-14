#!/usr/bin/env ruby

# Move current config out of the way
File.rename("/etc/snmp/snmpd.conf", "/etc/snmp/snmpd.conf.xsnmp") if File.exist?("/etc/snmp/snmpd.conf")

# Restore pre-xsnmp config
File.rename("/etc/snmp/snmpd.conf.pre-xsnmp", "/etc/snmp/snmpd.conf") if File.exist?("/etc/snmp/snmpd.conf.pre-xsnmp")

# Stop snmpd
`launchctl unload -w /System/Library/LaunchDaemons/org.net-snmp.snmpd.plist`

# Start snmpd
`launchctl load -w /System/Library/LaunchDaemons/org.net-snmp.snmpd.plist`

# Set Status 
`defaults write /Library/Preferences/com.xsnmp.xsnmp manageConfig -bool NO`
