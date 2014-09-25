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

// Notification UserInfo Keys
NSString* const OMCCalculationNewTypingState = @"OMCCalculationNewTypingState";
NSString* const OMCCalculationNewAry = @"OMCCalculationNewAry";

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

@synthesize memory = _memory;

@synthesize theOperator = _theOperator;

@synthesize lastTypedButtonType = _lastTypedButtonType;
@synthesize lastTypedButton = _lastTypedButton;

@synthesize isBinomialInLastCalculation = _isBinomial;


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

    if ( !self.memory )
        self.memory = [ OMCOperand zero ];
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
        if ( self.lhsOperand.isInMemory )
            [ self.lhsOperand zeroed ];

        [ self.lhsOperand appendDigit: numberWillBeAppended count: appendCount ary: self.currentAry ];
        self.typingState = OMCWaitAllOperands;
        }
    else if ( self.typingState == OMCWaitRhsOperand )
        {
        if ( self.rhsOperand.isInMemory )
            [ self.rhsOperand zeroed ];

        [ self.rhsOperand appendDigit: numberWillBeAppended count: appendCount ary: self.currentAry ];
        self.typingState = OMCWaitRhsOperand;   // Wait for the user to pressing next button
        }
    else if ( self.typingState == OMCFinishedTyping )
        {
        [ self zeroedAllOperands ];

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

        [ self.lhsOperand zeroed ];
        [ self.rhsOperand zeroed ];

        self.lhsOperand = [ self.resultValue copy ];
        [ self.resultValue zeroed ];
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
            self.resultValue = [ self.lhsOperand factorial ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ self.resultValue factorial ];
        }
    else if ( [ self.theOperator isEqualToString: @"ROL" ] )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ self.lhsOperand RoL ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ self.resultValue RoL ];
        }
    else if ( [ self.theOperator isEqualToString: @"ROR" ] )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ self.lhsOperand RoR ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ self.resultValue RoR ];
        }
    else if ( [ self.theOperator isEqualToString: @"2'S" ]
            || [ self.theOperator isEqualToString: @"1'S" ] )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ self.lhsOperand flipBytes ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ self.resultValue flipBytes ];
        }

    else if ( [ self.theOperator compare: @"x²" options: NSCaseInsensitiveSearch ] == NSOrderedSame )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ self.lhsOperand square ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ self.resultValue square ];
        }

    else if ( [ self.theOperator compare: @"x³" options: NSCaseInsensitiveSearch ] == NSOrderedSame )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ self.lhsOperand cube ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ self.resultValue cube ];
        }

    else if ( [ self.theOperator compare: @"1/x" options: NSCaseInsensitiveSearch ] == NSOrderedSame )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ self.lhsOperand reciprocal ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ self.resultValue reciprocal ];
        }

    else if ( [ self.theOperator compare: @"√" options: NSCaseInsensitiveSearch ] == NSOrderedSame )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ self.lhsOperand sqrt ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ self.resultValue sqrt ];
        }

    else if ( [ self.theOperator compare: @"%" options: NSCaseInsensitiveSearch ] == NSOrderedSame )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ self.lhsOperand percent ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ self.resultValue percent ];
        }

    else if ( [ self.theOperator compare: @"log₂" options: NSCaseInsensitiveSearch ] == NSOrderedSame )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ self.lhsOperand log2 ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ self.resultValue log2 ];
        }

    else if ( [ self.theOperator compare: @"log₁₀" options: NSCaseInsensitiveSearch ] == NSOrderedSame )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ self.lhsOperand log10 ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ self.resultValue log10 ];
        }

    else if ( [ self.theOperator compare: @"In" options: NSCaseInsensitiveSearch ] == NSOrderedSame )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ self.lhsOperand naturalLogarithm ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ self.resultValue naturalLogarithm ];
        }

    else if ( [ self.theOperator compare: @"sin" options: NSCaseInsensitiveSearch ] == NSOrderedSame )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ self.lhsOperand sin ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ self.resultValue sin ];
        }

    else if ( [ self.theOperator compare: @"cos" options: NSCaseInsensitiveSearch ] == NSOrderedSame )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ self.lhsOperand cos ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ self.resultValue cos ];
        }

    else if ( [ self.theOperator compare: @"tan" options: NSCaseInsensitiveSearch ] == NSOrderedSame )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ self.lhsOperand tan ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ self.resultValue tan ];
        }

    else if ( [ self.theOperator compare: @"sinh" options: NSCaseInsensitiveSearch ] == NSOrderedSame )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ self.lhsOperand sinh ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ self.resultValue sinh ];
        }

    else if ( [ self.theOperator compare: @"cosh" options: NSCaseInsensitiveSearch ] == NSOrderedSame )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ self.lhsOperand cosh ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ self.resultValue cosh ];
        }

    else if ( [ self.theOperator compare: @"tanh" options: NSCaseInsensitiveSearch ] == NSOrderedSame )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ self.lhsOperand tanh ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ self.resultValue tanh ];
        }

    else if ( [ self.theOperator compare: @"π" options: NSCaseInsensitiveSearch ] == NSOrderedSame )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ OMCOperand pi ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ OMCOperand pi ];
        }

    else if ( [ self.theOperator compare: @"e" options: NSCaseInsensitiveSearch ] == NSOrderedSame )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ OMCOperand e ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ OMCOperand e ];
        }

        else if ( [ self.theOperator compare: @"Rand" options: NSCaseInsensitiveSearch ] == NSOrderedSame )
        {
        if ( self.typingState == OMCWaitAllOperands )
            self.resultValue = [ OMCOperand rand ];
        else if ( self.typingState == OMCFinishedTyping )
            self.resultValue = [ OMCOperand rand ];
        }

    self.typingState = OMCFinishedTyping;
    }

