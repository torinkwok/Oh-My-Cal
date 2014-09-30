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
    }

#pragma mark Panel Handling
- ( NSRect ) frameBasedOnFrameOfStatusItemView: ( NSRect )_Frame
    {
    NSRect frameOfStatusItemView = [ [ self.delegate statusItemViewForPanelController: self ] globalRect ];

    NSRect frame = _Frame;
    NSPoint origin = NSMakePoint( NSMidX( frameOfStatusItemView ) - NSWidth( _Frame ) / 2
                                , NSMinY( frameOfStatusItemView ) - NSHeight( _Frame )
                                );
    frame.origin = origin;

    return frame;
    }

- ( void ) openPanelWithMode: ( OMCOpenMode )_OpenMode
    {
    if ( _OpenMode == OMCHangInMenuMode )
        [ self.window setFrame: [ self frameBasedOnFrameOfStatusItemView: self.window.frame ] display: YES ];
    else if ( _OpenMode == OMCGlobalCalloutMode )
        [ self.window center ];

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