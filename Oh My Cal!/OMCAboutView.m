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

#import "OMCAboutView.h"

@implementation OMCAboutView

- ( BOOL ) mouseDownCanMoveWindow
    {
    return NO;
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

- ( IBAction ) forkThisRepoOnGitHub: ( id )_Sender;
    {
    NSURL* twitterURL = [ NSURL URLWithString: @"https://github.com/TongG/Oh-My-Cal" ];
    [ [ NSWorkspace sharedWorkspace ] openURL: twitterURL ];
    }

- ( IBAction ) importMyGnuPGPubKey: ( id )_Sender
    {
    NSURL* pubkeyFileURL = [ [ NSBundle mainBundle ] URLForResource: @"pubkey" withExtension: @"txt" ];
    [ [ NSWorkspace sharedWorkspace ] openURL: pubkeyFileURL ];
    }

@end // OMCAboutView

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