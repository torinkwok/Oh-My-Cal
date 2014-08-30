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

// NSMutableString + OMCCalculation
@interface NSMutableString ( OMCCalculation )
- ( void ) clear;
@end

@implementation NSMutableString ( OMCCalculation )

- ( void ) clear
    {
    [ self deleteCharactersInRange: NSMakeRange( 0, [ self length ] ) ];
    }

@end // NSMutableString + OMCCalculation

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

@synthesize typingState = _typingState;
@synthesize currentAry = _currentAry;

@synthesize lhsOperand = _lhsOperand;
@synthesize rhsOperand = _rhsOperand;
@synthesize theOperator = _theOperator;
@synthesize resultValue = _resultValue;

@synthesize lastTypedButtonType = _lastTypedButtonType;
@synthesize lastTypedButton = _lastTypedButton;

#pragma mark Initializers & Deallocators
- ( void ) awakeFromNib
    {
    [ self setTypingState: OMCWaitAllOperands ];
    [ self setCurrentAry: ( OMCAry )[ USER_DEFAULTS integerForKey: OMCDefaultsKeyAry ] ];

    [ self _initializeOprands ];
    }

- ( void ) _initializeOprands
    {
    if ( !self.lhsOperand )
        self.lhsOperand = [ NSMutableString string ];

    if ( !self.rhsOperand )
        self.rhsOperand = [ NSMutableString string ];

    if ( !self.theOperator )
        self.theOperator = [ NSMutableString string ];

    if ( !self.resultValue )
        self.resultValue = [ NSMutableString string ];
    }

#pragma mark IBActions

- ( void ) _appendNumberWithLastPressedButton: ( NSButton* )_Button
    {
    // If Oh My Cal! is in the initial state or user is just typing the left operand
    if ( self.typingState == OMCWaitAllOperands )
        {
        [ self.lhsOperand appendString: [ _Button title ] ];
        self.typingState = OMCWaitAllOperands;  // Wait for the user to pressing next button
        }
    else if ( self.typingState == OMCWaitRhsOperand )
        {
        [ self.rhsOperand appendString: [ _Button title ] ];
        self.typingState = OMCWaitRhsOperand;
        }
    else if ( self.typingState == OMCFinishedTyping )
        {
        [ self.lhsOperand clear ];
        [ self.rhsOperand clear ];
        [ self.theOperator clear ];
        [ self.resultValue clear ];

        [ self.lhsOperand appendString: [ _Button title ] ];
        self.typingState = OMCWaitAllOperands;
        }
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
        [ self.lhsOperand clear ];
        [ self.rhsOperand clear ];

        [ self.lhsOperand appendString: self.resultValue ];
        [ self.resultValue clear ];
        [ self.theOperator appendString: [ [ _Button title ] uppercaseString ] ];

        self.typingState = OMCWaitRhsOperand;
        }
    }

