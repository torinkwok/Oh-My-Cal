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

#import "OMCOperand.h"

NSString* const OMCDot = @".";

// Exception names
NSString* const OMCOperandExactnessException = @"OMCOperandExactnessException";
NSString* const OMCOperandOverflowException = @"OMCOperandOverflowException";
NSString* const OMCOperandUnderflowException = @"OMCOperandUnderflowException";
NSString* const OMCOperandDivideByZeroException = @"OMCOperandDivideByZeroException";

// OMCOperand class
@implementation OMCOperand

@synthesize decimalNumber = _decimalNumber;
@synthesize numericString = _numericString;

@synthesize inOctal = _inOctal;
@synthesize inDecimal = _inDecimal;
@synthesize inHex = _inHex;

@synthesize unsignedInteger = _unsignedInteger;

@synthesize calStyle = _calStyle;
@synthesize currentAry = _currentAry;

@synthesize isWaitingForFloatNumber = _isWaitingForFloatNumber;

@synthesize decimalNumberHandler = _decimalNumberHandler;

#pragma mark Overrides
- ( NSString* ) description
    {
    return [ self _numericStringInAry: self.currentAry ];
    }

- ( id ) copyWithZone: ( NSZone* )_Zone
    {
    id newOperand = [ [ self class ] operandWithDecimalNumber: [ self.decimalNumber copy ]
                                                        inAry: self.currentAry
                                                     calStyle: self.calStyle ];

    return newOperand;
    }

#pragma mark Initializers & Deallocators
+ ( id ) operandWithDecimalNumber: ( NSDecimalNumber* )_DecimalNumber
    {
    return [ self operandWithDecimalNumber: _DecimalNumber inAry: OMCDecimal calStyle: OMCBasicStyle ];
    }

+ ( id ) operandWithDecimalNumber: ( NSDecimalNumber* )_DecimalNumber
                            inAry: ( OMCAry )_Ary
                         calStyle: ( OMCCalStyle )_CalStyle
    {
    return [ [ [ [ self class ] alloc ] initWithDecimalNumber: _DecimalNumber
                                                        inAry: _Ary
                                                     calStyle: _CalStyle ] autorelease ];
    }

+ ( id ) operandWithUnsignedInteger: ( NSUInteger )_UnsignedInteger
    {
    return [ OMCOperand operandWithUnsignedInteger: _UnsignedInteger inAry: OMCDecimal calStyle: OMCBasicStyle ];
    }

+ ( id ) operandWithUnsignedInteger: ( NSUInteger )_UnsignedInteger
                              inAry: ( OMCAry )_Ary
                           calStyle: ( OMCCalStyle )_CalStyle
    {
    NSNumber* unsignedNumber = [ NSNumber numberWithUnsignedInteger: _UnsignedInteger ];
    NSDecimalNumber* resultDecimalNumber = [ NSDecimalNumber decimalNumberWithString: [ unsignedNumber stringValue ] ];

    OMCOperand* newOperand = [ OMCOperand operandWithDecimalNumber: resultDecimalNumber
                                                             inAry: _Ary
                                                          calStyle: _CalStyle];
    return newOperand;
    }

- ( id ) initWithDecimalNumber: ( NSDecimalNumber* )_DecimalNumber
    {
    return [ self initWithDecimalNumber: _DecimalNumber inAry: OMCDecimal calStyle: OMCBasicStyle ];
    }

- ( id ) initWithDecimalNumber: ( NSDecimalNumber* )_DecimalNumber
                         inAry: ( OMCAry )_Ary
                      calStyle: ( OMCCalStyle )_CalStyle
    {
    if ( self = [ super init ] )
        {
        self.calStyle = _CalStyle;
        self.currentAry = _Ary;

        self.decimalNumber = _DecimalNumber;
        self.numericString = [ NSMutableString stringWithString: [ self _numericStringInAry: self.currentAry ] ];

        self.isWaitingForFloatNumber = NO;

    #if DEBUG   // Just for testing
        self.decimalNumberHandler =
            [ NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode: NSRoundPlain
                                                                    scale: 15
                                                         raiseOnExactness: YES
                                                          raiseOnOverflow: YES
                                                         raiseOnUnderflow: YES
                                                      raiseOnDivideByZero: YES ];
    #endif
        }

    return self;
    }

+ ( id ) zero
    {
    return [ OMCOperand operandWithDecimalNumber: [ NSDecimalNumber zero ] ];
    }

+ ( id ) one
    {
    return [ OMCOperand operandWithDecimalNumber: [ NSDecimalNumber one ] ];
    }

