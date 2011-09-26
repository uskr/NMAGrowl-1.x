//
//  GrowlNMAPrefs.m
//
//  Copyright: 2011 Adriano Maia

#import "GrowlNMAPrefs.h"
#import "GrowlDefinesInternal.h"

@interface GrowlNMAPrefs (PRIVATE)

- (void) populateDisplaysPopUpButton:(NSPopUpButton *)popUp nameOfSelectedDisplay:(NSString *)nameOfSelectedDisplay includeDefaultMenuItem:(BOOL)includeDefault;

@end

@implementation GrowlNMAPrefs

- (NSString *) mainNibName {
	return @"GrowlNMAPrefs";
}

- (void) mainViewDidLoad {
	// do something
	[self setDisplayPlugins:[[[GrowlPluginController sharedController] displayPlugins] valueForKey:GrowlPluginInfoKeyName]];
	[self populateDisplaysPopUpButton:forwardMenuButton nameOfSelectedDisplay:[self forwardPluginName] includeDefaultMenuItem:NO];
}

- (void) didSelect {
	SYNCHRONIZE_GROWL_PREFS();
}

/*- (NSString *) notifoUsername {
	NSString *value = nil;
	READ_GROWL_PREF_VALUE(NMA_USERNAME_PREF, NMAPrefDomain, NSString *, &value);
	return value;
}
- (void) setNMAUsername:(NSString *)value {
	if (value == NULL) {
		value = @"";
	}
	WRITE_GROWL_PREF_VALUE(NMA_USERNAME_PREF, value, NMAPrefDomain);
	UPDATE_GROWL_PREFS();
}*/

#pragma mark -
#pragma mark Bindings accessors (not for programmatic use)

- (GrowlPluginController *) pluginController {
	if (!pluginController)
		pluginController = [GrowlPluginController sharedController];
	
	return pluginController;
}

- (NSString *) forwardPluginName {
	NSString *value = nil;
	READ_GROWL_PREF_VALUE(NMA_FORWARD_PLUGIN_PREF, NMAPrefDomain, NSString *, &value);
	if (value == NULL) {
		value = @"Smoke";
	}
	return value;
}
- (void) setForwardPluginName:(NSString *)value {
	if (value == NULL) {
		value = @"Smoke";
	}
	WRITE_GROWL_PREF_VALUE(NMA_FORWARD_PLUGIN_PREF, value, NMAPrefDomain);
	UPDATE_GROWL_PREFS();
}

- (NSString *) nmaApikey {
	NSString *value = nil;
	READ_GROWL_PREF_VALUE(NMA_APIKEY_PREF, NMAPrefDomain, NSString *, &value);
	return value;
}
- (void) setNmaApikey:(NSString *)value {
	if (value == NULL) {
		value = @"";
	}
	WRITE_GROWL_PREF_VALUE(NMA_APIKEY_PREF, value, NMAPrefDomain);
	UPDATE_GROWL_PREFS();
}

- (NSString *) nmaLabel {
	NSString *value = nil;
	READ_GROWL_PREF_VALUE(NMA_LABEL_PREF, NMAPrefDomain, NSString *, &value);
	return value;
}
- (void) setNmaLabel:(NSString *)value {
	if (value == NULL) {
		value = @"";
	}
	WRITE_GROWL_PREF_VALUE(NMA_LABEL_PREF, value, NMAPrefDomain);
	UPDATE_GROWL_PREFS();
}

- (BOOL) forwardNotification {
	BOOL value = FALSE;
	NSNumber *tmpInt = [NSNumber numberWithInt:(int)0];
	READ_GROWL_PREF_VALUE(NMA_FORWARD_PREF, NMAPrefDomain, NSNumber *, &tmpInt);
	if ( [tmpInt intValue] == 1 ) value = TRUE;
	return value;
}

- (void) setForwardNotification:(BOOL)value {
	NSNumber *tmpInt = [NSNumber numberWithInt:(int)0];
	if ( value == TRUE ) tmpInt = [NSNumber numberWithInt:(int)1];
	
	WRITE_GROWL_PREF_VALUE(NMA_FORWARD_PREF, tmpInt, NMAPrefDomain);
	UPDATE_GROWL_PREFS();
}

- (BOOL) onlyIfIdle {
	BOOL value = FALSE;
	NSNumber *tmpInt = [NSNumber numberWithInt:(int)0];
	READ_GROWL_PREF_VALUE(NMA_IDLECHECK_PREF, NMAPrefDomain, NSNumber *, &tmpInt);
	if ( [tmpInt intValue] == 1) value = TRUE;
	return value;
}

