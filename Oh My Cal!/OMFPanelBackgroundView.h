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

#import <Cocoa/Cocoa.h>

@class OMCLCDScreen;
@class OMCSettingsBar;
@class OMCBinaryOperationBox;
@class OMCBinaryOperationPanel;

@class OMCCalWithBasicStyle;
@class OMCCalWithProgrammerStyle;

// OMFPanelBackgroundView class
@interface OMFPanelBackgroundView : NSView
    {
@private
    CGFloat _arrowX;
    }

@property ( nonatomic, assign ) OMCCalType _currentCalType;
@property ( nonatomic, assign ) IBOutlet OMCLCDScreen* _LCDScreen;
@property ( nonatomic, assign ) IBOutlet OMCSettingsBar* _settingsBar;
@property ( nonatomic, assign ) IBOutlet OMCBinaryOperationBox* _binaryOperationBox;
    @property ( nonatomic, assign ) IBOutlet OMCBinaryOperationPanel* _binaryOperationPanel;

@property ( nonatomic, assign ) IBOutlet OMCCalWithBasicStyle* _calWithBasicStyle;
@property ( nonatomic, assign ) IBOutlet OMCCalWithProgrammerStyle* _calWithProgrammerStyle;

@property ( nonatomic, assign ) CGFloat arrowX;

@end // OMFPanelBackgroundView

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