- ( void ) _calculateTheResultValueWithLastPressedButton: ( NSButton* )_Button
    {
    if ( self.typingState == OMCFinishedTyping || self.typingState == OMCWaitAllOperands )
        {
        if ( self.resultValue.length > 0 )
            {
            [ self.lhsOperand clear ];
            [ self.rhsOperand clear ];
            [ self.theOperator clear ];
            [ self.resultValue clear ];
            
            self.typingState = OMCWaitAllOperands;
            }

        return;
        }

    if ( [ self.theOperator isEqualToString: @"+" ] )
        [ self.resultValue appendString: [ NSString stringWithFormat: @"%ld", self.lhsOperand.integerValue + self.rhsOperand.integerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"-" ] )
        [ self.resultValue appendString: [ NSString stringWithFormat: @"%ld", self.lhsOperand.integerValue - self.rhsOperand.integerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"×" ] )
        [ self.resultValue appendString: [ NSString stringWithFormat: @"%ld", self.lhsOperand.integerValue * self.rhsOperand.integerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"÷" ] )
        [ self.resultValue appendString: [ NSString stringWithFormat: @"%ld", self.lhsOperand.integerValue / self.rhsOperand.integerValue ] ];

    else if ( [ self.theOperator isEqualToString: @"AND" ] )
        [ self.resultValue appendString: [ NSString stringWithFormat: @"%ld", self.lhsOperand.integerValue & self.rhsOperand.integerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"OR" ] )
        [ self.resultValue appendString: [ NSString stringWithFormat: @"%ld", self.lhsOperand.integerValue | self.rhsOperand.integerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"LSH" ] )
        [ self.resultValue appendString: [ NSString stringWithFormat: @"%ld", self.lhsOperand.integerValue << self.rhsOperand.integerValue ] ];
    else if ( [ self.theOperator isEqualToString: @"RSH" ] )
        [ self.resultValue appendString: [ NSString stringWithFormat: @"%ld", self.lhsOperand.integerValue >> self.rhsOperand.integerValue ] ];

//    [ self.lhsOperand deleteCharactersInRange: NSMakeRange( 0, self.lhsOperand.length ) ];
//    [ self.rhsOperand deleteCharactersInRange: NSMakeRange( 0, self.rhsOperand.length ) ];

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
        [ self _appendNumberWithLastPressedButton: self.lastTypedButton ];  break;

//    case OMC0xA:        [ self.resultingFormula appendString: @"A" ];  break;
//    case OMC0xB:        [ self.resultingFormula appendString: @"B" ];  break;
//    case OMC0xC:        [ self.resultingFormula appendString: @"C" ];  break;
//    case OMC0xD:        [ self.resultingFormula appendString: @"D" ];  break;
//    case OMC0xE:        [ self.resultingFormula appendString: @"E" ];  break;
//    case OMC0xF:        [ self.resultingFormula appendString: @"F" ];  break;
//    case OMC0xFF:       [ self.resultingFormula appendString: @"FF" ]; break;

    // Binary operators
    case OMCAnd:
    case OMCOr:
    case OMCXor:
    case OMCLsh:
    case OMCRsh:
    case OMCRoL:
    case OMCRoR:
    case OMC2_s:
    case OMC1_s:
    case OMCMod:
    case OMCAdd:
    case OMCSub:
    case OMCMuliply:
    case OMCDivide:
        [ self _appendBinaryOperatorWithLastPressedButton: self.lastTypedButton ];  break;

    case OMCNor:        break;
    case OMCFactorial:  break;

    case OMCDel:        break;  // TODO:
    case OMCAC:         break;  // TODO:
    case OMCClear:      break;  // TODO:

    case OMCLeftParenthesis:  break;
    case OMCRightParenthesis: break;

    case OMCEnter:
        [ self _calculateTheResultValueWithLastPressedButton: self.lastTypedButton ];   break;
        }
    }

- ( IBAction ) aryChanged: ( id )_Sender
    {
    NSSegmentedControl* arySeg = ( NSSegmentedControl* )_Sender;

    self.currentAry = ( OMCAry )[ arySeg.cell tagForSegment: [ arySeg selectedSegment ] ];

    [ USER_DEFAULTS setInteger: self.currentAry forKey: OMCDefaultsKeyAry ];
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

- ( void ) setLhsOperand: ( NSString* )_LhsOperand
    {
    if ( self->_lhsOperand != _LhsOperand )
        {
        [ self->_lhsOperand release ];
        self->_lhsOperand = [ _LhsOperand mutableCopy ];
        }
    }

- ( void ) setRhsOperand: ( NSString* )_RhsOperand
    {
    if ( self->_rhsOperand != _RhsOperand )
        {
        [ self->_rhsOperand release ];
        self->_rhsOperand = [ _RhsOperand mutableCopy ];
        }
    }

- ( void ) setTheOperator: ( NSString* )_Operator
    {
    if ( self->_theOperator != _Operator )
        {
        [ self->_theOperator release ];
        self->_theOperator = [ _Operator mutableCopy ];
        }
    }

- ( void ) setResultValue: ( NSString* )_ResultValue
    {
    if ( self->_resultValue != _ResultValue )
        {
        [ self->_resultValue release ];
        self->_resultValue = [ _ResultValue mutableCopy ];
        }
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