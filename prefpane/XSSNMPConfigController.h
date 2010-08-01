//
//  XSSNMPConfigController.h
//  XsnmpPrefPane
//
//  Created by James Wilson on 7/07/10.
//  Copyright 2010 LithiumCorp Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XSSNMPConfigController : NSObject <NSAlertDelegate, NSOpenSavePanelDelegate>
{
	NSNumber *manageConfig;
	NSNumber *agentExtensionEnabled;
	NSString *snmpCommunity;
}

@property (nonatomic, copy) NSNumber *manageConfig;
@property (nonatomic, copy) NSNumber *agentExtensionEnabled;
@property (nonatomic, copy) NSString *snmpCommunity;
- (IBAction) buildCustomInstallerClicked:(id)sender;

@end
