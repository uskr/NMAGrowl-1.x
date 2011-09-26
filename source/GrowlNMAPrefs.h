//
//  GrowlNMAPrefs.h
//
//  Copyright: 2011 Adriano Maia

#import <PreferencePanes/PreferencePanes.h>
#import "GrowlDefinesInternal.h"	// for NSInteger/NSUInteger
#import "GrowlPlugin.h"
#import "GrowlPluginController.h"

#define NMAPrefDomain			@"com.nma.growl"

#define NMA_SCREEN_PREF			@"Screen"

#define NMA_APIKEY_PREF	 @"API Key"
#define NMA_DEFAULT_APIKEY	 @""

#define NMA_LABEL_PREF	 @"Label"
#define NMA_DEFAULT_LABEL	 @"[Growl]"

#define NMA_FORWARD_PREF	@"ForwardNotification"
#define NMA_DEFAULT_FORWARD	FALSE

#define NMA_FORWARD_PLUGIN_PREF	@"ForwardlPluginName"
#define NMA_DEFAULT_FORWARD_PLUGIN	@"Smoke"

#define NMA_IDLECHECK_PREF	@"OnlyIfIdle"
#define NMA_DEFAULT_IDLECHECK	FALSE

#define NMA_IDLETIMER_PREF	@"IdleTimer"
#define NMA_DEFAULT_IDLETIMER	0

#define NMA_SCREENSAVER_PREF	@"OnlyIfScreensaver"
#define NMA_DEFAULT_SCREENSAVER	FALSE

@class GrowlPluginController, GrowlPlugin;

@interface GrowlNMAPrefs : NSPreferencePane {
	NSArray							*plugins;
	GrowlPluginController			*pluginController;
	
	IBOutlet NSPopUpButton			*forwardMenuButton;
	IBOutlet NSString *forwardPluginName;
	IBOutlet NSString *nmaApikey;
	IBOutlet NSString *nmaLabel;
	IBOutlet BOOL forwardNotification;
	IBOutlet BOOL onlyIfIdle;
	IBOutlet NSUInteger idleTimer;
	IBOutlet BOOL ifScreensaver;
	IBOutlet NSArrayController		*displayPluginsArrayController;
	
}

#pragma mark Bindings accessors (not for programmatic use)

- (GrowlPluginController *) pluginController;

- (NSString *) forwardPluginName;
- (void) setForwardPluginName:(NSString *)name;
- (NSString *) nmaApikey;
- (void) setNmaApikey:(NSString *)value;
- (NSString *) nmaLabel;
- (void) setNmaLabel:(NSString *)value;
- (BOOL) forwardNotification;
- (void) setForwardNotification:(BOOL)value;
- (BOOL) onlyIfIdle;
- (void) setOnlyIfIdle:(BOOL)value;
- (NSUInteger) idleTimer;
- (void) setIdleTimer:(NSUInteger)value;
- (BOOL) ifScreensaver;
- (void) setIfScreensaver:(BOOL)value;
- (NSArray *) displayPlugins;
- (void) setDisplayPlugins:(NSArray *)thePlugins;
- (IBAction) changeNameOfForwardPlugin:(id)sender;

@end
