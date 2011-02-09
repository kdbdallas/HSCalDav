//
//  HSCalDAVAppAppDelegate.m
//  HSCalDAVApp
//
//  Created by Dallas Brown on 2/9/11.
//  Copyright 2011 Moki Networks. All rights reserved.
//

#import "HSCalDAVAppAppDelegate.h"
#import "HSCalDAV.h"


@implementation HSCalDAVAppAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	HSCalDAV *calDav = [[HSCalDAV alloc] initWithURL:[NSURL URLWithString:@"https://www.google.com/calendar/dav/kdbdallas@gmail.com/user/"] username:@"" password:@""];

	[calDav fetchCalendarsWithCompletionHandler:^(id response, NSError *error){
		NSData *fetchedData = [response responseData];
		
		NSString *programJSON = [[NSString alloc] initWithBytes:[fetchedData bytes] length:[fetchedData length] encoding:NSUTF8StringEncoding];
		
		NSLog(@"programJSON: %@", programJSON);
		NSLog(@"error: %@", error);
	}];
}

@end
