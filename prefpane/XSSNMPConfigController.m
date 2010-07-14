//
//  XSSNMPConfigController.m
//  XsnmpPrefPane
//
//  Created by James Wilson on 7/07/10.
//  Copyright 2010 LithiumCorp Pty Ltd. All rights reserved.
//

#import "XSSNMPConfigController.h"

#import "XSAuthenticatedCommand.h"

#define kPreferencesFile @"/Library/Preferences/com.xsnmp.xsnmp.plist"

@implementation XSSNMPConfigController

- (id) init
{
	self = [super init];
	if (!self) return nil;

	NSDictionary *config = [NSMutableDictionary dictionaryWithContentsOfFile:kPreferencesFile];
	manageConfig = [[config objectForKey:@"manageConfig"] intValue];
	agentExtensionEnabled = [[config objectForKey:@"agentExtensionEnabled"] intValue];
	snmpCommunity = [config objectForKey:@"snmpCommunity"];
	
	return self;
}

@synthesize manageConfig, agentExtensionEnabled, snmpCommunity;

- (NSArray *) argumentsForScript
{
	return [NSArray arrayWithObjects:[NSString stringWithFormat:@"%i", manageConfig],
			snmpCommunity, [NSString stringWithFormat:@"%i", agentExtensionEnabled], nil];
}

- (void) setManageConfig:(BOOL)value
{
	BOOL previouslyManagingConfig = manageConfig;
	BOOL scriptRan = NO;
	manageConfig = value;
	
	if (manageConfig && !previouslyManagingConfig)
	{
		/* Switch on config management
		 *
		 * - Move the current config out of the way (backup)
		 * - Write out a new config based on settings/defaults 
		 * - (Re-)start snmpd launch daemon
		 */
		scriptRan = [XSAuthenticatedCommand runScript:@"enable_config_management" arguments:[self argumentsForScript]];
	}
	else if (!manageConfig && previouslyManagingConfig)
	{
		/* Switch off config management
		 *
		 * - Move current config out of the way (xsnmp-backup)
		 * - Move old config back into place
		 * - (Don't stop snmpd, let the user do that if they want)
		 */
		scriptRan = [XSAuthenticatedCommand runScript:@"disable_config_management" arguments:[self argumentsForScript]];		
	}

	if (!scriptRan) manageConfig = previouslyManagingConfig;
}

- (void) setAgentExtensionEnabled:(BOOL)value;
{
	BOOL previouslyEnabled = agentExtensionEnabled;
	BOOL scriptRan = NO;
	agentExtensionEnabled = value;
	
	if (agentExtensionEnabled && !previouslyEnabled)
	{
		/* Switch on agent extension 
		 *
		 * - Check/Add the agentx master statement to config (append)
		 * - (Re-)start snmpd laumch daemon
		 * - (Re-)start xsnmp launch daemon
		 */
		scriptRan = [XSAuthenticatedCommand runScript:@"enable_xsnmp_agentx" arguments:[self argumentsForScript]];		
	}
	else if (!agentExtensionEnabled && previouslyEnabled)
	{
		/* Switch off the agent extension 
		 *
		 * - (Don't remove the agentx statement -- it might not be there just for us )
		 * - Stop the xsnmp launch daemon 
		 */
		scriptRan = [XSAuthenticatedCommand runScript:@"disable_xsnmp_agentx" arguments:[self argumentsForScript]];				
	}

	if (!scriptRan) agentExtensionEnabled = previouslyEnabled;
}

- (void) setSnmpCommunity:(NSString *)value
{
	[snmpCommunity release];
	snmpCommunity = [value retain];
	
	[XSAuthenticatedCommand runScript:@"update_config" arguments:[self argumentsForScript]];
}

@end
