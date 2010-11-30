//
//  HSCalDavAppAppDelegate.m
//  HSCalDavApp
//
//  Created by Dallas Brown on 11/30/10.
//  Copyright 2010 HashBang Industries. All rights reserved.
//

#import "HSCalDavAppAppDelegate.h"
#import "HSCalDav.h"

@implementation HSCalDavAppAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	HSCalDav *caldav = [[HSCalDav alloc] init];

	NSLog(@"%d", [caldav add:2 value2:9]);

	[caldav release], caldav = nil;
}

@end