- (void) setOnlyIfIdle:(BOOL)value {
	NSNumber *tmpInt = [NSNumber numberWithInt:(int)0];
	if ( value == TRUE ) tmpInt = [NSNumber numberWithInt:(int)1];
	
	WRITE_GROWL_PREF_VALUE(NMA_IDLECHECK_PREF, tmpInt, NMAPrefDomain);
	UPDATE_GROWL_PREFS();
}

- (BOOL) ifScreensaver {
	BOOL value = FALSE;
	NSNumber *tmpInt = [NSNumber numberWithInt:(int)0];
	READ_GROWL_PREF_VALUE(NMA_SCREENSAVER_PREF, NMAPrefDomain, NSNumber *, &tmpInt);
	if ( [tmpInt intValue] == 1) value = TRUE;
	return value;
}

- (void) setIfScreensaver:(BOOL)value {
	NSNumber *tmpInt = [NSNumber numberWithInt:(int)0];
	if ( value == TRUE ) tmpInt = [NSNumber numberWithInt:(int)1];
	WRITE_GROWL_PREF_VALUE(NMA_SCREENSAVER_PREF, tmpInt, NMAPrefDomain);
	UPDATE_GROWL_PREFS();
}

- (NSUInteger) idleTimer {
	NSNumber *value = [NSNumber numberWithUnsignedInt:(int)0];
	READ_GROWL_PREF_VALUE(NMA_IDLETIMER_PREF, NMAPrefDomain, NSNumber *, &value);
	return (NSUInteger)[value unsignedIntValue];
}
- (void) setIdleTimer:(NSUInteger)value {
	NSNumber *tmpInt = [NSNumber numberWithUnsignedInt:(unsigned int)value];
	
	
	WRITE_GROWL_PREF_VALUE(NMA_IDLETIMER_PREF, tmpInt, NMAPrefDomain);
	UPDATE_GROWL_PREFS();
}

- (NSArray *) displayPlugins {
	return plugins;
}

- (void) setDisplayPlugins:(NSArray *)thePlugins {
	if (thePlugins != plugins) {
		[plugins release];
		plugins = [thePlugins retain];
	}
}

- (IBAction) changeNameOfForwardPlugin:(id)sender {
	NSString *newForwardPluginName = [[sender selectedItem] representedObject];
	[self setForwardPluginName:newForwardPluginName];
}

//Empties the pop-up menu and fills it out with a menu item for each display, optionally including a special menu item for the default display, selecting the menu item whose name is nameOfSelectedDisplay.
- (void) populateDisplaysPopUpButton:(NSPopUpButton *)popUp nameOfSelectedDisplay:(NSString *)nameOfSelectedDisplay includeDefaultMenuItem:(BOOL)includeDefault {
	NSMenu *menu = [popUp menu];
	NSString *nameOfDisplay = nil, *displayNameOfDisplay;
	
	NSMenuItem *selectedItem = nil;
	
	[popUp removeAllItems];
	
	if (includeDefault) {
		displayNameOfDisplay = NSLocalizedStringFromTableInBundle(@"Default", nil, [NSBundle bundleForClass:[self class]], /*comment*/ @"Title of menu item for default display");
		NSMenuItem *item = [menu addItemWithTitle:displayNameOfDisplay
										   action:NULL
									keyEquivalent:@""];
		[item setRepresentedObject:nil];
		
		if (!nameOfSelectedDisplay)
			selectedItem = item;
		
		[menu addItem:[NSMenuItem separatorItem]];
	}
	
	NSEnumerator *displaysEnum = [[plugins sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectEnumerator];
	while ((nameOfDisplay = [displaysEnum nextObject])) {
		if (nameOfDisplay == @"NotifyMyAndroid") continue;
		displayNameOfDisplay = [[pluginController pluginDictionaryWithName:nameOfDisplay] pluginHumanReadableName];
		if (!displayNameOfDisplay)
			displayNameOfDisplay = nameOfDisplay;
		
		NSMenuItem *item = [menu addItemWithTitle:displayNameOfDisplay
										   action:NULL
									keyEquivalent:@""];
		[item setRepresentedObject:nameOfDisplay];
		
		if (nameOfSelectedDisplay && [nameOfSelectedDisplay respondsToSelector:@selector(isEqualToString:)] && [nameOfSelectedDisplay isEqualToString:nameOfDisplay])
			selectedItem = item;
	}
	
	[popUp selectItem:selectedItem];
}

	
@end
