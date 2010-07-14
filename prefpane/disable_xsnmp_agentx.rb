#!/usr/bin/env ruby

# Stop Xsnmp
`launchctl unload -w /Library/LaunchDaemons/com.xsnmp.xsnmp-agentx.plist`

# Set Status 
`defaults write /Library/Preferences/com.xsnmp.xsnmp agentExtensionEnabled -bool NO`
