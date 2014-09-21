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

#import "OMCCalculation.h"
#import "OMCBasicStyleCalculation.h"
#import "OMCScientificStyleCalculation.h"
#import "OMCProgrammerStyleCalculation.h"

#import "OMCOperand.h"
#import "OMCBinaryOperationPanel.h"

// Notifications
NSString* const OMCCurrentTypingStateDidChangedNotification = @"OMCCurrentTypingStateDidChangedNotification";
NSString* const OMCCurrentAryDidChangedNotification = @"OMCCurrentAryDidChangedNotification";
NSString* const OMCCurrentLeftOperandDidChangedNotification = @"OMCCurrentLeftOperandDidChangedNotification";
NSString* const OMCCurrentRightOperandDidChangedNotification = @"OMCCurrentRightOperandDidChangedNotification";
NSString* const OMCCurrentResultValueDidChangedNotification = @"OMCCurrentResultValueDidChangedNotification";

// Keys for User Info in notifications
NSString* const OMCCurrentTypingState = @"OMCCurrentTypingState";
NSString* const OMCCurrentAry = @"OMCCurrentAry";
NSString* const OMCLastTypedButton = @"OMCLastTypedButton";

// OMCCalculation class
@implementation OMCCalculation

@synthesize _binaryOperationPanel;

@synthesize typingState = _typingState;

@synthesize currentAry = _currentAry;
@synthesize calStyle = _calStyle;

@synthesize lhsOperand = _lhsOperand;
@synthesize rhsOperand = _rhsOperand;
@synthesize resultValue = _resultValue;

@synthesize theOperator = _theOperator;

@synthesize lastTypedButtonType = _lastTypedButtonType;
@synthesize lastTypedButton = _lastTypedButton;

#pragma mark Initializers & Deallocators
- ( void ) awakeFromNib
    {
    [ self _initializeOprands ];

    [ self setTypingState: OMCWaitAllOperands ];
    [ self setCurrentAry: ( OMCAry )[ USER_DEFAULTS integerForKey: OMCDefaultsKeyAry ] ];

    if ( [ self class ] == [ OMCBasicStyleCalculation class ] )
        self.calStyle = OMCBasicStyle;
    else if ( [ self class ] == [ OMCScientificStyleCalculation class ] )
        self.calStyle = OMCScientificStyle;
    else if ( [ self class ] == [ OMCProgrammerStyleCalculation class ] )
        self.calStyle = OMCProgrammerStyle;

    [ NOTIFICATION_CENTER addObserver: self
                             selector: @selector( binaryStringDidChanged: )
                                 name: OMCBinaryStringDidChanged
                               object: self._binaryOperationPanel ];
    }

- ( void ) binaryStringDidChanged: ( NSNotification* )_Notif
    {
    NSUInteger newDecimal = [ self convertBinaryToDecimal: self._binaryOperationPanel.binaryInString ];

    if ( self.typingState == OMCWaitAllOperands )
        {
        self.lhsOperand = [ OMCOperand operandWithUnsignedInteger: newDecimal inAry: self.currentAry calStyle: self.calStyle ];
        self.typingState = OMCWaitAllOperands;
        }
    else if ( self.typingState == OMCWaitRhsOperand )
        {
        self.rhsOperand = [ OMCOperand operandWithUnsignedInteger: newDecimal inAry: self.currentAry calStyle: self.calStyle ];
        self.typingState = OMCWaitRhsOperand;
        }
    else if ( self.typingState == OMCFinishedTyping )
        {
        [ self zeroedAllOperands ];

        self.lhsOperand = [ OMCOperand operandWithUnsignedInteger: newDecimal inAry: self.currentAry calStyle: self.calStyle ];
        self.typingState = OMCWaitAllOperands;
        }
    }

- ( void ) _initializeOprands
    {
    if ( !self.lhsOperand )
        self.lhsOperand = [ OMCOperand zero ];

    if ( !self.rhsOperand )
        self.rhsOperand = [ OMCOperand zero ];

    if ( !self.resultValue )
        self.resultValue = [ OMCOperand zero ];

    if ( !self.theOperator )
        self.theOperator = [ NSMutableString string ];
    }

