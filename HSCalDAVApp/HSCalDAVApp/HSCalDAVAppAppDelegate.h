//
//  HSCalDAVAppAppDelegate.h
//  HSCalDAVApp
//
//  Created by Dallas Brown on 2/9/11.
//  Copyright 2011 Moki Networks. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HSCalDAVAppAppDelegate : NSObject <NSApplicationDelegate> {
@private
	NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
