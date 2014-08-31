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

#import "OMFAboutPanelController.h"

// OMFAboutPanelController class
@implementation OMFAboutPanelController

#pragma mark Initializers
+ ( id ) aboutPanelController
    {
    return [ [ [ [ self class ] alloc ] init ] autorelease ];
    }

- ( id ) init
    {
    if ( self = [ super initWithWindowNibName: @"OMFAboutPanel" ] )
        {
        // TODO:
        }

    return self;
    }

#pragma mark Conforms <NSNibAwaking> protocol
- ( void ) awakeFromNib
    {
    // TODO:
    }

#pragma mark Actions
- ( IBAction ) emailMe: ( id )_Sender
    {
    NSURL* emailURL = [ NSURL URLWithString: @"mailto:Tong-G@outlook.com"
                                              "?subject=Hey,%20Tong%20Guo!" ];
    [ [ NSWorkspace sharedWorkspace ] openURL: emailURL ];
    }

- ( IBAction ) followMeOnTwitter: ( id )_Sender
    {
    NSURL* twitterURL = [ NSURL URLWithString: @"https://twitter.com/NSTongG" ];
    [ [ NSWorkspace sharedWorkspace ] openURL: twitterURL ];
    }

@end // OMFAboutPanelController

//////////////////////////////////////////////////////////////////////////////

/*****************************************************************************
 **                                                                         **
 **      _________                                      _______             **
 **     |___   ___|                                   / ______ \            **
 **         | |     _______   _______   _______      | /      |_|           **
 **         | |    ||     || ||     || ||     ||     | |    _ __            **
 **         | |    ||     || ||     || ||     ||     | |   |__  \           **
 **         | |    ||     || ||     || ||     ||     | \_ _ __| |  _        **
 **         |_|    ||_____|| ||     || ||_____||      \________/  |_|       **
 **                                           ||                            **
 **                                    ||_____||                            **
 **                                                                         **
 ****************************************************************************/
///:~