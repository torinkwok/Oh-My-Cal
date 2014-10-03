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
#import "OMFAboutPanelController.h"
#import "OMFPreferencesPanelController.h"

// OMFMainPanelController class
@implementation OMFMainPanelController

@synthesize delegate = _delegate;

@synthesize backgrondView = _backgroundView;
@synthesize aboutPanelController;
@synthesize preferencesPanelController;

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
    NSRect frameOfStatusItemView = [ [ self.delegate statusItemViewForPanelController: self ] globalRect ];

    NSRect newFrame = _Frame;
    NSPoint newOrigin = NSMakePoint( NSMidX( frameOfStatusItemView ) - NSWidth( _Frame ) / 2
                                , NSMinY( frameOfStatusItemView ) - NSHeight( _Frame )
                                );
    newFrame.origin = newOrigin;
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

#pragma mark IBActions
- ( IBAction ) about: ( id )_Sender
    {
    if ( !self.aboutPanelController )
        self.aboutPanelController = [ OMFAboutPanelController aboutPanelController ];

    [ self.aboutPanelController showWindow: self ];
    }

- ( IBAction ) showPreferences: ( id )_Sender
    {
    if ( !self.preferencesPanelController )
        self.preferencesPanelController = [ OMFPreferencesPanelController preferencesPanelController ];

    [ self.preferencesPanelController showWindow: self ];
    }

- ( IBAction ) changedCalloutByKeyCombination: ( id )_Sender
    {
    [ self._calloutByKeyCombinationMenuItem setState: ![ _Sender state ] ];

    [ USER_DEFAULTS setBool: [ self._calloutByKeyCombinationMenuItem state ]
                     forKey: OMCDefaultsKeyCalloutByKeyCombination ];

    [ USER_DEFAULTS synchronize ];
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