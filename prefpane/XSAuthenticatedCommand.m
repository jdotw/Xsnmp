//
//  XSAuthenticatedCommand.m
//  LCAdminTools
//
//  Created by James Wilson on 12/05/09.
//  Copyright 2009 LithiumCorp Pty Ltd. All rights reserved.
//

#import "XSAuthenticatedCommand.h"
#import "XsnmpPrefPanePref.h"

@interface XSAuthenticatedCommand (Private)
- (void) informDelegteHelperFinished;
- (void) informDelegteHelperFailed;
- (BOOL) processDataFromHelper:(NSString *)data;
@end

@implementation XSAuthenticatedCommand

#pragma mark "Generic Methods

+ (XSAuthenticatedCommand *) runScript:(NSString *)scriptName arguments:(NSArray *)arguments
{
	XSAuthenticatedCommand *authCommand = [[XSAuthenticatedCommand alloc] init];
	[authCommand runScript:scriptName arguments:arguments];
	return [authCommand autorelease];
}

- (void) runScript:(NSString *)scriptName arguments:(NSArray *)arguments
{
	OSStatus err = 0;
	if (!authRef)
	{ err = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authRef); }
	if (err == 0)
	{
		/* Setup arguments array */
		char *args[[arguments count]+2];
		args[0] = (char *) [[[XsnmpPrefPanePref bundle] pathForResource:scriptName ofType:nil] cStringUsingEncoding:NSUTF8StringEncoding];
		NSLog (@"Scripts path is %s", args[0]);
		for (NSString *argument in arguments)
		{
			args[[arguments indexOfObject:argument]+1] = (char *) [argument cStringUsingEncoding:NSUTF8StringEncoding];
		}
		args[[arguments count]+1] = NULL;
		
		char *helperPath = (char *) [[[XsnmpPrefPanePref bundle] pathForAuxiliaryExecutable:@"XsnmpHelperTool"] cStringUsingEncoding:NSUTF8StringEncoding];
		NSLog (@"Helper path is %s (%@)", helperPath, [[XsnmpPrefPanePref bundle] bundlePath]);
				
		err = AuthorizationExecuteWithPrivileges(authRef,helperPath,kAuthorizationFlagDefaults,args,&pipe);	
		if (err == errAuthorizationSuccess)
		{
			/* Authorized and executed */
			readHandle = [[NSFileHandle alloc] initWithFileDescriptor:fileno(pipe)];
			[[NSNotificationCenter defaultCenter] addObserver:self
													 selector:@selector(dataToBeReadFromHelper:)
														 name:NSFileHandleReadCompletionNotification
													   object:readHandle];	
			[readHandle readInBackgroundAndNotify];
		}
		else
		{ 
			/* Failed to authorize or execute */
			[self informDelegteHelperFailed];
		}
	}
	
}

- (void) dealloc
{
	if (authRef)
	{ AuthorizationFree(authRef,kAuthorizationFlagDefaults); }
	[readHandle release];
	[super dealloc];
}

- (BOOL) processDataFromHelper:(NSString *)data
{
	/* Return YES to keep reading */
	/* Return NO to suppress further read */
	return YES;
}

- (void) dataToBeReadFromHelper:(NSNotification *)notification
{
	NSDictionary *resultDictionary = [notification userInfo];
	NSData *readData = [resultDictionary objectForKey:NSFileHandleNotificationDataItem];
	
	NSString *string = [[[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding] autorelease];
	if (string && [string length] > 0)
	{
		/* Interpret */
		BOOL keepReading = [self processDataFromHelper:string];
		if (keepReading)
		{ [readHandle readInBackgroundAndNotify]; }
	}
	else
	{
		/* Failed to read! */
		[self informDelegteHelperFailed];
	}
	
	NSLog (@"Read %@", string);
}

#pragma mark "Delegate Methods"

@synthesize delegate;

- (void) informDelegteHelperFinished
{
	if ([delegate respondsToSelector:@selector(commandDidFinish:)])
	{ [delegate performSelectorOnMainThread:@selector(commandDidFinish:) withObject:self waitUntilDone:YES]; }
}

- (void) informDelegteHelperFailed
{
	if ([delegate respondsToSelector:@selector(commandDidFail:)])
	{ [delegate performSelectorOnMainThread:@selector(commandDidFail:) withObject:self waitUntilDone:YES]; }
}

@end
