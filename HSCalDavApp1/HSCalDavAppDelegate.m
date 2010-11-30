//
//  HSCalDavAppDelegate.m
//  HSCalDav
//
//  Created by Dallas Brown on 11/30/10.
//  Copyright 2010 HashBang Industries. All rights reserved.
//

#import "HSCalDavAppDelegate.h"
#import "HSCalDav.h"

@implementation HSCalDavAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	HSCalDav *caldav = [[HSCalDav alloc] init];
	
	NSLog(@"%d", [caldav add:3 value2:5]);

	[caldav release], caldav = nil;
}

@end
