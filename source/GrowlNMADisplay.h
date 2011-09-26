//
//  GrowlNMADisplay.h
//
//  Copyright: 2011 Adriano Maia


#import <Cocoa/Cocoa.h>
#import <GrowlDisplayPlugin.h>


@class GrowlApplicationNotification;

@interface GrowlNMADisplay : GrowlDisplayPlugin {
}

- (void) configureBridge:(GrowlNotificationDisplayBridge *)theBridge;

@end