- ( void ) deleteNumberWithLastPressedButton: ( NSButton* )_Button
    {
    OMCOperand* operandWillBeDeleted = nil;

    if ( self.typingState == OMCWaitAllOperands )
        operandWillBeDeleted = self.lhsOperand;
    else if ( self.typingState == OMCWaitRhsOperand )
        operandWillBeDeleted = self.rhsOperand;
    else if ( self.typingState == OMCFinishedTyping )
        {
        NSBeep();
        return;
        }

    if ( operandWillBeDeleted.isZero )
        NSBeep();
    else
        {
        NSUInteger baseNumber = operandWillBeDeleted.decimalNumber.unsignedIntegerValue;

        [ operandWillBeDeleted deleteDigit: baseNumber % 10 count: 1 ary: self.currentAry ];

        if ( self.typingState == OMCWaitAllOperands )
            self.typingState = OMCWaitAllOperands;
        else if ( self.typingState == OMCWaitRhsOperand )
            self.typingState = OMCWaitRhsOperand;
        }
    }

- ( void ) appendNumberWithLastPressedButton: ( NSButton* )_Button
    {
    NSString* buttonTitle = [ _Button title ];
    NSInteger numberWillBeAppended = numberWillBeAppended = [ buttonTitle integerValue ];

    BOOL isWaitingForFloatNumber = [ buttonTitle isEqualToString: @"." ];
    if ( isWaitingForFloatNumber )
        numberWillBeAppended = -1;

    NSInteger appendCount = 1;  // appendCount in basicStyleCalculation is always 1

    // If Oh My Cal! is in the initial state or user is just typing the left operand
    if ( self.typingState == OMCWaitAllOperands )
        {
        [ self.lhsOperand appendDigit: numberWillBeAppended count: appendCount ary: self.currentAry ];
        self.typingState = OMCWaitAllOperands;
        }
    else if ( self.typingState == OMCWaitRhsOperand )
        {
        [ self.rhsOperand appendDigit: numberWillBeAppended count: appendCount ary: self.currentAry ];
        self.typingState = OMCWaitRhsOperand;   // Wait for the user to pressing next button
        }
    else if ( self.typingState == OMCFinishedTyping )
        {
        // REF#1
        [ self zeroedAllOperands ];
//        [ self.lhsOperand setBaseNumber: @.0f ];
//        [ self.rhsOperand setBaseNumber: @.0f ];
//        [ self.resultValue setBaseNumber: @.0f ];

//        [ self.theOperator clear ];

        [ self.lhsOperand appendDigit: numberWillBeAppended count: appendCount ary: self.currentAry ];
        self.typingState = OMCWaitAllOperands;  // Wait for the user to pressing next button
        }
    }

- ( void ) appendUnitaryOperatorWithLastPressedButton: ( NSButton* )_Button
    {
    __THROW_EXCEPTION__WHEN_INVOKED_PURE_VIRTUAL_METHOD__;
    }

- ( void ) appendBinaryOperatorWithLastPressedButton: ( NSButton* )_Button
    {
    __THROW_EXCEPTION__WHEN_INVOKED_PURE_VIRTUAL_METHOD__;
    }

- ( void ) calculateTheResultValueForMonomialWithLastPressedButton: ( NSButton* )_Button
    {
    __THROW_EXCEPTION__WHEN_INVOKED_PURE_VIRTUAL_METHOD__;
    }

- ( void ) calculateTheResultValueForBinomialWithLastPressedButton: ( NSButton* )_Button
    {
    __THROW_EXCEPTION__WHEN_INVOKED_PURE_VIRTUAL_METHOD__;
    }