- ( NSComparisonResult ) compare: ( OMCOperand* )_Rhs
    {
    return [ self.decimalNumber compare: _Rhs.decimalNumber ];
    }

#pragma mark Accessors
- ( NSString* ) inOctal
    {
    return [ NSString stringWithFormat: @"%lo", [ self.decimalNumber unsignedIntegerValue ] ];
    }

- ( NSString* ) inDecimal
    {
    NSString* decimalForm = nil;

    switch ( self.calStyle )
        {
    case OMCBasicStyle:
    case OMCScientificStyle:
        decimalForm = [ NSString stringWithFormat: @"%@", [ self.decimalNumber description ] ];
        break;

    case OMCProgrammerStyle:
        decimalForm = [ NSString stringWithFormat: @"%lu", [ self.decimalNumber unsignedIntegerValue ] ];
        break;
        }

    return decimalForm;
    }

- ( NSString* ) inHex
    {
    NSString* hexValueInUppercase = [ NSString stringWithFormat: @"%lx", [ self.decimalNumber unsignedIntegerValue ] ].uppercaseString;
    return [ NSString stringWithFormat: @"0x%@", hexValueInUppercase ];
    }

#pragma mark Degit Operations
- ( void ) appendDigit: ( NSInteger )_Digit
                 count: ( NSInteger )_Count
                   ary: ( OMCAry )_Ary
    {
    NSString* digitToBeAppend = nil;

    switch ( self.calStyle )
        {
    case OMCBasicStyle:
    case OMCScientificStyle:
            {
            if ( _Digit == -1 /* If the user has just pressed the '.' button... */ )
                {
                if ( !self.isWaitingForFloatNumber /* If the user has already pressed the '.' button, do nothing */ )
                    {
                    self.isWaitingForFloatNumber = YES;

                    digitToBeAppend = [ NSString stringWithFormat: OMCDot ];
                    [ self.numericString appendString: digitToBeAppend ];
                    }
                }
            else
                {
                digitToBeAppend = [ NSString stringWithFormat: @"%ld", _Digit ];

                if ( self.isWaitingForFloatNumber )
                    /* If the user has already pressed the '.' button, 
                     * and he began to type the digit after decimal separator... */
                    [ self _appendDigit: digitToBeAppend ];
                else /* If the user hasn't pressed the '.' button.
                      * In other words, the current numeric is just a integer... */
                    {
                    if ( [ self.numericString isEqualToString: @"0" ] )
                        /* For a decimal integer, the beginning of numeric is never 0... */
                        [ self.numericString clear ];

                    [ self _appendDigit: digitToBeAppend ];
                    }
                }
            } break;

    case OMCProgrammerStyle:
            {
            NSUInteger baseNumber = 10;
            NSUInteger currentNumeric = [ [ self decimalNumber ] unsignedIntegerValue ];

            if ( _Ary == OMCDecimal )           baseNumber = 10;
                else if ( _Ary == OMCOctal )    baseNumber = 8;
                else if ( _Ary == OMCHex )      baseNumber = 16;

            NSUInteger newNumeric = ( NSUInteger )( currentNumeric * pow( ( double )baseNumber, ( double )_Count ) + _Digit );
            NSString* newNumericString = [ NSNumber numberWithUnsignedInteger: newNumeric ].stringValue;

            if ( [ newNumericString length ] <= UNSIGNED_INT_OPERAND_MAX_DIGIT )
                self.decimalNumber = [ NSDecimalNumber decimalNumberWithString: newNumericString ];
            else
                ;   // TODO: NSBeep();

            [ self.numericString replaceAllWithString: [ self _numericStringInAry: _Ary ] ];
            } break;
        }
    }

- ( void ) deleteDigit: ( NSInteger )_Digit
                 count: ( NSInteger )_Count
                   ary: ( OMCAry )_Ary
    {
    switch ( self.calStyle )
        {
    case OMCBasicStyle:
    case OMCScientificStyle:
            {
            [ self _deleteLastDigit ];

            if ( ![ self.numericString contains: OMCDot ] && self.isWaitingForFloatNumber )
                self.isWaitingForFloatNumber = NO;
            } break;

    case OMCProgrammerStyle:
            {
            NSUInteger baseNumber = 10;
            NSUInteger currentNumber = [ [ self decimalNumber ] unsignedIntegerValue ];

            if ( _Ary == OMCDecimal )           baseNumber = 10;
                else if ( _Ary == OMCOctal )    baseNumber = 8;
                else if ( _Ary == OMCHex )      baseNumber = 16;

            NSUInteger newNumeric = ( NSUInteger )( ( currentNumber - _Digit ) / pow( ( double )baseNumber, ( double )_Count ) );
            NSString* newNumericString = [ NSNumber numberWithUnsignedInteger: newNumeric ].stringValue;

            self.decimalNumber = [ NSDecimalNumber decimalNumberWithString: newNumericString ];

            [ self.numericString replaceAllWithString: [ self _numericStringInAry: _Ary ] ];
            } break;
        }
    }

