//
//  HSCalDav.h
//  HSCalDavLib
//
//  Created by Dallas Brown on 11/30/10.
//  Copyright 2010 HashBang Industries. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface HSCalDav : NSObject
{

}

- (int) add:(int)value1 value2:(int)value2;
- (int) subtract:(int)value1 value2:(int)value2;
- (NSString*)usersFirstName:(NSString*)fname lastName:(NSString*)lname;

@end
