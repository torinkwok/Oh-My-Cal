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

#import "OMCProgrammerStyleCalculation.h"
#import "OMCOperand.h"
#import "OMCBinaryOperationPanel.h"

enum { k0xA = 10, k0xB = 11, k0xC = 12, k0xD = 13, k0xE = 14, k0xF = 15, k0xFF = 255 };

// OMCUnsignedIntegerCalculation class
@implementation OMCProgrammerStyleCalculation

- ( void ) awakeFromNib
    {
    [ super awakeFromNib ];

    [ self.lhsOperand setCalStyle: OMCProgrammerStyle ];
    [ self.rhsOperand setCalStyle: OMCProgrammerStyle ];
    [ self.resultValue setCalStyle: OMCProgrammerStyle ];
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
        NSUInteger baseNumber = operandWillBeDeleted.baseNumber.unsignedIntegerValue;

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
        self.typingState = OMCWaitRhsOperand;   // Wait for the user to pressing next button
        }
    else if ( self.typingState == OMCFinishedTyping )
        {
        [ self.lhsOperand setBaseNumber: @0 ];
        [ self.rhsOperand setBaseNumber: @0 ];
        [ self.resultValue setBaseNumber: @0 ];

        [ self.theOperator clear ];

        [ self.lhsOperand appendDigit: numberWillBeAppended count: appendCount ary: self.currentAry ];
        self.typingState = OMCWaitAllOperands;  // Wait for the user to pressing next button
        }
    }

- ( void ) appendUnitaryOperatorWithLastPressedButton: ( NSButton* )_Button
    {
    /* TODO: Should be fixed in v1.5 #If user has finished typing the left operand just a moment ago */
    [ self.theOperator clear ];
    [ self.theOperator appendString: [ [ _Button title ] uppercaseString ] ];
    }

- ( void ) appendBinaryOperatorWithLastPressedButton: ( NSButton* )_Button
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

- ( void ) calculateTheResultValueForMonomialWithLastPressedButton: ( NSButton* )_Button
    {
    [ self appendUnitaryOperatorWithLastPressedButton: _Button ];

    if ( [ self.theOperator isEqualToString: @"!" ] )
        {
        if ( self.typingState == OMCWaitAllOperands )
            [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: factorial( self.lhsOperand.baseNumber.unsignedIntegerValue ) ] ];
        else if ( self.typingState == OMCFinishedTyping )
            [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: factorial( self.resultValue.baseNumber.unsignedIntegerValue ) ] ];
        }
    else if ( [ self.theOperator isEqualToString: @"ROL" ] )
        {
        if ( self.typingState == OMCWaitAllOperands )
            [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: self.lhsOperand.baseNumber.unsignedIntegerValue << 1 ] ];
        else if ( self.typingState == OMCFinishedTyping )
            [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: self.resultValue.baseNumber.unsignedIntegerValue << 1 ] ];
        }
    else if ( [ self.theOperator isEqualToString: @"ROR" ] )
        {
        if ( self.typingState == OMCWaitAllOperands )
            [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: self.lhsOperand.baseNumber.unsignedIntegerValue >> 1 ] ];
        else if ( self.typingState == OMCFinishedTyping )
            [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: self.resultValue.baseNumber.unsignedIntegerValue >> 1 ] ];
        }
    else if ( [ self.theOperator isEqualToString: @"2'S" ]
            || [ self.theOperator isEqualToString: @"1'S" ] )
        {
        if ( self.typingState == OMCWaitAllOperands )
            [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: ~self.lhsOperand.baseNumber.unsignedIntegerValue ] ];
        else if ( self.typingState == OMCFinishedTyping )
            [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: ~self.resultValue.baseNumber.unsignedIntegerValue ] ];
        }

    self.typingState = OMCFinishedTyping;
    }

- ( void ) calculateTheResultValueForBinomialWithLastPressedButton: ( NSButton* )_Button
    {
    if ( self.typingState == OMCFinishedTyping /* If the user has finished a calculation... */
            || self.typingState == OMCWaitAllOperands /* or if the user is typing hte left operand... */  )
        {
        // Reset the LCD to a inital state
        if ( self.resultValue.baseNumber.unsignedIntegerValue > 0
                || self.lhsOperand.baseNumber.unsignedIntegerValue > 0
                || self.rhsOperand.baseNumber.unsignedIntegerValue > 0
                || self.theOperator.length > 0 )
            [ self clearAllAndReset ];

        return;
        }

    /* If the user has not finished a calculation, 
     * for example, they have finished typing the right operand,
     * and they want to calculate a result value... */
    if ( [ self.theOperator isEqualToString: @"+" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: self.lhsOperand.baseNumber.unsignedIntegerValue + self.rhsOperand.baseNumber.unsignedIntegerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"-" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: self.lhsOperand.baseNumber.unsignedIntegerValue - self.rhsOperand.baseNumber.unsignedIntegerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"×" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: self.lhsOperand.baseNumber.unsignedIntegerValue * self.rhsOperand.baseNumber.unsignedIntegerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"÷" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: self.lhsOperand.baseNumber.unsignedIntegerValue / self.rhsOperand.baseNumber.unsignedIntegerValue ] ];

    else if ( [ self.theOperator isEqualToString: @"AND" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: self.lhsOperand.baseNumber.unsignedIntegerValue & self.rhsOperand.baseNumber.unsignedIntegerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"OR" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: self.lhsOperand.baseNumber.unsignedIntegerValue | self.rhsOperand.baseNumber.unsignedIntegerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"NOR" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: ~( self.lhsOperand.baseNumber.unsignedIntegerValue | self.rhsOperand.baseNumber.unsignedIntegerValue ) ] ];
    else if ( [ self.theOperator isEqualToString: @"XOR" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: self.lhsOperand.baseNumber.unsignedIntegerValue ^ self.rhsOperand.baseNumber.unsignedIntegerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"LSH" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: self.lhsOperand.baseNumber.unsignedIntegerValue << self.rhsOperand.baseNumber.unsignedIntegerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"RSH" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: self.lhsOperand.baseNumber.unsignedIntegerValue >> self.rhsOperand.baseNumber.unsignedIntegerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"MOD" ] )
        [ self.resultValue setBaseNumber: [ NSNumber numberWithUnsignedInteger: self.lhsOperand.baseNumber.unsignedIntegerValue % self.rhsOperand.baseNumber.unsignedIntegerValue ] ];

    self.typingState = OMCFinishedTyping;
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
    case OMCDoubleZero:

    case OMC0xA:    case OMC0xB:    case OMC0xC:
    case OMC0xD:    case OMC0xE:    case OMC0xF:
    case OMC0xFF:
        [ self appendNumberWithLastPressedButton: self.lastTypedButton ];
        return;

    // Binary operators
    case OMCAnd:    case OMCOr:     case OMCNor:
    case OMCXor:    case OMCLsh:    case OMCRsh:
    case OMCMod:
        [ self appendBinaryOperatorWithLastPressedButton: self.lastTypedButton ];
        return;

    case OMCRoL:    case OMCRoR:    case OMCFactorial:
    case OMC2_s:    case OMC1_s:
        [ self calculateTheResultValueForMonomialWithLastPressedButton: self.lastTypedButton ];
        return;
        }

    [ super calculate: _Sender ];
    }

#pragma mark Calculations
NSUInteger factorial( NSUInteger _X )
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

@end // OMCUnsignedIntegerCalculation

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