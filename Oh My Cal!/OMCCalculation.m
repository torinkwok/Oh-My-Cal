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
#import "OMCOperand.h"
#import "OMCBinaryOperationPanel.h"

enum { k0xA = 10, k0xB = 11, k0xC = 12, k0xD = 13, k0xE = 14, k0xF = 15, k0xFF = 255 };

NSString static* const kKeyPathBinaryStringInBinaryOperationPanel = @"self.binaryInString";

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

@synthesize lhsOperand = _lhsOperand;
@synthesize rhsOperand = _rhsOperand;
@synthesize resultValue = _resultValue;

@synthesize theOperator = _theOperator;

@synthesize lastTypedButtonType = _lastTypedButtonType;
@synthesize lastTypedButton = _lastTypedButton;

#pragma mark Initializers & Deallocators
- ( void ) awakeFromNib
    {
    [ self setTypingState: OMCWaitAllOperands ];
    [ self setCurrentAry: ( OMCAry )[ USER_DEFAULTS integerForKey: OMCDefaultsKeyAry ] ];

    [ self _initializeOprands ];

    [ _binaryOperationPanel addObserver: self
                             forKeyPath: kKeyPathBinaryStringInBinaryOperationPanel
                                options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                context: NULL ];
    }

- ( void ) observeValueForKeyPath: ( NSString* )_KeyPath
                         ofObject: ( id )_Object
                           change: ( NSDictionary* )_Change
                          context: ( void* )_Context
    {
    if ( [ _KeyPath isEqualToString: kKeyPathBinaryStringInBinaryOperationPanel ] )
        {
//        NSLog( @"%lu", [ self convertBinaryToDecimal: _Change[ @"new" ] ] );
        self.resultValue.baseNumber = [ NSNumber numberWithInteger: [ self convertBinaryToDecimal: _Change[ @"new" ] ] ];
        }
    }

- ( void ) _initializeOprands
    {
    if ( !self.lhsOperand )
        self.lhsOperand = [ OMCOperand operandWithNumber: @0 ];

    if ( !self.rhsOperand )
        self.rhsOperand = [ OMCOperand operandWithNumber: @0 ];

    if ( !self.resultValue )
        self.resultValue = [ OMCOperand operandWithNumber: @0 ];

    if ( !self.theOperator )
        self.theOperator = [ NSMutableString string ];
    }

#pragma mark IBActions

- ( void ) _deleteNumberWithLastPressedButton: ( NSButton* )_Button
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
        NSInteger baseNumber = operandWillBeDeleted.baseNumber.integerValue;

        [ operandWillBeDeleted deleteDigit: baseNumber % 10 count: 1 ary: self.currentAry ];

        if ( self.typingState == OMCWaitAllOperands )
            self.typingState = OMCWaitAllOperands;
        else if ( self.typingState == OMCWaitRhsOperand )
            self.typingState = OMCWaitRhsOperand;
        }
    }

- ( void ) _appendNumberWithLastPressedButton: ( NSButton* )_Button
    {
    NSString* buttonTitle = [ _Button title ];
    NSInteger numberWillBeAppended = numberWillBeAppended = [ buttonTitle integerValue ];

    if ( self.currentAry == OMCHex )
        {
        if ( [ buttonTitle isEqualToString: @"A" ] )    numberWillBeAppended = k0xA;
        if ( [ buttonTitle isEqualToString: @"B" ] )    numberWillBeAppended = k0xB;
        if ( [ buttonTitle isEqualToString: @"C" ] )    numberWillBeAppended = k0xC;
        if ( [ buttonTitle isEqualToString: @"D" ] )    numberWillBeAppended = k0xD;
        if ( [ buttonTitle isEqualToString: @"E" ] )    numberWillBeAppended = k0xE;
        if ( [ buttonTitle isEqualToString: @"F" ] )    numberWillBeAppended = k0xF;
        if ( [ buttonTitle isEqualToString: @"FF" ] )   numberWillBeAppended = k0xFF;
        }

    NSInteger appendCount = 0;
    if ( [ buttonTitle isEqualToString: @"00" ] || [ buttonTitle isEqualToString: @"FF" ] )
        appendCount = 2;
    else
        appendCount = 1;

    // If Oh My Cal! is in the initial state or user is just typing the left operand
    if ( self.typingState == OMCWaitAllOperands )
        {
        [ self.lhsOperand appendDigit: numberWillBeAppended count: appendCount ary: self.currentAry ];
        self.typingState = OMCWaitAllOperands;  // Wait for the user to pressing next button
        }
    else if ( self.typingState == OMCWaitRhsOperand )
        {
        [ self.rhsOperand appendDigit: numberWillBeAppended count: appendCount ary: self.currentAry ];
        self.typingState = OMCWaitRhsOperand;
        }
    else if ( self.typingState == OMCFinishedTyping )
        {
        [ self.lhsOperand setBaseNumber: @0 ];
        [ self.rhsOperand setBaseNumber: @0 ];
        [ self.resultValue setBaseNumber: @0 ];

        [ self.theOperator clear ];

        [ self.lhsOperand appendDigit: numberWillBeAppended count: appendCount ary: self.currentAry ];
        self.typingState = OMCWaitAllOperands;
        }
    }

