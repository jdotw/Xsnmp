//
//  XSSNMPConfigController.m
//  XsnmpPrefPane
//
//  Created by James Wilson on 7/07/10.
//  Copyright 2010 LithiumCorp Pty Ltd. All rights reserved.
//

#import "XSSNMPConfigController.h"

#import "XSAuthenticatedCommand.h"

@implementation XSSNMPConfigController

@synthesize manageConfig, agentExtensionEnabled;

- (void) setManageConfig:(BOOL)value
{
	BOOL previouslyManagingConfig = manageConfig;
	manageConfig = value;
	
	if (manageConfig && !previouslyManagingConfig)
	{
		/* Switch on config management
		 *
		 * - Move the current config out of the way (backup)
		 * - Write out a new config based on settings/defaults 
		 * - (Re-)start snmpd launch daemon
		 */
		NSLog (@"Running command enable_config_managenent.rb");
		NSMutableDictionary *preferences = [NSMutableDictionary dictionaryWithContentsOfFile:@"/Library/Preferences/com.xsnmp.xsnmp.plist"]
		NSLog (@"Preferences is %@", [ objectForKey:@"foo"]);
		[XSAuthenticatedCommand runScript:@"enable_config_managenent.rb" arguments:nil];
		NSLog (@"Preferences is %@", [[NSDictionary dictionaryWithContentsOfFile:@"/Library/Preferences/com.xsnmp.xsnmp.plist"] objectForKey:@"foo"]);
		[preferences writeToFile:@"/Library/Preferences/com.xsnmp.xsnmp.plist" atomically:YES];
	}
	else if (!manageConfig && previouslyManagingConfig)
	{
		/* Switch off config management
		 *
		 * - Move current config out of the way (xsnmp-backup)
		 * - Move old config back into place
		 * - (Don't stop snmpd, let the user do that if they want)
		 */
		
	}

}

- (void) setAgentExtensionEnabled:(BOOL)value;
{
	BOOL previouslyEnabled = agentExtensionEnabled;
	agentExtensionEnabled = value;
	
	if (agentExtensionEnabled && !previouslyEnabled)
	{
		/* Switch on agent extension 
		 *
		 * - Check/Add the agentx master statement to config (append)
		 * - (Re-)start snmpd laumch daemon
		 * - (Re-)start xsnmp launch daemon
		 */
		
	}
	else if (!agentExtensionEnabled && previouslyEnabled)
	{
		/* Switch off the agent extension 
		 *
		 * - (Don't remove the agentx statement -- it might not be there just for us )
		 * - Stop the xsnmp launch daemon 
		 */
		
	}
}

@end
