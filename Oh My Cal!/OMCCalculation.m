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

// Exception Names
NSString* const OMCInvalidCalStyle = @"OMCInvalidCalStyle";

// OMCCalculation class
@implementation OMCCalculation

@synthesize _binaryOperationPanel;

@synthesize typingState = _typingState;

@synthesize currentAry = _currentAry;
@dynamic calStyle;
@synthesize trigonometricMode = _trigonometricMode;
@synthesize hasMemory = _hasMemory;
@synthesize isInShift = _isInShift;

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
    [ self setHasMemory: NO ];
    [ self setIsInShift: NO ];

    /* Radian mode by default */
    [ self setTrigonometricMode: OMCRadianMode ];

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
    if ( !self.lhsOperand )     self.lhsOperand = [ OMCOperand zero ];
    if ( !self.rhsOperand )     self.rhsOperand = [ OMCOperand zero ];
    if ( !self.resultValue )    self.resultValue = [ OMCOperand zero ];
    if ( !self.memory )         self.memory = [ OMCOperand zero ];

    if ( !self.theOperator )    self.theOperator = [ NSMutableString string ];
    }

- ( void ) deleteNumberWithLastPressedButton: ( NSButton* )_Button
    {
    OMCOperand* operandWillBeDeleted = nil;

    if ( self.typingState == OMCWaitAllOperands )       operandWillBeDeleted = self.lhsOperand;
    else if ( self.typingState == OMCWaitRhsOperand )   operandWillBeDeleted = self.rhsOperand;
    else if ( self.typingState == OMCFinishedTyping )
        {
        NSBeep();
        return;
        }

    NSUInteger baseNumber = operandWillBeDeleted.decimalNumber.unsignedIntegerValue;

    [ operandWillBeDeleted deleteDigit: baseNumber % 10 count: 1 ary: self.currentAry ];

    if ( self.typingState == OMCWaitAllOperands )
        self.typingState = OMCWaitAllOperands;
    else if ( self.typingState == OMCWaitRhsOperand )
        self.typingState = OMCWaitRhsOperand;
    }

- ( void ) appendNumberWithLastPressedButton: ( NSButton* )_Button
    {
    NSString* buttonTitle = [ _Button title ];
    NSInteger numberWillBeAppended = numberWillBeAppended = [ buttonTitle integerValue ];

    BOOL isWaitingForFloatNumber = [ buttonTitle isEqualToString: OMCDot ];
    if ( isWaitingForFloatNumber )
        numberWillBeAppended = -1;

    // Float number is not available for the rhs operand of EE calculation
    if ( numberWillBeAppended == -1 && COMPARE_WITH_OPERATOR( OMCeIdentifier ) )
        {
        NSBeep();
        return;
        }

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
        [ self.theOperator appendString: [ _Button identifier ] ];
        self.typingState = OMCWaitRhsOperand;
        }
    else if ( self.typingState == OMCFinishedTyping )
        {
        [ self.theOperator clear ];

        [ self.lhsOperand zeroed ];
        [ self.rhsOperand zeroed ];

        self.lhsOperand = [ self.resultValue copy ];
        [ self.resultValue zeroed ];
        [ self.theOperator appendString: [ _Button identifier ] ];

        self.typingState = OMCWaitRhsOperand;
        }
    }

