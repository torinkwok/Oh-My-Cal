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

@class OMCCalculation;

@class OMFMainPanelController;
@class OMCLCDScreen;
@class OMCSettingsBar;
@class OMCBinaryOperationBox;
@class OMCBinaryOperationPanel;

@class OMCCal;
@class OMCCalWithBasicStyle;
@class OMCCalWithScientificStyle;
@class OMCCalWithProgrammerStyle;

// OMFPanelBackgroundView class
@interface OMFPanelBackgroundView : NSView
    {
@private
    CGFloat _arrowX;
    }

@property ( nonatomic, unsafe_unretained ) IBOutlet OMFMainPanelController* _mainPanelController;

@property ( nonatomic, assign ) OMCCalStyle _currentCalStyle;
@property ( nonatomic, unsafe_unretained ) IBOutlet OMCLCDScreen* _LCDScreen;
@property ( nonatomic, unsafe_unretained ) IBOutlet OMCSettingsBar* _settingsBar;
@property ( nonatomic, unsafe_unretained ) IBOutlet OMCBinaryOperationBox* _binaryOperationBox;
    @property ( nonatomic, unsafe_unretained ) IBOutlet OMCBinaryOperationPanel* _binaryOperationPanel;

@property ( nonatomic, unsafe_unretained, readonly ) OMCCalculation* currentCalculation;

@property ( nonatomic, unsafe_unretained ) IBOutlet OMCCalWithBasicStyle* _calWithBasicStyle;
@property ( nonatomic, unsafe_unretained ) IBOutlet OMCCalWithScientificStyle* _calWithScientificStyle;
@property ( nonatomic, unsafe_unretained ) IBOutlet OMCCalWithProgrammerStyle* _calWithProgrammerStyle;

@property ( nonatomic, unsafe_unretained, readonly ) OMCCal* currentCalculator;

@property ( nonatomic, unsafe_unretained ) IBOutlet NSMenuItem* _basicStyleMenuItem;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSMenuItem* _scientificStyleMenuItem;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSMenuItem* _programmertyleMenuItem;

@property ( nonatomic, assign ) CGFloat arrowX;

#pragma mark IBActions
- ( IBAction ) calStyleChanged: ( id )_Sender;

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