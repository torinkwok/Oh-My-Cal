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

#import "OMFStatusBarController.h"
#import "OMFStatusItemView.h"

// Image names
NSString* const OMFStatusBarControllerStatusBarItemIconName = @"statusbar-fan.png";
NSString* const OMFStatusBarControllerStatusBarItemAlternateIconName = @"statusbar-fan-highlighting.png";

// OMFStatusBarController class
@implementation OMFStatusBarController

@synthesize statusItemView = _statusItemView;

@synthesize hasActiveIcon = _hasActiveIcon;

#pragma mark Initializers & Deallocators
+ ( id ) statusBarController
    {
    return [ [ [ [ self class ] alloc ]init ] autorelease ];
    }

- ( id ) init
    {
    if ( self = [ super init ] )
        {
        NSStatusItem* statusItem = [ [ NSStatusBar systemStatusBar ] statusItemWithLength: NSSquareStatusItemLength ];

        self.statusItemView = [ OMFStatusItemView statusItemViewWithStatusItem: statusItem ];
        [ statusItem setLength: 25 ];

        NSImage* icon = [ NSImage imageNamed: OMFStatusBarControllerStatusBarItemIconName ];
        NSImage* alternateIcon = [ NSImage imageNamed: OMFStatusBarControllerStatusBarItemAlternateIconName ];
        [ icon setSize: NSMakeSize( 15, 15 ) ];
        [ alternateIcon setSize: NSMakeSize( 15, 15 ) ];

        [ self.statusItemView setStatusItemIcon: icon ];
        [ self.statusItemView setStatusItemAlternateIcon: alternateIcon ];
        [ self.statusItemView setAction: @selector( togglePanel: ) ];
        }

    return self;
    }

#pragma mark Accessors
- ( NSStatusItem* ) statusItem
    {
    return self.statusItemView.statusItem;
    }


- ( void ) setHasActiveIcon: ( BOOL )_HasActiveIcon
    {
    self.statusItemView.isHighlighting = _HasActiveIcon;
    }

- ( BOOL ) hasActiveIcon
    {
    return self.statusItemView.isHighlighting;
    }

@end // OMFStatusBarController

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