- ( void ) _appendUnitaryOperatorWithLastPressedButton: ( NSButton* )_Button
    {
    /* If user has finished typing the left operand just a moment ago */
    [ self.theOperator clear ];
    [ self.theOperator appendString: [ [ _Button title ] uppercaseString ] ];
    }

- ( void ) _appendBinaryOperatorWithLastPressedButton: ( NSButton* )_Button
    {
    /* If user has finished typing the left operand just a moment ago */
    if ( self.typingState == OMCWaitAllOperands )
        {
        [ self.theOperator appendString: [ [ _Button title ] uppercaseString ] ];
        self.typingState = OMCWaitRhsOperand;
        }
    else if ( self.typingState == OMCFinishedTyping )
        {
        [ self.theOperator clear ];
        [ self.lhsOperand setBaseNumber: @0 ];
        [ self.rhsOperand setBaseNumber: @0 ];

        [ self.lhsOperand setBaseNumber: self.resultValue.baseNumber ];
        [ self.resultValue setBaseNumber: @0 ];
        [ self.theOperator appendString: [ [ _Button title ] uppercaseString ] ];

        self.typingState = OMCWaitRhsOperand;
        }
    }

- ( void ) _calculateTheResultValueForMonomialWithLastPressedButton: ( NSButton* )_Button
    {
    [ self _appendUnitaryOperatorWithLastPressedButton: _Button ];

    if ( [ self.theOperator isEqualToString: @"!" ] )
        {
        if ( self.typingState == OMCWaitAllOperands )
            [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: factorial( self.lhsOperand.baseNumber.integerValue ) ] ];
        else if ( self.typingState == OMCFinishedTyping )
            [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: factorial( self.resultValue.baseNumber.integerValue ) ] ];
        }
    else if ( [ self.theOperator isEqualToString: @"ROL" ] )
        {
        if ( self.typingState == OMCWaitAllOperands )
            [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: self.lhsOperand.baseNumber.integerValue << 1 ] ];
        else if ( self.typingState == OMCFinishedTyping )
            [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: self.resultValue.baseNumber.integerValue << 1 ] ];
        }
    else if ( [ self.theOperator isEqualToString: @"ROR" ] )
        {
        if ( self.typingState == OMCWaitAllOperands )
            [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: self.lhsOperand.baseNumber.integerValue >> 1 ] ];
        else if ( self.typingState == OMCFinishedTyping )
            [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: self.resultValue.baseNumber.integerValue >> 1 ] ];
        }
    else if ( [ self.theOperator isEqualToString: @"2'S" ]
            || [ self.theOperator isEqualToString: @"1'S" ] )
        {
        if ( self.typingState == OMCWaitAllOperands )
            [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: ~self.lhsOperand.baseNumber.integerValue ] ];
        else if ( self.typingState == OMCFinishedTyping )
            [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: ~self.resultValue.baseNumber.integerValue ] ];
        }
    else if ( [ self.theOperator isEqualToString: @"ROR" ] )
        {
        if ( self.typingState == OMCWaitAllOperands )
            [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: self.lhsOperand.baseNumber.integerValue >> 1 ] ];
        else if ( self.typingState == OMCFinishedTyping )
            [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: self.resultValue.baseNumber.integerValue >> 1 ] ];
        }

    self.typingState = OMCFinishedTyping;
    }

