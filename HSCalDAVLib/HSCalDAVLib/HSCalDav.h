//
//  HSCalDav.h
//  HSCalDavLib
//
//  Created by Dallas Brown on 11/30/10.
//  Copyright 2010 HashBang Industries. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef void (^HSCalDavCompletionHandler)(id response, NSError *error);

#define NSStringToURL(arrrrgh) [NSURL URLWithString:[arrrrgh stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
#define NSDataToString(arrrrgh) [[[NSString alloc] initWithData:blah encoding:NSUTF8StringEncoding] autorelease]

// http://tools.ietf.org/html/rfc4791
// Status Code Party

enum {
    HSCalDAVCreatedStatusCode = 201,
    HSCalDAVMultiStatusCode = 207, 
    HSCalDAVForbiddenStatusCode = 403,  
    HSCalDAVConflictStatusCode = 409, 
    HSCalDAVUnsupportedMediaTypeStatusCode = 415,
    HSCalDAVFailedDependencyStatusCode = 424, 
    HSCalDAVLockedStatusCode = 423,  
    HSCalDavInsufficientStorageStatusCode = 507,
};


@class HSCalDAV;


@interface HSCalDAV : NSObject <NSStreamDelegate>
{
	NSNumber *bytesRead;
	NSMutableData *mydata;
	NSInputStream *iStream;
	NSOutputStream *oStream;

@private
    NSURLConnection *connection;
    NSMutableData *responseData;
    NSURL *URL;
    NSString *username;
    NSString *password;
    
    NSInteger responseStatusCode;
    NSError *error;
    
    id delegate;
    
    HSCalDavCompletionHandler completionHandler;
}

@property (retain) NSURLConnection *connection;
@property (retain) NSMutableData *responseData;
@property (retain) NSURL *URL;
@property (copy) NSString *username;
@property (copy) NSString *password;
@property (assign) NSInteger responseStatusCode;
@property (retain) NSError *error;
@property (assign) id delegate;
@property (copy) HSCalDavCompletionHandler completionHandler;

- (id)initWithURL:(NSURL *)URL username:(NSString *)username password:(NSString *)password;

- (HSCalDAV *)fetchCalendarsWithCompletionHandler:(HSCalDavCompletionHandler)handler;

- (void)openStream;

@end