- ( void ) calculateTheResultValueForMonomialWithLastPressedButton: ( NSButton* )_Button
    {
    [ self appendUnitaryOperatorWithLastPressedButton: _Button ];

    SEL calculation = nil;

    if ( COMPARE_WITH_OPERATOR( @"!" ) )             calculation = @selector( factorial );
    else if ( COMPARE_WITH_OPERATOR( @"RoL" ) )      calculation = @selector( RoL );
    else if ( COMPARE_WITH_OPERATOR( @"RoR" ) )      calculation = @selector( RoR );

    else if ( COMPARE_WITH_OPERATOR( @"2's" )
            || COMPARE_WITH_OPERATOR( @"1's" ) )     calculation = @selector( flipBytes );

    else if ( COMPARE_WITH_OPERATOR( @"x²" ) )       calculation = @selector( square );
    else if ( COMPARE_WITH_OPERATOR( @"x³" ) )       calculation = @selector( cube );
    else if ( COMPARE_WITH_OPERATOR( @"1/x" ) )      calculation = @selector( reciprocal );
    else if ( COMPARE_WITH_OPERATOR( @"√" ) )        calculation = @selector( sqrt );
    else if ( COMPARE_WITH_OPERATOR( @"%" ) )        calculation = @selector( percent );
    else if ( COMPARE_WITH_OPERATOR( @"∛") )         calculation = @selector( cubeRoot );
    else if ( COMPARE_WITH_OPERATOR( @"eˣ") )        calculation = @selector( e_x );
    else if ( COMPARE_WITH_OPERATOR( @"2ˣ") )        calculation = @selector( _2_x );
    else if ( COMPARE_WITH_OPERATOR( @"10ˣ") )       calculation = @selector( _10_x );

    else if ( COMPARE_WITH_OPERATOR( @"log₂" ) )     calculation = @selector( log2 );
    else if ( COMPARE_WITH_OPERATOR( @"log₁₀" ) )    calculation = @selector( log10 );
    else if ( COMPARE_WITH_OPERATOR( @"In" ) )       calculation = @selector( naturalLogarithm );

    else if ( COMPARE_WITH_OPERATOR( @"sin" ) )
        calculation = ( self.trigonometricMode == OMCRadianMode ) ? @selector( sinWithRadians ) : @selector( sinWithDegrees );

    else if ( COMPARE_WITH_OPERATOR( @"cos" ) )
        calculation = ( self.trigonometricMode == OMCRadianMode ) ? @selector( cosWithRadians ) : @selector( cosWithDegrees );

    else if ( COMPARE_WITH_OPERATOR( @"tan" ) )
        calculation = ( self.trigonometricMode == OMCRadianMode ) ? @selector( tanWithRadians ) : @selector( tanWithDegrees );

    else if ( COMPARE_WITH_OPERATOR( @"sinh" ) )     calculation = @selector( sinh );
    else if ( COMPARE_WITH_OPERATOR( @"cosh" ) )     calculation = @selector( cosh );
    else if ( COMPARE_WITH_OPERATOR( @"tanh" ) )     calculation = @selector( tanh );

    else if ( COMPARE_WITH_OPERATOR( @"sin⁻¹" ) )
        calculation = ( self.trigonometricMode == OMCRadianMode ) ? @selector( asinWithRadians ) : @selector( asinWithDegrees );

    else if ( COMPARE_WITH_OPERATOR( @"cos⁻¹" ) )
        calculation = ( self.trigonometricMode == OMCRadianMode ) ? @selector( acosWithRadians ) : @selector( acosWithDegrees );

    else if ( COMPARE_WITH_OPERATOR( @"tan⁻¹" ) )
        calculation = ( self.trigonometricMode == OMCRadianMode ) ? @selector( atanWithRadians ) : @selector( atanWithDegrees );

    else if ( COMPARE_WITH_OPERATOR( @"sinh⁻¹" ) )   calculation = @selector( asinh );
    else if ( COMPARE_WITH_OPERATOR( @"cosh⁻¹" ) )   calculation = @selector( acosh );
    else if ( COMPARE_WITH_OPERATOR( @"tanh⁻¹" ) )   calculation = @selector( atanh );

    else if ( COMPARE_WITH_OPERATOR( @"π" ) )        calculation = @selector( pi );
    else if ( COMPARE_WITH_OPERATOR( @"e" ) )        calculation = @selector( e );
    else if ( COMPARE_WITH_OPERATOR( @"Rand" ) )     calculation = @selector( rand );

    self.resultValue = [ self _performCalculationOfMonomial: calculation ];
    self.typingState = OMCFinishedTyping;
    }