- ( void ) calculateTheResultValueForBinomialWithLastPressedButton: ( NSButton* )_Button
    {
    if ( self.typingState == OMCFinishedTyping /* If the user has finished a calculation... */
            || self.typingState == OMCWaitAllOperands /* or if the user is typing hte left operand... */  )
        {
        // Reset the LCD to a inital state
        OMCOperand* zero = [ OMCOperand zero ];

        if ( [ self.resultValue compare: zero ] == NSOrderedAscending
                || [ self.lhsOperand compare: zero ] == NSOrderedAscending
                || [ self.rhsOperand compare: zero ] == NSOrderedAscending
                || [ self.theOperator length ] > 0 )
            [ self clearAllAndReset ];

        return;
        }

    /* If the user has not finished a calculation,
     * for example, they have finished typing the right operand,
     * and they want to calculate a result value... */
    if ( [ self.theOperator isEqualToString: @"+" ] )
        self.resultValue = [ self.lhsOperand add: self.rhsOperand ];

    else if ( [ self.theOperator isEqualToString: @"-" ] )
        self.resultValue = [ self.lhsOperand subtract: self.rhsOperand ];

    else if ( [ self.theOperator isEqualToString: @"×" ] )
        self.resultValue = [ self.lhsOperand multiply: self.rhsOperand ];

    else if ( [ self.theOperator isEqualToString: @"÷" ] )
        {
        @try {
            self.resultValue = [ self.lhsOperand divide: self.rhsOperand ];
            } @catch ( NSException* _Ex )
                {
                self.resultValue = [ OMCOperand divByZero ];
                }
        }


    else if ( [ self.theOperator isEqualToString: @"Yˣ" ] )
        self.resultValue = [ self.lhsOperand pow: self.rhsOperand ];


    else if ( [ self.theOperator isEqualToString: @"AND" ] )
        self.resultValue = [ self.lhsOperand bitwiseAnd: self.rhsOperand ];

    else if ( [ self.theOperator isEqualToString: @"OR" ] )
        self.resultValue = [ self.lhsOperand bitwiseOr: self.rhsOperand ];

    else if ( [ self.theOperator isEqualToString: @"NOR" ] )
        self.resultValue = [ self.lhsOperand bitwiseNor: self.rhsOperand ];

    else if ( [ self.theOperator isEqualToString: @"XOR" ] )
        self.resultValue = [ self.lhsOperand bitwiseXor: self.rhsOperand ];

    else if ( [ self.theOperator isEqualToString: @"LSH" ] )
        self.resultValue = [ self.lhsOperand Lsh: self.rhsOperand ];

    else if ( [ self.theOperator isEqualToString: @"RSH" ] )
        self.resultValue = [ self.lhsOperand Rsh: self.rhsOperand ];

    else if ( [ self.theOperator isEqualToString: @"MOD" ] )
        self.resultValue = [ self.lhsOperand mod: self.rhsOperand ];

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
    case OMCPositiveAndNegative:
            {
            if ( self.typingState == OMCWaitAllOperands )
                {
                self.lhsOperand = [ self.lhsOperand positiveOrNegative ];
                self.typingState = OMCWaitAllOperands;
                }
            else if ( self.typingState == OMCWaitRhsOperand )
                {
                self.rhsOperand = [ self.rhsOperand positiveOrNegative ];
                self.typingState = OMCWaitRhsOperand;
                }
            else if ( self.typingState == OMCFinishedTyping )
                {
                OMCOperand* resultOperand = [ self.resultValue positiveOrNegative ];

                [ self clearAllAndReset ];

                self.lhsOperand = resultOperand;
                self.typingState = OMCWaitAllOperands;
                }
            } return;

    // Numbers
    case OMCOne:    case OMCTwo:    case OMCThree:
    case OMCFour:   case OMCFive:   case OMCSix:
    case OMCSeven:  case OMCEight:  case OMCNine:
    case OMCZero:   case OMCDoubleZero:
    case OMCFloatPoint:

    case OMC0xA:    case OMC0xB:    case OMC0xC:
    case OMC0xD:    case OMC0xE:    case OMC0xF:
    case OMC0xFF:
        {
        [ self appendNumberWithLastPressedButton: self.lastTypedButton ];
        } return;

    // Binary operators
    case OMCAdd:        case OMCSub:
    case OMCMuliply:    case OMCDivide:

    case OMCxPower:

    case OMCAnd:    case OMCOr:     case OMCNor:
    case OMCXor:    case OMCLsh:    case OMCRsh:
    case OMCMod:
            [ self appendBinaryOperatorWithLastPressedButton: self.lastTypedButton ];
            return;

    // Monomial operators
    case OMCPercent:    case OMCReciprocal:
    case OMCSquare:     case OMCCube:

    case OMCLog2:       case OMCLog10:  case OMCIn:
    case OMCSin:        case OMCCos:    case OMCTan:
    case OMCSinh:       case OMCCosh:   case OMCTanh:

    case OMCPi:         case OMCe:

    case OMCSqrt:

    case OMCRand:

    case OMCRoL:    case OMCRoR:    case OMCFactorial:
    case OMC2_s:    case OMC1_s:
            [ self calculateTheResultValueForMonomialWithLastPressedButton: self.lastTypedButton ];
            return;

    // Commands
    case OMCDel:    [ self deleteNumberWithLastPressedButton: self.lastTypedButton ];  return;

    case OMCClear:
            {
            if ( self.calStyle == OMCProgrammerStyle )
                [ self clearCurrentOperand ];
            else
                [ self clearAllAndReset ];
            } return;

    case OMCAC:     [ self clearAllAndReset ];      return;

    case OMCLeftParenthesis:  return;
    case OMCRightParenthesis: return;

    case OMCEnter:
            [ self calculateTheResultValueForBinomialWithLastPressedButton: self.lastTypedButton ];
            return;

    // Memory Operations
    case OMCMemoryAdd:
            {
            OMCOperand* operandToBeAdded = nil;

            if ( self.typingState == OMCWaitAllOperands )
                {
                operandToBeAdded = self.lhsOperand;
                [ self.lhsOperand setInMemory: YES ];
                }
            else if ( self.typingState == OMCWaitRhsOperand )
                {
                operandToBeAdded = self.rhsOperand;
                [ self.rhsOperand setInMemory: YES ];
                }
            else if ( self.typingState == OMCFinishedTyping )
                {
                operandToBeAdded = self.resultValue;
                [ self.resultValue setInMemory: YES ];
                }

            self.memory = [ self.memory add: operandToBeAdded ];
            } return;

    case OMCMemorySub:
            {
            OMCOperand* operandToBeAdded = nil;

            if ( self.typingState == OMCWaitAllOperands )
                {
                operandToBeAdded = self.lhsOperand;
                [ self.lhsOperand setInMemory: YES ];
                }
            else if ( self.typingState == OMCWaitRhsOperand )
                {
                operandToBeAdded = self.rhsOperand;
                [ self.rhsOperand setInMemory: YES ];
                }
            else if ( self.typingState == OMCFinishedTyping )
                {
                operandToBeAdded = self.resultValue;
                [ self.resultValue setInMemory: YES ];
                }

            self.memory = [ self.memory subtract: operandToBeAdded ];
            } return;

    case OMCMemoryClear: [ self clearMemory ];   return;

    case OMCMemoryRead:
            {
            if ( self.typingState == OMCWaitAllOperands )
                {
                self.lhsOperand = [ self.memory copy ];
                self.typingState = OMCWaitAllOperands;
                }
            else if ( self.typingState == OMCWaitRhsOperand )
                {
                self.rhsOperand = [ self.memory copy ];
                self.typingState = OMCWaitRhsOperand;
                }
            else if ( self.typingState == OMCFinishedTyping )
                {
                [ self clearAllAndReset ];
                self.lhsOperand = [ self.memory copy ];
                self.typingState = OMCWaitAllOperands;
                }
            } return;
        }
    }

