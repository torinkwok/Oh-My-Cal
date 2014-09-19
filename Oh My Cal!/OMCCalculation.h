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
    OMCAry _currentAry;
    OMCProgrammerStyleButtonType _lastTypedButtonType;
    NSButton* _lastTypedButton;

    OMCOperand* _lhsOperand;
    OMCOperand* _rhsOperand;
    OMCOperand* _resultValue;

    NSMutableString* _theOperator;
    }

@property ( nonatomic, assign ) IBOutlet OMCBinaryOperationPanel* _binaryOperationPanel;

@property ( nonatomic, assign ) OMCTypingState typingState;
@property ( nonatomic, assign ) OMCAry currentAry;
@property ( nonatomic, assign ) OMCProgrammerStyleButtonType lastTypedButtonType;
@property ( nonatomic, retain ) NSButton* lastTypedButton;

@property ( nonatomic, retain ) OMCOperand* lhsOperand;
@property ( nonatomic, retain ) OMCOperand* rhsOperand;
@property ( nonatomic, retain ) OMCOperand* resultValue;

@property ( nonatomic, retain ) NSMutableString* theOperator;

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