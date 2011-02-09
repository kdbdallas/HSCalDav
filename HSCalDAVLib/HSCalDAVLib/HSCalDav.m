//
//  HSCalDav.m
//  HSCalDavLib
//
//  Created by Dallas Brown on 11/30/10.
//  Copyright 2010 HashBang Industries. All rights reserved.
//

#import "HSCalDAV.h"


#define BUFSIZE 2048

static NSString * const HSCalDAVErrorDomain = @"HSCalDAVErrorDomain";


@interface HSCalDAV()
- (void)sendRequest:(NSMutableURLRequest *)request;
@end


@implementation HSCalDAV

@synthesize connection;
@synthesize responseData;  
@synthesize URL;
@synthesize username;
@synthesize password;
@synthesize responseStatusCode;
@synthesize delegate;
@synthesize error;
@synthesize completionHandler;

- (id)initWithURL:(NSURL *)theURL username:(NSString *)theUsername password:(NSString *)thePassword
{
    if ((self = [super init]))
    {
        URL = [theURL retain];
        username = [theUsername copy];
        password = [thePassword copy];
    }
    
    return self;
}

#pragma mark -
#pragma mark Memory Management
// +--------------------------------------------------------------------
// | Memory Management
// +--------------------------------------------------------------------

- (void)dealloc 
{    
    [connection release];
    [responseData release];
    [URL release];
    [username release];
    [password release];
    [completionHandler release];
    [error release];
    delegate = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Instance Methods
// +--------------------------------------------------------------------
// | Instance Methods
// +--------------------------------------------------------------------

- (HSCalDAV *)fetchCalendarsWithCompletionHandler:(HSCalDavCompletionHandler)handler;
{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:self.URL];
    
    [req setHTTPMethod:@"OPTIONS"];  
    //[req setValue:@"application/xml" forHTTPHeaderField:@"Content-Type:"];

    self.completionHandler = handler;
    
    [self sendRequest:req];
    
    return self;
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods
// +--------------------------------------------------------------------
// | NSURLConnection Delegate Methods
// +--------------------------------------------------------------------

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)theData
{
    if ((self.responseData == nil)) 
    {
        self.responseData = [NSMutableData data];
    }
    
    [self.responseData appendData:theData];
}