- ( void ) _calculateTheResultValueForBinomialWithLastPressedButton: ( NSButton* )_Button
    {
    if ( self.typingState == OMCFinishedTyping /* If the user has finished a calculation... */
            || self.typingState == OMCWaitAllOperands /* or if the user is typing hte left operand... */  )
        {
        // Reset the LCD to a inital state
        if ( self.resultValue.baseNumber.integerValue > 0
                || self.lhsOperand.baseNumber.integerValue > 0
                || self.rhsOperand.baseNumber.integerValue > 0
                || self.theOperator.length > 0 )
            [ self clearAllAndReset ];

        return;
        }

    /* If the user has not finished a calculation, 
     * for example, they have finished typing the right operand,
     * and they want to calculate a result value... */
    if ( [ self.theOperator isEqualToString: @"+" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: self.lhsOperand.baseNumber.integerValue + self.rhsOperand.baseNumber.integerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"-" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: self.lhsOperand.baseNumber.integerValue - self.rhsOperand.baseNumber.integerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"×" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: self.lhsOperand.baseNumber.integerValue * self.rhsOperand.baseNumber.integerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"÷" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: self.lhsOperand.baseNumber.integerValue / self.rhsOperand.baseNumber.integerValue ] ];

    else if ( [ self.theOperator isEqualToString: @"AND" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: self.lhsOperand.baseNumber.integerValue & self.rhsOperand.baseNumber.integerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"OR" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: self.lhsOperand.baseNumber.integerValue | self.rhsOperand.baseNumber.integerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"NOR" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: ~( self.lhsOperand.baseNumber.integerValue | self.rhsOperand.baseNumber.integerValue ) ] ];
    else if ( [ self.theOperator isEqualToString: @"XOR" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: self.lhsOperand.baseNumber.integerValue ^ self.rhsOperand.baseNumber.integerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"LSH" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: self.lhsOperand.baseNumber.integerValue << self.rhsOperand.baseNumber.integerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"RSH" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: self.lhsOperand.baseNumber.integerValue >> self.rhsOperand.baseNumber.integerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"MOD" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithInteger: self.lhsOperand.baseNumber.integerValue % self.rhsOperand.baseNumber.integerValue ] ];

    self.typingState = OMCFinishedTyping;
    }

// All of the buttons on the keyboard has been connected to this action
- ( IBAction ) calculate: ( id )_Sender
    {
    NSButton* pressedButton = _Sender;
    self.lastTypedButtonType = ( OMCButtonType )[ pressedButton tag ];
    self.lastTypedButton = _Sender;

    switch ( self.lastTypedButtonType )
        {
    // Numbers
    case OMCOne:
    case OMCTwo:
    case OMCThree:
    case OMCFour:
    case OMCFive:
    case OMCSix:
    case OMCSeven:
    case OMCEight:
    case OMCNine:
    case OMCZero:
    case OMCDoubleZero:

    case OMC0xA:
    case OMC0xB:
    case OMC0xC:
    case OMC0xD:
    case OMC0xE:
    case OMC0xF:
    case OMC0xFF:
        [ self _appendNumberWithLastPressedButton: self.lastTypedButton ];
        break;

    // Binary operators
    case OMCAnd:
    case OMCOr:
    case OMCNor:
    case OMCXor:
    case OMCLsh:
    case OMCRsh:

    case OMCMod:
    case OMCAdd:
    case OMCSub:
    case OMCMuliply:
    case OMCDivide:
        [ self _appendBinaryOperatorWithLastPressedButton: self.lastTypedButton ];
        break;

    case OMCRoL:
    case OMCRoR:
    case OMCFactorial:
    case OMC2_s:
    case OMC1_s:
        [ self _calculateTheResultValueForMonomialWithLastPressedButton: self.lastTypedButton ];
        break;

    case OMCDel:    [ self _deleteNumberWithLastPressedButton: self.lastTypedButton ];
        break;

    case OMCClear:
    case OMCAC:     [ self clearAllAndReset ];  break;  // TODO:

    case OMCLeftParenthesis:  break;
    case OMCRightParenthesis: break;

    case OMCEnter:
        [ self _calculateTheResultValueForBinomialWithLastPressedButton: self.lastTypedButton ];
        break;
        }
    }

- ( void ) clearAllAndReset
    {
    // Because of clearing and resetting, all thing should be zero
    [ self.resultValue setBaseNumber: @0 ];
    [ self.lhsOperand setBaseNumber: @0 ];
    [ self.rhsOperand setBaseNumber: @0 ];
    [ self.theOperator clear ];

    self.typingState = OMCWaitAllOperands;
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

- ( void ) setCurrentAry: ( OMCAry )_Ary
    {
    if ( self->_currentAry != _Ary )
        self->_currentAry = _Ary;

    [ NOTIFICATION_CENTER postNotificationName: OMCCurrentAryDidChangedNotification
                                        object: self
                                      userInfo: nil ];
    }

#pragma mark Calculations
NSInteger factorial( NSInteger _X )
    {
    if ( _X <= 1 )
        return 1;
    else
        return _X * factorial( _X - 1 );
    }

CGFloat factorialF( CGFloat _X )
    {
    if ( _X <= 1.f )
        return 1.f;
    else
        return _X * factorialF( _X - 1.f );
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