- ( OMCOperand* ) _performCalculationOfMonomial: ( SEL )_CalSel
    {
    BOOL isClassMethod = NO;
    if ( _CalSel == @selector( pi ) || _CalSel == @selector( e ) || _CalSel == @selector( rand ) )
        isClassMethod = YES;

    /* Because of the calculation of monomial, the possible operand is just lhsOperand and resultValue.
     * So we don't need the rhsOperand */
    OMCOperand* operand = ( self.typingState == OMCWaitAllOperands ) ? self.lhsOperand : self.resultValue;
    Class operandClass = [ OMCOperand class ];

    NSMethodSignature* calMethodSignature = [ ( isClassMethod ? operandClass : operand ) methodSignatureForSelector: _CalSel ];
    NSInvocation* calInvocation = [ NSInvocation invocationWithMethodSignature: calMethodSignature ];
    [ calInvocation setSelector: _CalSel ];

    NSUInteger returnValBytes = [ [ calInvocation methodSignature ] methodReturnLength ];
    void* buffer = ( void* )malloc( returnValBytes );

    [ calInvocation invokeWithTarget: ( isClassMethod ? operandClass : operand ) ];
    [ calInvocation getReturnValue: &buffer ];

    return ( OMCOperand* )buffer;
    }

- ( void ) calculateTheResultValueForBinomialWithLastPressedButton: ( NSButton* )_Button
    {
    if ( self.typingState == OMCFinishedTyping /* If the user has already finished a calculation... */
            || self.typingState == OMCWaitAllOperands /* or if the user is typing the left operand... */  )
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

    SEL calculation = nil;

    /* If the user has not finished a calculation,
     * for example, they have finished typing the right operand,
     * and they want to calculate a result value... */
    if ( COMPARE_WITH_OPERATOR( OMCAddOperatorIdentifier) )             calculation = @selector( add: );
    else if ( COMPARE_WITH_OPERATOR( OMCSubOperatorIdentifier ) )       calculation = @selector( subtract: );
    else if ( COMPARE_WITH_OPERATOR( OMCMultiplyOperatorIdentifier ) )  calculation = @selector( multiply: );
    else if ( COMPARE_WITH_OPERATOR( OMCDivideOperatorIdentifier ) )    calculation = @selector( divide: );

    else if ( COMPARE_WITH_OPERATOR( OMCAndOperatorIdentifier ) )       calculation = @selector( bitwiseAnd: );
    else if ( COMPARE_WITH_OPERATOR( OMCOrOperatorIdentifier ) )        calculation = @selector( bitwiseOr: );
    else if ( COMPARE_WITH_OPERATOR( OMCNorOperatorIdentifier ) )       calculation = @selector( bitwiseNor: );
    else if ( COMPARE_WITH_OPERATOR( OMCXorOperatorIdentifier ) )       calculation = @selector( bitwiseXor: );
    else if ( COMPARE_WITH_OPERATOR( OMCLshOperatorIdentifier ) )       calculation = @selector( Lsh: );
    else if ( COMPARE_WITH_OPERATOR( OMCRshOperatorIdentifier ) )       calculation = @selector( Rsh: );

    else if ( COMPARE_WITH_OPERATOR( OMCPowXOperatorIdentifier ) )      calculation = @selector( pow: );
    else if ( COMPARE_WITH_OPERATOR( OMCxRootIdentifier ) )             calculation = @selector( xRoot: );
    else if ( COMPARE_WITH_OPERATOR( OMCModOperatorIdentifier ) )       calculation = @selector( mod: );
    else if ( COMPARE_WITH_OPERATOR( OMCeIdentifier ) )                 calculation = @selector( EE: );

    self.resultValue = [ self _performCalculationOfBinomial: calculation ];
    self.typingState = OMCFinishedTyping;
    }