#pragma mark IBActions
// All of the buttons on the keyboard has been connected to this action
- ( IBAction ) calculate: ( id )_Sender
    {
    NSButton* pressedButton = ( NSButton* )_Sender;
    self.lastTypedButtonType = ( OMCProgrammerStyleButtonType )[ pressedButton tag ];
    self.lastTypedButton = _Sender;

    switch ( self.lastTypedButtonType )
        {
    // Numbers
    case OMCOne:    case OMCTwo:    case OMCThree:
    case OMCFour:   case OMCFive:   case OMCSix:
    case OMCSeven:  case OMCEight:  case OMCNine:
    case OMCZero:
    case OMCFloatPoint:
        [ self appendNumberWithLastPressedButton: self.lastTypedButton ];
        return;

    // Binary operators
    case OMCAdd:        case OMCSub:
    case OMCMuliply:    case OMCDivide:
        [ self appendBinaryOperatorWithLastPressedButton: self.lastTypedButton ];
        return;

    // Commands
    case OMCDel:    [ self deleteNumberWithLastPressedButton: self.lastTypedButton ];
        return;

    case OMCClear:  [ self clearCurrentOperand ];   return;
    case OMCAC:     [ self clearAllAndReset ];      return;

    case OMCLeftParenthesis:  return;
    case OMCRightParenthesis: return;

    case OMCEnter:
        [ self calculateTheResultValueForBinomialWithLastPressedButton: self.lastTypedButton ];
        return;
        }
    }

- ( void ) clearAllAndReset
    {
    [ self zeroedAllOperands ];

    self.typingState = OMCWaitAllOperands;
    }

- ( void ) clearCurrentOperand
    {
    if ( self.typingState == OMCWaitAllOperands )
        {
        [ self.lhsOperand zeroed ];
        self.typingState = OMCWaitAllOperands;
        }
    else if ( self.typingState == OMCWaitRhsOperand )
        {
        [ self.rhsOperand zeroed ];
        self.typingState = OMCWaitRhsOperand;
        }
    else if ( self.typingState == OMCFinishedTyping )
        {
        [ self clearAllAndReset ];
        self.typingState = OMCWaitAllOperands;
        }
    }

#pragma mark Accessors
- ( void ) setTypingState: ( OMCTypingState )_TypingState
    {
    if ( self->_typingState != _TypingState )
        self->_typingState = _TypingState;

    [ NOTIFICATION_CENTER postNotificationName: OMCCurrentTypingStateDidChangedNotification
                                        object: self
                                      userInfo: nil ];
    }

- ( void ) zeroedAllOperands
    {
    [ self.lhsOperand zeroed ];
    [ self.rhsOperand zeroed ];
    [ self.resultValue zeroed ];

    [ self.theOperator clear ];
    }

- ( void ) setCurrentAry: ( OMCAry )_Ary
    {
    if ( self->_currentAry != _Ary )
        {
        self->_currentAry = _Ary;

        [ self.lhsOperand setCurrentAry: self->_currentAry ];
        [ self.rhsOperand setCurrentAry: self->_currentAry ];
        [ self.resultValue setCurrentAry: self->_currentAry ];
        }

    [ NOTIFICATION_CENTER postNotificationName: OMCCurrentAryDidChangedNotification
                                        object: self
                                      userInfo: nil ];
    }

#pragma mark Conforms <OMCBinaryAndDecimalConversion> protocol
- ( NSUInteger ) convertBinaryToDecimal: ( NSString* )_Binary
    {
    NSUInteger decimal = 0U;

    double exponent = 0.f;
    for ( int index = BIT_COUNT - 1; index >= 0; index-- )
        {
        /* For example:
         * We want to retrieve the decimal form of '0100 1011', we can...
         *
         * 1 * 2^0 = 1
         * 1 * 2^1 = 2
         * 0 * 2^2 = 0
         * 1 * 2^3 = 8
         * 0 * 2^4 = 0
         * 0 * 2^5 = 0
         * 1 * 2^6 = 64
         *
         * 64 + 8 + 2 + 1 = 75
         * so the decimal form of '0100 1011' is 75
         */
        NSInteger bit = [ _Binary substringWithRange: NSMakeRange( index, 1 ) ].integerValue;

        decimal += bit * pow( 2, exponent++ );
        }

    return decimal;
    }

@end // OMCCalculation

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