- ( BOOL ) isZero
    {
    return [ self.decimalNumber compare: [ NSDecimalNumber zero ] ] == NSOrderedSame;
    }

- ( void ) zeroed
    {
    self.decimalNumber = [ NSDecimalNumber zero ];
    [ self.numericString replaceAllWithString: @"0" ];
    }

- ( void ) _appendDigit: ( NSString* )_DigitToBeAppend
    {
    [ self.numericString appendString: _DigitToBeAppend ];
    self.decimalNumber = [ NSDecimalNumber decimalNumberWithString: self.numericString ];
    }

- ( void ) _deleteLastDigit
    {
    if ( [ self.numericString isEqualToString: @"0" ] )
        return;

    [ self.numericString deleteTheLastCharacter ];
    self.decimalNumber = [ NSDecimalNumber decimalNumberWithString: self.numericString ];
    }

- ( NSString* ) _numericStringInAry: ( OMCAry )_Ary
    {
    NSString* numericString = nil;

    if ( _Ary == OMCDecimal )           numericString = [ self inDecimal ];
        else if ( _Ary == OMCOctal )    numericString = [ self inOctal ];
        else if ( _Ary == OMCHex )      numericString = [ self inHex ];

    return numericString;
    }

#pragma mark Accessors
- ( void ) setCurrentAry: ( OMCAry )_Ary
    {
    if ( self->_currentAry != _Ary )
        {
        self->_currentAry = _Ary;
        [ self.numericString replaceAllWithString: [ self _numericStringInAry: self->_currentAry ] ];
        }
    }

- ( OMCAry ) currentAry
    {
    return self->_currentAry;
    }

- ( int ) decimalPlaces
    {
    return abs( [ [ self decimalNumber ] decimalValue ]._exponent );
    }

- ( NSUInteger ) unsignedInteger
    {
    return self.decimalNumber.unsignedIntegerValue;
    }

#pragma mark Calculation
- ( OMCOperand* ) add: ( OMCOperand* )_Rhs
    {
    NSDecimalNumber* resultDecimal = [ self.decimalNumber decimalNumberByAdding: _Rhs.decimalNumber
                                                                   withBehavior: self ];
    return [ OMCOperand operandWithDecimalNumber: resultDecimal
                                           inAry: self.currentAry
                                        calStyle: self.calStyle ];
    }

- ( OMCOperand* ) subtract: ( OMCOperand* )_Rhs
    {
    NSDecimalNumber* resultDecimal = [ self.decimalNumber decimalNumberBySubtracting: _Rhs.decimalNumber
                                                                        withBehavior: self ];
    return [ OMCOperand operandWithDecimalNumber: resultDecimal
                                           inAry: self.currentAry
                                        calStyle: self.calStyle ];
    }

- ( OMCOperand* ) multiply: ( OMCOperand* )_Rhs
    {
    NSDecimalNumber* resultDecimal = [ self.decimalNumber decimalNumberByMultiplyingBy: _Rhs.decimalNumber
                                                                          withBehavior: self ];
    return [ OMCOperand operandWithDecimalNumber: resultDecimal
                                           inAry: self.currentAry
                                        calStyle: self.calStyle ];
    }

- ( OMCOperand* ) divide: ( OMCOperand* )_Rhs
    {
    NSDecimalNumber* resultDecimal = [ self.decimalNumber decimalNumberByDividingBy: _Rhs.decimalNumber
                                                                       withBehavior: self ];
    return [ OMCOperand operandWithDecimalNumber: resultDecimal
                                           inAry: self.currentAry
                                        calStyle: self.calStyle ];
    }

- ( OMCOperand* ) mod: ( OMCOperand* )_Rhs
    {
    return [ OMCOperand operandWithUnsignedInteger: self.unsignedInteger % _Rhs.unsignedInteger
                                             inAry: self.currentAry
                                          calStyle: self.calStyle ];
    }

- ( OMCOperand* ) factorial
    {
    return [ OMCOperand operandWithUnsignedInteger: factorial( self.unsignedInteger )
                                             inAry: self.currentAry
                                          calStyle: self.calStyle ];
    }

- ( OMCOperand* ) bitwiseAnd: ( OMCOperand* )_Rhs
    {
    return [ OMCOperand operandWithUnsignedInteger: self.unsignedInteger & _Rhs.unsignedInteger
                                             inAry: self.currentAry
                                          calStyle: self.calStyle ];
    }

