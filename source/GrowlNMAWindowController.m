//
//  GrowlNMAWindowController.m
//
//  Copyright: 2011 Adriano Maia



#import "GrowlNMAWindowController.h"
#import "GrowlNMAPrefs.h"
#import "GrowlDefinesInternal.h"
#import "GrowlDefines.h"
#import "GrowlApplicationNotification.h"


@implementation GrowlNMAWindowController

- (id) init {
	return self;
}

#pragma mark -

// base64 encoding
// seeAlso: http://davidjhinson.wordpress.com/2009/03/09/objective-c-and-http-basic-authentication/

static char base64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
"abcdefghijklmnopqrstuvwxyz"
"0123456789"
"+/";

int base64encode(unsigned int s_len, char *src, unsigned int d_len, char *dst)
{
	unsigned triad;
	
	for (triad = 0; triad < s_len; triad += 3)
	{
		unsigned long int sr;
		unsigned byte;
		
		for (byte = 0; (byte<3)&&(triad+byte<s_len); ++byte)
		{
			sr <<= 8;
			sr |= (*(src+triad+byte) & 0xff);
		}
		
		sr <<= (6-((8*byte)%6))%6; /*shift left to next 6bit alignment*/
		
		if (d_len < 4) return 1; /* error - dest too short */
		
		*(dst+0) = *(dst+1) = *(dst+2) = *(dst+3) = '=';
		switch(byte)
		{
			case 3:
				*(dst+3) = base64[sr&0x3f];
				sr >>= 6;
			case 2:
				*(dst+2) = base64[sr&0x3f];
				sr >>= 6;
			case 1:
				*(dst+1) = base64[sr&0x3f];
				sr >>= 6;
				*(dst+0) = base64[sr&0x3f];
		}
		dst += 4; d_len -= 4;
	}
	return 0;	
}


NSString* encodeURIString(NSString* s) {
	return [((NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																(CFStringRef)s,
																NULL,
																(CFStringRef)@"!*'();:@&=+$,/?%#[]",
																kCFStringEncodingUTF8)) autorelease];
}


- (void) setNotification: (GrowlApplicationNotification *) theNotification {
	[super setNotification:theNotification];
	if (!theNotification)
		return;
	
	NSDictionary *noteDict = [notification dictionaryRepresentation];
	NSString *title = [notification title];
	NSString *text  = [notification notificationDescription];
	NSString *appname = [notification applicationName];  // name?
	int prio        = [[noteDict valueForKey:GROWL_NOTIFICATION_PRIORITY] intValue];

	NSString *nma_apikey = NMA_DEFAULT_APIKEY;
	READ_GROWL_PREF_VALUE(NMA_APIKEY_PREF, NMAPrefDomain, NSString *, &nma_apikey);
	NSString *nma_label = NMA_DEFAULT_LABEL;
	READ_GROWL_PREF_VALUE(NMA_LABEL_PREF, NMAPrefDomain, NSString *, &nma_label);
	
	//NSLog(@"NMA data: ak: %@, label=%@%@, title: %@, text: %@, prio: %d",
	//   nma_apikey, nma_label, appname, title, text, prio);

	// Create and send request
	NSString *postContent = [NSString stringWithFormat:@"apikey=%@&application=%@%@&event=%@&description=%@&priority=%d",
									   encodeURIString(nma_apikey), encodeURIString(nma_label), encodeURIString(appname), encodeURIString(title), 
									   encodeURIString(text), prio];
	NSURL *url = [NSURL URLWithString:@"https://www.notifymyandroid.com/publicapi/notify"];
	NSMutableURLRequest *theRequest = (NSMutableURLRequest*)[[NSMutableURLRequest alloc] initWithURL:url];
	//[theRequest addValue:authenticationString forHTTPHeaderField: @"Authorization"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody:[postContent dataUsingEncoding:NSUTF8StringEncoding]];
	NSURLResponse* response;
	NSError *error = nil;
	NSData *result = [NSURLConnection sendSynchronousRequest:theRequest
										   returningResponse:&response
													   error:&error];
	if(error)
		NSLog(@"NMA connection error = %@", error);
	
	NSString *resultString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
	NSLog(@"NMA result: %@", resultString);
	// NSLog(@"NMA postContent: %@", postContent);
	
	[resultString release];
	[theRequest release];
}


@end
