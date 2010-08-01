//
//  XSAuthenticatedCommand.h
//  LCAdminTools
//
//  Created by James Wilson on 12/05/09.
//  Copyright 2009 LithiumCorp Pty Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include <SecurityFoundation/SFAuthorization.h>

@class XSAuthenticatedCommand;

@protocol XSAuthenticatedCommandDelegate

@optional

- (void) commandDidFinish:(XSAuthenticatedCommand *)command;
- (void) commandDidFail:(XSAuthenticatedCommand *)command;

@end

@interface XSAuthenticatedCommand : NSObject 
{
	NSObject <XSAuthenticatedCommandDelegate> *delegate;
	float progress;
	NSString *status;
	BOOL successful;
	
	FILE *pipe;
	AuthorizationRef authRef;
	NSFileHandle *readHandle;
}

@property (nonatomic,assign) NSObject <XSAuthenticatedCommandDelegate> *delegate; 
+ (XSAuthenticatedCommand *) runScript:(NSString *)scriptName arguments:(NSArray *)arguments;
- (BOOL) runScript:(NSString *)scriptName arguments:(NSArray *)arguments;

@end

