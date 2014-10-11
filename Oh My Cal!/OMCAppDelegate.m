///:
/*****************************************************************************
 **                                                                         **
 **                               .======.                                  **
 **                               | INRI |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                      .========'      '========.                         **
 **                      |   _      xxxx      _   |                         **
 **                      |  /_;-.__ / _\  _.-;_\  |                         **
 **                      |     `-._`'`_/'`.-'     |                         **
 **                      '========.`\   /`========'                         **
 **                               | |  / |                                  **
 **                               |/-.(  |                                  **
 **                               |\_._\ |                                  **
 **                               | \ \`;|                                  **
 **                               |  > |/|                                  **
 **                               | / // |                                  **
 **                               | |//  |                                  **
 **                               | \(\  |                                  **
 **                               |  ``  |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                   \\    _  _\\| \//  |//_   _ \// _                     **
 **                  ^ `^`^ ^`` `^ ^` ``^^`  `^^` `^ `^                     **
 **                                                                         **
 **                       Copyright (c) 2014 Tong G.                        **
 **                          ALL RIGHTS RESERVED.                           **
 **                                                                         **
 ****************************************************************************/

#import <Carbon/Carbon.h>
#import <ServiceManagement/ServiceManagement.h>

#import "OMFMainPanelController.h"
#import "OMFStatusBarController.h"

#import "OMCAppDelegate.h"
#import "OMFStatusItemView.h"

#import "OMFMainPanelController.h"

#pragma mark Conforms <OMCMainPanelControllerDelegate> protocol
@implementation OMCAppDelegate ( OMCAppDelegateConformsOMCMainPanelControllerDelegate )

- ( OMFStatusItemView* ) statusItemViewForPanelController: ( OMFMainPanelController* )_StatusItemView
    {
    return self._statusBarController.statusItemView;
    }

@end // OMCAppDelegate + OMCAppDelegateConformsOMCMainPanelControllerDelegate

// OMFAppDelegate class
@implementation OMCAppDelegate

@synthesize _statusBarController;
@synthesize _mainPanelController;

OSStatus hotKeyHandler( EventHandlerCallRef, EventRef, void* );

#pragma mark Conforms <NSAwakeFromNib> protocol
- ( void ) awakeFromNib
    {
    self._statusBarController = [ OMFStatusBarController statusBarController ];
    self._mainPanelController = [ OMFMainPanelController mainPanelControllerWithDelegate: self ];

    EventHotKeyRef hotKeyRef;
    EventHotKeyID hotKeyID;
    EventTypeSpec eventType;
    eventType.eventClass = kEventClassKeyboard;
    eventType.eventKind = kEventHotKeyPressed;

    // The signature of the hot key, actual type is UInt32
    hotKeyID.signature = 'coid';    // Callout ID
    // The ID of the hot key, which be used in handling more than one global hot key
    hotKeyID.id = SHIFT_COMMAND_SPACE__GLOBAL_KEY;

    // Register the hot key through this function
    RegisterEventHotKey( 49, optionKey + shiftKey, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef);

    InstallApplicationEventHandler( &hotKeyHandler, 1, &eventType, NULL, NULL );

    [ NOTIFICATION_CENTER addObserver: self
                             selector: @selector( handleKeyCombinationNotif: )
                                 name: OMCPressedShiftCommandSpaceGlobalKey
                               object: nil ];

#if 0   // Not successful, lost to Sandbox😩
    [ self setStartAtLogin: [ USER_DEFAULTS boolForKey: OMCDefaultsKeyStartAtLogin ] ];
#endif
    }

OSStatus hotKeyHandler( EventHandlerCallRef _NextHandler, EventRef _AnEvent, void* _UserData )
    {
    EventHotKeyID hotKeyRef;

    GetEventParameter( _AnEvent
                     , kEventParamDirectObject, typeEventHotKeyID
                     , NULL, sizeof( hotKeyRef ), NULL, &hotKeyRef
                     );

    unsigned int hotKeyId = hotKeyRef.id;

    switch ( hotKeyId )
        {
    case SHIFT_COMMAND_SPACE__GLOBAL_KEY:
            {
            [ NOTIFICATION_CENTER postNotificationName: OMCPressedShiftCommandSpaceGlobalKey object: nil ];
            } break;

    default:
        break;
        }

    return noErr;
    }

- ( void ) handleKeyCombinationNotif: ( NSNotification* )_Notif
    {
    // If the `Callout by ⌥-⇧-Space Bar` menu item has been checked...
    if ( [ USER_DEFAULTS boolForKey: OMCDefaultsKeyCalloutByKeyCombination ] )
        {
        if ( self._mainPanelController.hasOpened )
            [ self._mainPanelController closePanel ];
        else
            [ self._mainPanelController openPanelWithMode: OMCGlobalCalloutMode ];
        }
    }

- ( IBAction ) togglePanel: ( id )_Sender
    {
    BOOL isHighlighting = self._statusBarController.statusItemView.isHighlighting ;

    [ self._mainPanelController _fuckPanel: !isHighlighting ];
    }