- (void)connection:(NSURLConnection *)theConnection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)theChallenge 
{
    if (([theChallenge previousFailureCount] == 0))
    {    
        NSURLCredential *credential = [NSURLCredential credentialWithUser:self.username password:self.password persistence:NSURLCredentialPersistenceForSession];
        
        [[theChallenge sender] useCredential:credential forAuthenticationChallenge:theChallenge];
        
        return;
    }
}

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)theResponse 
{  
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)theResponse;
    
    if ((![httpResponse isKindOfClass:[NSHTTPURLResponse class]])) 
    {
        NSLog(@"Unknown response type: %@", theResponse);
        return;
    }
    
    self.responseStatusCode = [httpResponse statusCode];
	
	NSLog(@"%@", [httpResponse allHeaderFields]);
    
    if (self.responseStatusCode >= 400) 
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:theConnection, @"connection", nil];
        self.error = [NSError errorWithDomain:HSCalDAVErrorDomain code:[httpResponse statusCode] userInfo:userInfo];
        completionHandler(nil, error);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)theError 
{  
    self.error = theError;
    completionHandler(nil, self.error);
    
    [self autorelease];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{  
    completionHandler(self, nil);
    [self autorelease];
}


#pragma mark -
#pragma mark Private/Convenience Methods
// +--------------------------------------------------------------------
// | Private/Convenience Methods
// +--------------------------------------------------------------------

- (void)sendRequest:(NSMutableURLRequest *)theRequest 
{
    [NSURLConnection connectionWithRequest:theRequest delegate:self];
}


#pragma mark -
#pragma mark Stream Methods
// +--------------------------------------------------------------------
// | Stream Methods
// +--------------------------------------------------------------------

- (void)openStream
{
	/*CFURLRef someURL = CFURLCreateWithString(kCFAllocatorDefault, CFSTR("https://cal.me.com"), NULL);

	CFHTTPMessageRef myHTTPMessageRequest = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("GET"), url, kCFHTTPVersion1_1);

	CFReadStreamRef myReadStream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, myHTTPMessageRequest);

	//CFMutableDictionaryRef sslDict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	CFMutableDictionaryRef sslDict = {
		kCFStreamSSLAllowsAnyRoot = 1;
		kCFStreamSSLAllowsExpiredCertificates = 1;
		kCFStreamSSLAllowsExpiredRoots = 1;
		kCFStreamSSLLevel = kCFStreamSocketSecurityLevelNegotiatedSSL;
	}
	
	if (CFReadStreamSetProperty(myReadStream, kCFStreamPropertySSLSettings, sslDict))
	{
		NSLog(@"Good");
	}
	else
	{
		NSLog(@"Bad");
	}

	CFRelease(url);*/
	
	/*NSStream *inputStream;
    NSStream *outputStream;
	
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
									   CFSTR("www.google.com"),
									   443,
									   (CFReadStreamRef *)&inputStream,
									   (CFWriteStreamRef *)&outputStream);
	
    // adjust as necessary
    NSDictionary *sslSettings = [NSDictionary dictionaryWithObjectsAndKeys:
								 (NSString *)kCFStreamSocketSecurityLevelNegotiatedSSL,
								 kCFStreamSSLLevel,
								 [NSNumber numberWithBool:YES], kCFStreamSSLAllowsExpiredCertificates,
								 [NSNumber numberWithBool:YES], kCFStreamSSLAllowsExpiredRoots,
								 [NSNumber numberWithBool:YES], kCFStreamSSLAllowsAnyRoot,
								 [NSNumber numberWithBool:NO], kCFStreamSSLValidatesCertificateChain,
								 kCFNull, kCFStreamSSLPeerName,
								 nil];
	
    CFReadStreamSetProperty((CFReadStreamRef)inputStream, kCFStreamPropertySSLSettings, sslSettings);
    CFWriteStreamSetProperty((CFWriteStreamRef)outputStream, kCFStreamPropertySSLSettings, sslSettings);
	

	if (!CFReadStreamOpen((CFReadStreamRef)inputStream))
	{
		// An error has occurred
		CFErrorRef myErr = CFReadStreamCopyError((CFReadStreamRef)inputStream);

		CFStringRef errorDesc = CFErrorCopyDescription(myErr);
		
		NSLog(@"errorDesc: %@", errorDesc);
	}
	else
	{
		BOOL done;
		NSLog(@"starting loop");
		while (!done)
		{
			if (CFReadStreamHasBytesAvailable((CFReadStreamRef)inputStream))
			{
				UInt8 buf[BUFSIZE];
				
				CFIndex bytesRead = CFReadStreamRead((CFReadStreamRef)inputStream, buf, BUFSIZE);
				
				if (bytesRead < 0)
				{
					CFErrorRef error = CFReadStreamCopyError((CFReadStreamRef)inputStream);
					
					CFStringRef errorDesc = CFErrorCopyDescription(error);
					
					NSLog(@"errorDesc2: %@", errorDesc);
				}
				else if (bytesRead == 0)
				{
					if (CFReadStreamGetStatus((CFReadStreamRef)inputStream) == kCFStreamStatusAtEnd)
					{
						done = TRUE;
						NSLog(@"Done");
					}
				}
				else
				{
					for (NSInteger idx = 0; idx < bytesRead; idx++)
					{
						NSLog(@"HERE %hhu", buf[idx]);
					}
				}
			}
			else
			{
				// wait
				NSLog(@"waiting");
			}
		}
	}*/
	
	NSString *urlStr = @"hashbangind.com";

    if (![urlStr isEqualToString:@""])
	{
        NSHost *host = [NSHost hostWithName:urlStr];

        // iStream and oStream are instance variables
        [NSStream getStreamsToHost:host port:22 inputStream:&iStream outputStream:&oStream];

        [iStream retain];
        [oStream retain];
        
		[iStream setDelegate:self];
        [oStream setDelegate:self];

		[iStream setProperty:NSStreamSocketSecurityLevelNegotiatedSSL forKey:NSStreamSocketSecurityLevelKey];
		[oStream setProperty:NSStreamSocketSecurityLevelNegotiatedSSL forKey:NSStreamSocketSecurityLevelKey];
		
		NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
								  [NSNumber numberWithBool:YES], kCFStreamSSLAllowsExpiredCertificates,
								  [NSNumber numberWithBool:YES], kCFStreamSSLAllowsExpiredRoots,
								  [NSNumber numberWithBool:YES], kCFStreamSSLAllowsAnyRoot,
								  [NSNumber numberWithBool:NO], kCFStreamSSLValidatesCertificateChain,
								  kCFNull,kCFStreamSSLPeerName,
								  nil];
		
		CFReadStreamSetProperty((CFReadStreamRef)iStream, kCFStreamPropertySSLSettings, (CFTypeRef)settings);
		CFWriteStreamSetProperty((CFWriteStreamRef)oStream, kCFStreamPropertySSLSettings, (CFTypeRef)settings);
        
		[iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

        [iStream open];
        [oStream open];
		
		NSLog(@"Opened Streams");
	}

}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
{
    NSLog(@"stream:handleEvent: is invoked...");
	
    switch(eventCode)
	{
		case NSStreamEventOpenCompleted:
			NSLog(@"NSStreamEventOpenCompleted");
		break;
			
		case NSStreamEventHasSpaceAvailable:
			NSLog(@"NSStreamEventHasSpaceAvailable");
		break;
			
		case NSStreamEventEndEncountered:
			NSLog(@"NSStreamEventEndEncountered");
		break;
			
		case NSStreamEventErrorOccurred:
			NSLog(@"NSStreamEventErrorOccurred");
		break;
			
		case NSStreamEventNone:
			NSLog(@"NSStreamEventNone");
		break;
		
        case NSStreamEventHasBytesAvailable:
        {
			NSLog(@"NSStreamEventHasBytesAvailable");
            if (!mydata)
			{
                mydata = [[NSMutableData data] retain];
            }
			
			uint8_t buf[BUFSIZE];
			
			unsigned int len = 0;

			len = (unsigned int)[(NSInputStream *)stream read:buf maxLength:BUFSIZE];
			
			if (len)
			{
				[mydata appendBytes:(const void *)buf length:len];
				
				// bytesRead is an instance variable of type NSNumber.
				bytesRead = [NSNumber numberWithInt:[bytesRead intValue]+len];
			}
			else
			{
				NSLog(@"no buffer!");
			}
			
            break;
        }
			
		default:
			NSLog(@"%lu", eventCode);
		break;
    }
	
}

@end
