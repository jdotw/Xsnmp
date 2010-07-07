//
//  XsnmpPrefPanePref.m
//  XsnmpPrefPane
//
//  Created by James Wilson on 29/06/10.
//  Copyright (c) 2010 LithiumCorp. All rights reserved.
//

#import "XsnmpPrefPanePref.h"

static NSBundle *ourBundle;

@implementation XsnmpPrefPanePref

+ (NSBundle *) bundle
{
	return ourBundle;
}

- (id) initWithBundle:(NSBundle *)bundle
{
	self = [super initWithBundle:bundle];
	
	ourBundle = bundle;
	
	return self;
}

- (void) mainViewDidLoad
{
}

@end