// Not successful, lost to Sandbox😩
- ( void ) setStartAtLogin:( BOOL )_Enabled
    {
    NSString *helperPath = [ [ [ NSBundle mainBundle ] bundlePath ] stringByAppendingPathComponent: @"/Contents/Library/LoginItems/OMCStartHelper.app" ];

    if ( ![ [ NSFileManager defaultManager ] fileExistsAtPath: helperPath ] )
        return;

    NSURL* helperUrl = [ NSURL fileURLWithPath: helperPath ];
 
    // Registering helper app
    OSStatus res = LSRegisterURL( ( __bridge CFURLRef )helperUrl, true );
    if ( res  != noErr )
        NSLog( @"#Error: LSRegisterURL failed" );
 
    // Setting login
    if ( !SMLoginItemSetEnabled( ( CFStringRef )@"individual.TongGuo.OMCStartHelper", true ) )
        NSLog( @"#Error: SMLoginItemSetEnabled failed" );

#if 0
	LSSharedFileListRef loginItems = LSSharedFileListCreate( kCFAllocatorDefault, kLSSharedFileListSessionLoginItems, /*options*/ NULL );

	NSString* path = [ [ NSBundle mainBundle ] bundlePath ];
	
	OSStatus status;
	CFURLRef URLToToggle = ( CFURLRef )[ NSURL fileURLWithPath: path ];
	LSSharedFileListItemRef existingItem = NULL;
	
	UInt32 seed = 0U;
	NSArray *currentLoginItems = [ NSMakeCollectable( LSSharedFileListCopySnapshot( loginItems, &seed ) ) autorelease ];
	
	for ( id itemObject in currentLoginItems )
        {
		LSSharedFileListItemRef item = ( LSSharedFileListItemRef )itemObject;
		
		UInt32 resolutionFlags = kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes;
		CFURLRef URL = NULL;
		OSStatus err = LSSharedFileListItemResolve( item, resolutionFlags, &URL, /*outRef*/ NULL );
		if ( err == noErr )
            {
			Boolean foundIt = CFEqual( URL, URLToToggle );
			CFRelease( URL );
			
			if ( foundIt )
                {
				existingItem = item;
				break;
                }
            }
        }
	
	if ( _Enabled && ( existingItem == NULL ) )
        {
		NSString *displayName = [ [ NSFileManager defaultManager ] displayNameAtPath: path ];
		IconRef icon = NULL;
		FSRef ref;
		Boolean gotRef = CFURLGetFSRef( URLToToggle, &ref );

		if ( gotRef )
            {
			status = GetIconRefFromFileInfo( &ref
                                           , 0      /*fileNameLength*/
                                           , NULL   /*fileName*/
                                           , kFSCatInfoNone
                                           , NULL   /*catalogInfo*/
                                           , kIconServicesNormalUsageFlag
                                           , &icon
                                           , NULL   /*outLabel*/
                                           );
			if ( status != noErr )
				icon = NULL;
            }
		
		LSSharedFileListInsertItemURL( loginItems
                                     , kLSSharedFileListItemBeforeFirst
                                     , ( CFStringRef )displayName
                                     , icon
                                     , URLToToggle
                                     , NULL /*propertiesToSet*/
                                     , NULL /*propertiesToClear*/
                                     );
        }
    else if ( !_Enabled && ( existingItem != NULL ) )
		LSSharedFileListItemRemove( loginItems, existingItem );
#endif
    }

// Not successful, lost to Sandbox😩
- ( IBAction ) changedIsStartAtLogin: ( id )_Sender
    {
    [ _Sender setState: ![ _Sender state ] ];

    [ self setStartAtLogin: [ _Sender state ] ];

    [ USER_DEFAULTS setBool: [ _Sender state ] forKey: OMCDefaultsKeyStartAtLogin ];
    [ USER_DEFAULTS synchronize ];
    }

- ( IBAction ) changedCalloutByKeyCombination: ( id )_Sender
    {
    [ _Sender setState: ![ _Sender state ] ];

    [ USER_DEFAULTS setBool: [ _Sender state ] forKey: OMCDefaultsKeyCalloutByKeyCombination ];
    [ USER_DEFAULTS synchronize ];
    }

@end // OMFAppDelegate

/////////////////////////////////////////////////////////////////////////////

/****************************************************************************
 **                                                                        **
 **      _________                                      _______            **
 **     |___   ___|                                   / ______ \           **
 **         | |     _______   _______   _______      | /      |_|          **
 **         | |    ||     || ||     || ||     ||     | |    _ __           **
 **         | |    ||     || ||     || ||     ||     | |   |__  \          **
 **         | |    ||     || ||     || ||     ||     | \_ _ __| |  _       **
 **         |_|    ||_____|| ||     || ||_____||      \________/  |_|      **
 **                                           ||                           **
 **                                    ||_____||                           **
 **                                                                        **
 ***************************************************************************/
///:~