#!/usr/bin/env ruby

# Write config to preferences
manageSnmpConfig = ARGV[0].to_i
snmpCommunity = ARGV[1]
agentExtensionEnabled = ARGV[2].to_i
`defaults write /Library/Preferences/com.xsnmp.xsnmp snmpCommunity -string #{snmpCommunity}`
`defaults write /Library/Preferences/com.xsnmp.xsnmp manageConfig -bool YES` if manageSnmpConfig == 1
`defaults write /Library/Preferences/com.xsnmp.xsnmp manageConfig -bool NO` if manageSnmpConfig == 0
`defaults write /Library/Preferences/com.xsnmp.xsnmp agentExtensionEnabled -bool YES` if agentExtensionEnabled == 1
`defaults write /Library/Preferences/com.xsnmp.xsnmp agentExtensionEnabled -bool NO` if agentExtensionEnabled == 0

# Write out a basic snmpd config
if manageSnmpConfig == 1 then
	conf = File.new("/etc/snmp/snmpd.conf", File::CREAT|File::TRUNC|File::RDWR, 0644)
	conf.write("rocommunity #{snmpCommunity}\n")
	if agentExtensionEnabled == 1 then
		conf.write("\nmaster agentx\n")
	end
	conf.write("\n")
	conf.close
	
	# Stop snmpd
	`launchctl unload -w /System/Library/LaunchDaemons/org.net-snmp.snmpd.plist`

	# Start snmpd
	`launchctl load -w /System/Library/LaunchDaemons/org.net-snmp.snmpd.plist`
end

