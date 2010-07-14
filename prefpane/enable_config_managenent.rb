#!/usr/bin/env ruby

# Move current config out of the way
File.rename("/etc/snmp/snmpd.conf", "/etc/snmp/snmpd.conf.pre-xsnmp") if File.exist?("/etc/snmp/snmpd.conf")

# Write out a basic config
`ruby /Library/PreferencePanes/Xsnmp.prefPane/Contents/Resources/update_config.rb`

# Set Status 
`defaults write /Library/Preferences/com.xsnmp.xsnmp manageConfig -bool YES`
