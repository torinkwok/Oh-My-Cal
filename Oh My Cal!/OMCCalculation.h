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
#import "OMCBinaryAndDecimalConversion.h"

// Notification UserInfo Keys
NSString extern* const OMCCalculationNewTypingState;
NSString extern* const OMCCalculationNewAry;

enum { k0xA = 10, k0xB = 11, k0xC = 12, k0xD = 13, k0xE = 14, k0xF = 15, k0xFF = 255 };

@class OMCOperand;
@class OMCBinaryOperationPanel;

// Notifications
NSString extern* const OMCCurrentTypingStateDidChangedNotification;
NSString extern* const OMCCurrentAryDidChangedNotification;
NSString extern* const OMCCurrentLeftOperandDidChangedNotification;
NSString extern* const OMCCurrentRightOperandDidChangedNotification;
NSString extern* const OMCCurrentResultValueDidChangedNotification;

// Keys for User Info in notifications
NSString extern* const OMCCurrentTypingState;
NSString extern* const OMCCurrentAry;
NSString extern* const OMCLastTypedButton;

// OMCCalculation class
@interface OMCCalculation : NSObject <OMCBinaryAndDecimalConversion>
    {
@private
    OMCTypingState _typingState;

    OMCAry                  _currentAry;
    OMCCalStyle             _calStyle;
    OMCTrigonometricMode    _trigonometricMode;
    BOOL                    _hasMemory;
    BOOL                    _isInShift;

    OMCProgrammerStyleButtonType _lastTypedButtonType;
    NSButton* _lastTypedButton;

    OMCOperand* _lhsOperand;
    OMCOperand* _rhsOperand;
    OMCOperand* _resultValue;

    OMCOperand* _memory;

    NSMutableString* _theOperator;
    }

@property ( nonatomic, assign ) IBOutlet OMCBinaryOperationPanel* _binaryOperationPanel;

@property ( nonatomic, assign ) OMCTypingState typingState;

@property ( nonatomic, assign ) OMCAry currentAry;
@property ( nonatomic, assign ) OMCCalStyle calStyle;
@property ( nonatomic, assign ) OMCTrigonometricMode trigonometricMode;
@property ( nonatomic, assign ) BOOL hasMemory;
@property ( nonatomic, assign ) BOOL isInShift;

@property ( nonatomic, assign ) OMCProgrammerStyleButtonType lastTypedButtonType;
@property ( nonatomic, retain ) NSButton* lastTypedButton;

@property ( nonatomic, retain ) OMCOperand* lhsOperand;
@property ( nonatomic, retain ) OMCOperand* rhsOperand;
@property ( nonatomic, retain ) OMCOperand* resultValue;

@property ( nonatomic, retain ) OMCOperand* memory;

@property ( nonatomic, retain ) NSMutableString* theOperator;

@property ( nonatomic, assign, readonly ) BOOL isBinomialInLastCalculation;

- ( IBAction ) calculate: ( id )_Sender;

- ( void ) zeroedAllOperands;

- ( void ) deleteNumberWithLastPressedButton: ( NSButton* )_Button;
- ( void ) appendNumberWithLastPressedButton: ( NSButton* )_Button;
- ( void ) appendUnitaryOperatorWithLastPressedButton: ( NSButton* )_Button;
- ( void ) appendBinaryOperatorWithLastPressedButton: ( NSButton* )_Button;
- ( void ) calculateTheResultValueForMonomialWithLastPressedButton: ( NSButton* )_Button;
- ( void ) calculateTheResultValueForBinomialWithLastPressedButton: ( NSButton* )_Button;

- ( void ) clearAllAndReset;
- ( void ) clearCurrentOperand;

@end // OMCCalculation class

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