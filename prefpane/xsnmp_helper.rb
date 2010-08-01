#!/usr/bin/env ruby

def enable_config_management

	# Move current config out of the way
	File.rename("/etc/snmp/snmpd.conf", "/etc/snmp/snmpd.conf.pre-xsnmp") if File.exist?("/etc/snmp/snmpd.conf")

	# Set Status 
	`defaults write /Library/Preferences/com.xsnmp.xsnmp manageConfig -bool YES`

end

def disable_config_management
  
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
  
end

def enable_xsnmp_agentx
  
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
  
end

def disable_xsnmp_agentx
  
  # Stop Xsnmp
  `launchctl unload -w /Library/LaunchDaemons/com.xsnmp.xsnmp-agentx.plist`

  # Set Status 
  `defaults write /Library/Preferences/com.xsnmp.xsnmp agentExtensionEnabled -bool NO`
  
end

def update_config
  
  # Write config to preferences
  `defaults write /Library/Preferences/com.xsnmp.xsnmp snmpCommunity -string #{@snmpCommunity}`
  `defaults write /Library/Preferences/com.xsnmp.xsnmp manageConfig -bool YES` if @manageSnmpConfig == 1
  `defaults write /Library/Preferences/com.xsnmp.xsnmp manageConfig -bool NO` if @manageSnmpConfig == 0
  `defaults write /Library/Preferences/com.xsnmp.xsnmp agentExtensionEnabled -bool YES` if @agentExtensionEnabled == 1
  `defaults write /Library/Preferences/com.xsnmp.xsnmp agentExtensionEnabled -bool NO` if @agentExtensionEnabled == 0

  # Write out a basic snmpd config
  if @manageSnmpConfig == 1 then
  	conf = File.new("/etc/snmp/snmpd.conf", File::CREAT|File::TRUNC|File::RDWR, 0644)
  	conf.write("rocommunity #{@snmpCommunity}\n")
  	if @agentExtensionEnabled == 1 then
  		conf.write("\nmaster agentx\n")
  	end
  	conf.write("\n")
  	conf.close

  	# Stop snmpd
  	`launchctl unload -w /System/Library/LaunchDaemons/org.net-snmp.snmpd.plist`

  	# Start snmpd
  	`launchctl load -w /System/Library/LaunchDaemons/org.net-snmp.snmpd.plist`
  end

end

def build_custom_installer
  
  # Read template config
  config_template = File.new("/Library/Xsnmp/XsnmpAgentExtension.app/Resources/scripts/postinstall.template", "r").read
  
  # Add custom actions to postinstall script
  config_template << "\n\n# Xsnmp Custom Installer Actions\n"
  
  # Check for config management 
  if @manageSnmpConfig == 1 then
    config_template << "ruby /Library/PreferencePanes/Xsnmp.prefPane/Contents/Resources/xsnmp_helper.rb enable_config_management #{ARGV[1..ARGV.length] * ' '}\n"
  else
    config_template << "ruby /Library/PreferencePanes/Xsnmp.prefPane/Contents/Resources/xsnmp_helper.rb disable_config_management #{ARGV[1..ARGV.length] * ' '}\n"
  end
  
  # Check for agent status 
  if @agentExtensionEnabled == 1 then
    config_template << "ruby /Library/PreferencePanes/Xsnmp.prefPane/Contents/Resources/xsnmp_helper.rb enable_xsnmp_agentx #{ARGV[1..ARGV.length] * ' '}\n"
  else
    config_template << "ruby /Library/PreferencePanes/Xsnmp.prefPane/Contents/Resources/xsnmp_helper.rb disable_xsnmp_agentx #{ARGV[1..ARGV.length] * ' '}\n"
  end
  
  # Write actual postinstall file
  f = File.new("/Library/Xsnmp/XsnmpAgentExtension.app/Resources/scripts/postinstall", File::CREAT|File::TRUNC|File::RDWR, 0644)
  f.write(config_template)
  f.close	

  # Build package
  `/Developer/usr/bin/packagemaker --doc "/Library/Xsnmp/XsnmpAgentExtension.app/Resources/XsnmpInstaller.pmdoc" --out "#{ARGV[4]}" --title "Xsnmp Installer"`
  
end


#
# Main Executable
#

warn "xsnmp_helper.rb has args #{ARGV * ', '}"

# Get config variables
@manageSnmpConfig = ARGV[1].to_i
@snmpCommunity = ARGV[2]
@agentExtensionEnabled = ARGV[3].to_i

# Call method
self.method(ARGV[0]).call unless ARGV[0].nil? or ARGV[0] == "update_config"

# Always update the config
update_config
