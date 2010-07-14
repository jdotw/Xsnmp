#!/usr/bin/env ruby

# Ensure 'master agentx' is in the current config
if File.exist?("/etc/snmp/snmpd.conf") then
  f = File.new("/etc/snmp/snmpd.conf")
  conf = f.read
  f.close
  unless conf =~ /^master[ ]+agentx/ then
    conf << "\nmaster agentx\n"
    f = File.new("/etc/snmp/snmpd.conf", File::CREAT|File::TRUNC|File::RDWR, 0644)
    f.write(conf)
	f.close
  end
else
  puts "ERROR: Config not found"
end

# Stop snmpd
`launchctl unload -w /System/Library/LaunchDaemons/org.net-snmp.snmpd.plist`

# Start snmpd
`launchctl load -w /System/Library/LaunchDaemons/org.net-snmp.snmpd.plist`

# Stop Xsnmp
`launchctl unload -w /Library/LaunchDaemons/com.xsnmp.xsnmp-agentx.plist`

# Start Xsnmp
`launchctl load -w /Library/LaunchDaemons/com.xsnmp.xsnmp-agentx.plist`

# Set Status 
`defaults write /Library/Preferences/com.xsnmp.xsnmp agentExtensionEnabled -bool YES`
