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
@interface OMCCalculation : NSObject
    {
@private
    OMCTypingState _typingState;
    OMCAry _currentAry;
    OMCButtonType _lastTypedButtonType;
    NSButton* _lastTypedButton;

    NSMutableString* _lhsOperand;
    NSMutableString* _rhsOperand;
    NSMutableString* _theOperator;
    NSMutableString* _resultValue;
    }

@property ( nonatomic, assign ) OMCTypingState typingState;
@property ( nonatomic, assign ) OMCAry currentAry;
@property ( nonatomic, assign ) OMCButtonType lastTypedButtonType;
@property ( nonatomic, retain ) NSButton* lastTypedButton;

@property ( nonatomic, retain ) NSMutableString* lhsOperand;
@property ( nonatomic, retain ) NSMutableString* rhsOperand;
@property ( nonatomic, retain ) NSMutableString* theOperator;
@property ( nonatomic, retain ) NSMutableString* resultValue;

- ( IBAction ) calculate: ( id )_Sender;
- ( IBAction ) aryChanged: ( id )_Sender;

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