- ( OMCOperand* ) _performCalculationOfBinomial: ( SEL )_CalSel
    {
    OMCOperand* lhsOperand = self.lhsOperand;
    OMCOperand* rhsOperand = self.rhsOperand;

    NSMethodSignature* calMethodSignature = [ lhsOperand methodSignatureForSelector: _CalSel ];
    NSInvocation* calInvocation = [ NSInvocation invocationWithMethodSignature: calMethodSignature ];
    [ calInvocation setSelector: _CalSel ];
    [ calInvocation setArgument: &rhsOperand atIndex: 2 ];

    NSUInteger returnValBytes = [ [ calInvocation methodSignature ] methodReturnLength ];
    void* buffer = ( void* )malloc( returnValBytes );

    [ calInvocation invokeWithTarget: lhsOperand ];
    [ calInvocation getReturnValue: &buffer ];

    return ( OMCOperand* )buffer;
    }

#pragma mark IBActions
// All of the buttons on the keyboard has been connected to this action
- ( IBAction ) calculate: ( id )_Sender
    {
    NSButton* pressedButton = ( NSButton* )_Sender;
    self.lastTypedButtonType = ( OMCButtonType )[ pressedButton tag ];
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
    case OMCOne:    case OMCTwo:    case OMCThree:  case OMCFour:   case OMCFive:       case OMCSix:
    case OMCSeven:  case OMCEight:  case OMCNine:   case OMCZero:   case OMCDoubleZero:
    case OMCFloatPoint:

    case OMC0xA:    case OMC0xB:    case OMC0xC:    case OMC0xD:    case OMC0xE:    case OMC0xF:
    case OMC0xFF:
            {
            [ self appendNumberWithLastPressedButton: self.lastTypedButton ];
            } return;

    // Binary operators
    case OMCAdd:        case OMCSub:    case OMCMuliply:    case OMCDivide:

    case OMCxPower:     case OMCxRoot:  case OMCEE:

    case OMCAnd:        case OMCOr:     case OMCNor:        case OMCXor:    case OMCLsh:    case OMCRsh:
    case OMCMod:
            [ self appendBinaryOperatorWithLastPressedButton: self.lastTypedButton ];
            return;

    // Monomial operators
    case OMCPercent:    case OMCReciprocal:     case OMCSquare:     case OMCCube:
    case OMCLog2:       case OMCLog10:          case OMCIn:         case OMCSqrt:
    case OMCCubeRoot:   case OMCe_x:            case OMC2_x:        case OMC10_x:
    
    case OMCSin:        case OMCCos:    case OMCTan:    case OMCSinh:       case OMCCosh:   case OMCTanh:
    case OMCAsin:       case OMCAcos:   case OMCAtan:   case OMCAsinh:      case OMCAcosh:  case OMCAtanh:

    case OMCPi:         case OMCe:      case OMCRand:
    case OMCRoL:        case OMCRoR:    case OMCFactorial:  case OMC2_s:    case OMC1_s:
            [ self calculateTheResultValueForMonomialWithLastPressedButton: self.lastTypedButton ];
            return;

    // Commands
    case OMCDel:
            [ self deleteNumberWithLastPressedButton: self.lastTypedButton ];
            return;

    case OMCClear:
            [ self clearCurrentOperand ];
            return;

    case OMCAC:
            [ self clearAllAndReset ];
            return;

    case OMCToggleTrigonometircMode:
            [ self toggleTrigonometricMode: pressedButton ];
            return;

    case OMCLeftParenthesis:  return;
    case OMCRightParenthesis: return;

    case OMCEnter:
            [ self calculateTheResultValueForBinomialWithLastPressedButton: self.lastTypedButton ];
            return;

    /* Cal with scientific style will observe this property( isInShift ) and response it */
    case OMCShift:
            self.isInShift = !self.isInShift;
            return;

    // Memory Operations
    case OMCMemoryAdd:
    case OMCMemorySub:
            {
            OMCOperand* operandToBeAdded = nil;

            if ( self.typingState == OMCWaitAllOperands )           operandToBeAdded = self.lhsOperand;
                else if ( self.typingState == OMCWaitRhsOperand )   operandToBeAdded = self.rhsOperand;
                else if ( self.typingState == OMCFinishedTyping )   operandToBeAdded = self.resultValue;

            [ self setHasMemory: YES ];
            [ operandToBeAdded setInMemory: YES ];

            self.memory = ( self.lastTypedButtonType == OMCMemoryAdd ) ? [ self.memory add: operandToBeAdded ]
                                                                       : [ self.memory subtract: operandToBeAdded ];
            } return;

    case OMCMemoryClear:
            [ self clearMemory ];
            return;

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

- ( void ) toggleTrigonometricMode: ( NSButton* )_Button
    {
    OMCTrigonometricMode newMode = ( self.trigonometricMode == OMCRadianMode ) ? OMCDegreeMode : OMCRadianMode;
    [ self setTrigonometricMode: newMode ];
    }

- ( void ) clearMemory
    {
    [ self.memory zeroed ];

    [ self.lhsOperand setInMemory: NO ];
    [ self.rhsOperand setInMemory: NO ];
    [ self.resultValue setInMemory: NO ];

    [ self setHasMemory: NO ];
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
    if ( self->_currentAry != _Ary
            || self.lhsOperand.currentAry != _Ary
            || self.rhsOperand.currentAry != _Ary
            || self.resultValue.currentAry != _Ary )
        {
        self->_currentAry = _Ary;

        [ self.lhsOperand setCurrentAry: self->_currentAry ];
        [ self.rhsOperand setCurrentAry: self->_currentAry ];
        [ self.resultValue setCurrentAry: self->_currentAry ];
        [ self.memory setCurrentAry: self->_currentAry ];
        }
    }

- ( BOOL ) isBinomialInLastCalculation
    {
    switch ( self.lastTypedButtonType )
        {
    case OMCFactorial:
    case OMCPercent:    case OMCReciprocal:

    case OMCRoL:        case OMCRoR:
    case OMC2_s:        case OMC1_s:

    case OMCSquare:     case OMCCube:
    case OMCSqrt:

    case OMCLog2:       case OMCLog10:      case OMCIn:

    case OMCCubeRoot:   case OMCe_x:        case OMC2_x:        case OMC10_x:

    case OMCSin:        case OMCCos:        case OMCTan:
    case OMCSinh:       case OMCCosh:       case OMCTanh:

    case OMCAsin:       case OMCAcos:       case OMCAtan:
    case OMCAsinh:      case OMCAcosh:      case OMCAtanh:

    case OMCPi:         case OMCe:

    case OMCRand:
        return NO;

    default:
        return YES;
        }
    }

#pragma mark Dynamically Synthesize the Accessors
+ ( BOOL ) resolveInstanceMethod: ( SEL )_Sel
    {
    Class class = [ self class ];

    IMP implementation = nil;
    char* types = nil;
    if ( _Sel == @selector( calStyle ) )
        {
        implementation = ( IMP )_calStyleIMP;
        types = "B@:";
        }

    if ( ( implementation && types )
            && class_addMethod( class, _Sel, implementation, types ) )
        return YES;

    return [ super resolveInstanceMethod: _Sel ];
    }

OMCCalStyle _calStyleIMP( id self, SEL _cmd )
    {
    OMCCalStyle currentCalStyle = OMCBasicStyle;

    if ( [ self isMemberOfClass: [ OMCBasicStyleCalculation class ] ] )
        currentCalStyle = OMCBasicStyle;
    else if ( [ self isMemberOfClass: [ OMCScientificStyleCalculation class ] ] )
        currentCalStyle = OMCScientificStyle;
    else if ( [ self isMemberOfClass: [ OMCProgrammerStyleCalculation class ] ] )
        currentCalStyle = OMCProgrammerStyle;

    return currentCalStyle;
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