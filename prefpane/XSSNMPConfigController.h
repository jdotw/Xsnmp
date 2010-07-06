//
//  XSSNMPConfigController.h
//  XsnmpPrefPane
//
//  Created by James Wilson on 7/07/10.
//  Copyright 2010 LithiumCorp Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XSSNMPConfigController : NSObject 
{
	BOOL manageConfig;
	BOOL agentExtensionEnabled;
}

@property (nonatomic, retain) BOOL manageConfig;
@property (nonatomic, retain) BOOL agentExtensionEnabled;


@end