- ( void ) clearMemory
    {
    [ self.memory zeroed ];

    [ self.lhsOperand setInMemory: NO ];
    [ self.rhsOperand setInMemory: NO ];
    [ self.resultValue setInMemory: NO ];
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

    if ( self->_typingState == OMCFinishedTyping )
        [ self back2NotWatingForFloatNumber ];

    [ NOTIFICATION_CENTER postNotificationName: OMCCurrentTypingStateDidChangedNotification
                                        object: self
                                      userInfo: @{ OMCCalculationNewTypingState : [ NSNumber numberWithInt: self.typingState ] } ];
    }

- ( void ) zeroedAllOperands
    {
    [ self.lhsOperand zeroed ];
    [ self.rhsOperand zeroed ];
    [ self.resultValue zeroed ];

    [ self.theOperator clear ];
    }

- ( void ) back2NotWatingForFloatNumber
    {
    [ self.lhsOperand setWaitingForFloatNumber: NO ];
    [ self.rhsOperand setWaitingForFloatNumber: NO  ];
    [ self.resultValue setWaitingForFloatNumber: NO ];
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
                                      userInfo: @{ OMCCalculationNewAry : [ NSNumber numberWithInt: self.currentAry ] } ];
    }

- ( BOOL ) isBinomialInLastCalculation
    {
    switch ( self.lastTypedButtonType )
        {
    case OMCFactorial:
    case OMCPercent:    case OMCReciprocal:

    case OMCRoL:    case OMCRoR:
    case OMC2_s:    case OMC1_s:

    case OMCSquare: case OMCCube:
    case OMCSqrt:

    case OMCLog2:       case OMCLog10:  case OMCIn:
    case OMCSin:        case OMCCos:    case OMCTan:
    case OMCSinh:       case OMCCosh:   case OMCTanh:

    case OMCPi:         case OMCe:

    case OMCRand:
        return NO;

    default:
        return YES;
        }
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