- ( OMCOperand* ) bitwiseOr: ( OMCOperand* )_Rhs
    {
    return [ OMCOperand operandWithUnsignedInteger: self.unsignedInteger | _Rhs.unsignedInteger
                                             inAry: self.currentAry
                                          calStyle: self.calStyle ];
    }
    
- ( OMCOperand* ) bitwiseNor: ( OMCOperand* )_Rhs
    {
    return [ OMCOperand operandWithUnsignedInteger: ~( self.unsignedInteger | _Rhs.unsignedInteger )
                                             inAry: self.currentAry
                                          calStyle: self.calStyle ];
    }

- ( OMCOperand* ) bitwiseXor: ( OMCOperand* )_Rhs
    {
    return [ OMCOperand operandWithUnsignedInteger: self.unsignedInteger ^ _Rhs.unsignedInteger
                                             inAry: self.currentAry
                                          calStyle: self.calStyle ];
    }

- ( OMCOperand* ) Lsh: ( OMCOperand* )_Rhs
    {
    return [ OMCOperand operandWithUnsignedInteger: self.unsignedInteger << _Rhs.unsignedInteger
                                             inAry: self.currentAry
                                          calStyle: self.calStyle ];
    }

- ( OMCOperand* ) Rsh: ( OMCOperand* )_Rhs
    {
    return [ OMCOperand operandWithUnsignedInteger: self.unsignedInteger >> _Rhs.unsignedInteger
                                             inAry: self.currentAry
                                          calStyle: self.calStyle ];
    }

- ( OMCOperand* ) RoL
    {
    return [ self Lsh: [ OMCOperand one ] ];
    }

- ( OMCOperand* ) RoR
    {
    return [ self Rsh: [ OMCOperand one ] ];
    }

- ( OMCOperand* ) flipBytes
    {
    return [ OMCOperand operandWithUnsignedInteger: ~self.unsignedInteger
                                             inAry: self.currentAry
                                          calStyle: self.calStyle ];
    }

NSUInteger factorial( NSUInteger _X )
    {
    if ( _X <= 1 )
        return 1;
    else
        return _X * factorial( _X - 1 );
    }

@end // OMCOperand class

// OMCOperand + OMCDecimalNumberBehaviors
@implementation OMCOperand ( OMCDecimalNumberBehaviors )

- ( short ) scale
    {
    return 15;
    }

- ( NSRoundingMode ) roundingMode
    {
    return NSRoundPlain;
    }

- ( NSDecimalNumber* ) exceptionDuringOperation: ( SEL )_OperationMethod
                                          error: ( NSCalculationError )_Error
                                    leftOperand: ( NSDecimalNumber* )_LhsOperand
                                   rightOperand: ( NSDecimalNumber* )_RhsOperand
    {
    NSDecimalNumber* correctedValue = nil;

    switch ( _Error )
        {
    /* Just for eliminating the waring: "Enumeration value 'NSCalculationNoError' not handled in switch" */
    case NSCalculationNoError:  break;

    /* Exception name: OMCOperandDivideByZeroException */
    case NSCalculationDivideByZero:
            {
            NSException* divideByZeroEx = [ NSException exceptionWithName: OMCOperandDivideByZeroException
                                                                   reason: @"OMCOperand divide by zero exception"
                                                                 userInfo: nil ];
            @throw divideByZeroEx;
            } break; /* Reason: `OMCOperand divide by zero exception` */

    /* Exception name: OMCOperandOverflowException */
    case NSCalculationOverflow:
            {
            NSLog( @"# Overflow: [ %@ %@ %@ ]", _LhsOperand, NSStringFromSelector( _OperationMethod ), _RhsOperand );
            correctedValue = [ NSDecimalNumber notANumber ];
            } break; /* Reason: `OMCOperand overflow exception` */

    /* Exception name: OMCOperandUnderflowException */
    case NSCalculationUnderflow:
            {
            NSLog( @"# Underflow: [ %@ %@ %@ ]", _LhsOperand, NSStringFromSelector( _OperationMethod ), _RhsOperand );
            correctedValue = [ NSDecimalNumber notANumber ];
            } break; /* Reason: `OMCOperand underflow exception` */

    /* Exception name: OMCOperandExactnessException */
    case NSCalculationLossOfPrecision:
            {
            NSLog( @"# Exactness: [ %@ %@ %@ ]", _LhsOperand, NSStringFromSelector( _OperationMethod ), _RhsOperand );
            } break; /* Reason: `OMCOperand exactness exception` */
        }

    return correctedValue;
    }

@end // OMCOperand + OMCDecimalNumberBehaviors

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