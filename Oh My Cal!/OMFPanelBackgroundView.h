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

@class OMCCalWithBasicStyle;
@class OMCCalWithScientificStyle;
@class OMCCalWithProgrammerStyle;

// OMFPanelBackgroundView class
@interface OMFPanelBackgroundView : NSView
    {
@private
    CGFloat _arrowX;
    }

@property ( nonatomic, assign ) IBOutlet OMFMainPanelController* _mainPanelController;

@property ( nonatomic, assign ) OMCCalStyle _currentCalStyle;
@property ( nonatomic, assign ) IBOutlet OMCLCDScreen* _LCDScreen;
@property ( nonatomic, assign ) IBOutlet OMCSettingsBar* _settingsBar;
@property ( nonatomic, assign ) IBOutlet OMCBinaryOperationBox* _binaryOperationBox;
    @property ( nonatomic, assign ) IBOutlet OMCBinaryOperationPanel* _binaryOperationPanel;

@property ( nonatomic, assign, readonly ) OMCCalculation* currentCalculation;

@property ( nonatomic, assign ) IBOutlet OMCCalWithBasicStyle* _calWithBasicStyle;
@property ( nonatomic, assign ) IBOutlet OMCCalWithScientificStyle* _calWithScientificStyle;
@property ( nonatomic, assign ) IBOutlet OMCCalWithProgrammerStyle* _calWithProgrammerStyle;

@property ( nonatomic, assign ) IBOutlet NSMenuItem* _basicStyleMenuItem;
@property ( nonatomic, assign ) IBOutlet NSMenuItem* _scientificStyleMenuItem;
@property ( nonatomic, assign ) IBOutlet NSMenuItem* _programmertyleMenuItem;

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