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

#import "OMFMainPanelController.h"
#import "OMFStatusItemView.h"
#import "OMFPanelBackgroundView.h"

#import "MASPreferencesWindowController.h"
    #import "OMCGeneralViewController.h"
    #import "OMCKeyBindingsViewController.h"
    #import "OMCAboutViewController.h"

// OMFMainPanelController class
@implementation OMFMainPanelController
    {
    struct
        { /* Cache the infomation identified does the self.delegate implement the methods
           * in OMFMainPanelControllerDelegate protocol */
        unsigned short canFetchTheStatusItemForPanelController : 1;
        } _delegateFlags;
    }

@synthesize delegate = _delegate;

@synthesize backgrondView = _backgroundView;

@dynamic preferencesPanelController;

@synthesize hasOpened = _hasOpened;
@synthesize currentOpenMode = _currentOpenMode;

@synthesize _startAtLoginMenuItem;
@synthesize _calloutByKeyCombinationMenuItem;

#pragma mark Initializers & Deallocators
+ ( id ) mainPanelControllerWithDelegate: ( id <OMFMainPanelControllerDelegate> )_Delegate
    {
    return [ [ [ [ self class ] alloc ] initWithDelegate: _Delegate ] autorelease ];
    }

- ( id ) initWithDelegate: ( id <OMFMainPanelControllerDelegate> )_Delegate
    {
    if ( self = [ super initWithWindowNibName: @"OMFMainPanel" ] )
        {
        self.delegate = _Delegate;
        self.hasOpened = NO;
        self.currentOpenMode = OMCHangInMenuMode;
        }

    return self;
    }

#pragma mark Conforms <NSAwakeFromNib> protocol
- ( void ) awakeFromNib
    {
    [ self.window setOpaque: NO ];
    [ self.window setBackgroundColor: [ NSColor clearColor ] ];
    [ self.window setLevel: NSPopUpMenuWindowLevel ];

    [ self.backgrondView setArrowX: NSWidth( [ self.window frame ] ) / 2 ];

    [ self._calloutByKeyCombinationMenuItem setState: [ USER_DEFAULTS boolForKey: OMCDefaultsKeyCalloutByKeyCombination ] ];
    [ self._startAtLoginMenuItem setState: [ USER_DEFAULTS boolForKey: OMCDefaultsKeyStartAtLogin ] ];
    }

#pragma mark Panel Handling
- ( NSRect ) frameBasedOnFrameOfStatusItemView: ( NSRect )_Frame
    {
    NSRect newFrame = _Frame;

    if ( self->_delegateFlags.canFetchTheStatusItemForPanelController )
        {
        NSRect frameOfStatusItemView = [ [ self.delegate statusItemViewForPanelController: self ] globalRect ];

        NSPoint newOrigin = NSMakePoint( NSMidX( frameOfStatusItemView ) - NSWidth( _Frame ) / 2
                                    , NSMinY( frameOfStatusItemView ) - NSHeight( _Frame )
                                    );
        newFrame.origin = newOrigin;
        }

    return newFrame;
    }

- ( NSRect ) frameCenteredInScreen: ( NSRect )_Frame
    {
    NSScreen* mainScreen = [ NSScreen mainScreen ];

    NSRect newFrame = _Frame;
    NSPoint newOrigin = NSMakePoint( ( NSMaxX( mainScreen.visibleFrame ) - NSWidth( _Frame ) ) / 2
                                   , ( NSMaxY( mainScreen.visibleFrame ) - NSHeight( _Frame ) ) / 2 + 100.f
                                   );
    newFrame.origin = newOrigin;
    return newFrame;
    }

- ( void ) openPanelWithMode: ( OMCOpenMode )_OpenMode
    {
    NSRect newFrame = ( _OpenMode == OMCHangInMenuMode )
                            ? [ self frameBasedOnFrameOfStatusItemView: self.window.frame ]
                            : [ self frameCenteredInScreen: self.window.frame ];

    [ self.window setFrame: newFrame display: YES ];
    [ self setCurrentOpenMode: _OpenMode ];

    [ self.window makeKeyAndOrderFront: self ];
    [ NSApp activateIgnoringOtherApps: YES ];

    self.hasOpened = YES;
    }

- ( void ) closePanel
    {
    [ self.window orderOut: self ];

    self.hasOpened = NO;
    }


#pragma mark Accessors
- ( void ) setCurrentOpenMode:( OMCOpenMode )_OpenMode
    {
    if ( self->_currentOpenMode != _OpenMode )
        {
        self->_currentOpenMode = _OpenMode;
        [ self.window display ];
        }
    }

- ( void ) setDelegate:( id <OMFMainPanelControllerDelegate> )_Delegate
    {
    _delegate = _Delegate;

    _delegateFlags.canFetchTheStatusItemForPanelController =
        [ self.delegate respondsToSelector: @selector( statusItemViewForPanelController: ) ];
    }

MASPreferencesWindowController static* sPreferencesPanelController = nil;
- ( MASPreferencesWindowController* ) preferencesPanelController
    {
    if ( !sPreferencesPanelController )
        {
        OMCGeneralViewController* generalViewController = [ OMCGeneralViewController generalViewController ];
        OMCKeyBindingsViewController* keyBindingsController = [ OMCKeyBindingsViewController keyBindingsViewController ];
        OMCAboutViewController* aboutViewController = [ OMCAboutViewController aboutViewController ];

        sPreferencesPanelController =
            [ [ MASPreferencesWindowController preferencesWindowControllerWithViewControllers:
                    @[ generalViewController, keyBindingsController, [ NSNull null ], aboutViewController ] ] retain ];
        }

    return sPreferencesPanelController;
    }

#pragma mark Conforms <NSWindowDelegate> protocol
- ( void ) windowDidResize: ( NSNotification* )_Notif
    {
    [ self.backgrondView setArrowX: NSWidth( [ self.window frame ] ) / 2 ];
    }

- ( void ) windowDidResignKey: ( NSNotification* )_Notif
    {
    [ self _fuckPanel: NO ];
    }

- ( void ) _fuckPanel: ( BOOL )_IsHighlighting
    {
    if ( self->_delegateFlags.canFetchTheStatusItemForPanelController )
        {
        OMFStatusItemView* statusItemView = [ self.delegate statusItemViewForPanelController: self ];

        if ( _IsHighlighting )
            {
            [ statusItemView setHighlighting: YES ];
            [ self openPanelWithMode: OMCHangInMenuMode ];
            }
        else
            {
            [ statusItemView setHighlighting: NO ];
            [ self closePanel ];
            }
        }
    }

#pragma mark IBActions
- ( IBAction ) showPreferences: ( id )_Sender
    {
    [ self.preferencesPanelController showWindow: self ];
    }

- ( IBAction ) about: ( id )_Sender
    {
    [ self.preferencesPanelController selectControllerAtIndex: 3 ];
    [ self.preferencesPanelController showWindow: self ];
    }

@end // OMFMainPanelController

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