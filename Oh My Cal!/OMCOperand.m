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

@synthesize inOctal;
@synthesize inDecimal;
@synthesize inHex;

@synthesize unsignedInteger = _unsignedInteger;

@synthesize calStyle = _calStyle;
@synthesize currentAry = _currentAry;

@synthesize isInMemory = _isInMemory;

@synthesize isWaitingForFloatNumber = _isWaitingForFloatNumber;

@synthesize exceptionCarried = _exceptionCarried;

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
+ ( instancetype ) operandWithDecimalNumber: ( NSDecimalNumber* )_DecimalNumber
    {
    return [ self operandWithDecimalNumber: _DecimalNumber inAry: OMCDecimal calStyle: OMCBasicStyle ];
    }

+ ( instancetype ) operandWithDecimalNumber: ( NSDecimalNumber* )_DecimalNumber
                                      inAry: ( OMCAry )_Ary
                                   calStyle: ( OMCCalStyle )_CalStyle
    {
    return [ [ [ [ self class ] alloc ] initWithDecimalNumber: _DecimalNumber
                                                        inAry: _Ary
                                                     calStyle: _CalStyle ] autorelease ];
    }

+ ( instancetype ) operandWithString: ( NSString* )_NumericString
    {
    NSDecimalNumber* numeric = [ NSDecimalNumber decimalNumberWithString: _NumericString ];

    return [ OMCOperand operandWithDecimalNumber: numeric ];
    }

+ ( instancetype ) operandWithString: ( NSString* )_NumericString
                              inAry: ( OMCAry )_Ary
                           calStyle: ( OMCCalStyle )_CalStyle
    {
    OMCOperand* newOperand = [ OMCOperand operandWithString: _NumericString ];
    [ newOperand setCurrentAry: _Ary ];
    [ newOperand setCalStyle: _CalStyle ];

    return newOperand;
    }

+ ( instancetype ) operandWithUnsignedInteger: ( NSUInteger )_UnsignedInteger
    {
    return [ OMCOperand operandWithUnsignedInteger: _UnsignedInteger inAry: OMCDecimal calStyle: OMCBasicStyle ];
    }

+ ( instancetype ) operandWithUnsignedInteger: ( NSUInteger )_UnsignedInteger
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

- ( instancetype ) initWithDecimalNumber: ( NSDecimalNumber* )_DecimalNumber
    {
    return [ self initWithDecimalNumber: _DecimalNumber inAry: OMCDecimal calStyle: OMCBasicStyle ];
    }

// Designated Initializer
- ( instancetype ) initWithDecimalNumber: ( NSDecimalNumber* )_DecimalNumber
                                   inAry: ( OMCAry )_Ary
                                calStyle: ( OMCCalStyle )_CalStyle
    {
    if ( self = [ super init ] )
        {
        self.calStyle = _CalStyle;
        self.currentAry = _Ary;

        self.isInMemory = NO;

        self.decimalNumber = _DecimalNumber;
        self.numericString = [ NSMutableString stringWithString: [ self _numericStringInAry: self.currentAry ] ];

        self.isWaitingForFloatNumber = [ self.numericString contains: OMCDot ];
        }

    return self;
    }

+ ( instancetype ) zero
    {
    return [ OMCOperand operandWithDecimalNumber: [ NSDecimalNumber zero ] ];
    }

+ ( instancetype ) one
    {
    return [ OMCOperand operandWithDecimalNumber: [ NSDecimalNumber one ] ];
    }

+ ( instancetype ) divByZero
    {
    OMCOperand* newOperand = [ OMCOperand operandWithDecimalNumber: [ NSDecimalNumber notANumber ] ];
    [ newOperand setExceptionCarried: OMCOperandDivideByZeroException ];

    return newOperand;
    }

+ ( instancetype ) pi
    {
    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", PI ] ];
    }

+ ( instancetype ) e
    {
    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", EULER_NUMBER ] ];
    }

+ ( instancetype ) rand
    {
    NSMutableString* randNumericString = [ NSMutableString stringWithString: @"0." ];

    for ( int index = 0; index < 3; index++ )
        [ randNumericString appendString: [ NSString stringWithFormat: @"%d", ( rand() % 100000 + 1 ) ] ];

    return [ OMCOperand operandWithString: randNumericString ];
    }

- ( instancetype ) abs
    {
    NSDecimal decimalValue = [ self.decimalNumber decimalValue ];
    decimalValue._isNegative = NO;

    return [ OMCOperand operandWithDecimalNumber: [ NSDecimalNumber decimalNumberWithDecimal: decimalValue ]
                                           inAry: self.currentAry
                                        calStyle: self.calStyle ];
    }

- ( instancetype ) positiveOrNegative
    {
    if ( [ self compare: [ OMCOperand zero ] ] == NSOrderedSame )
        return [ OMCOperand zero ];

    NSDecimal decimalValue = [ self.decimalNumber decimalValue ];
    decimalValue._isNegative = !decimalValue._isNegative;

    OMCOperand* newOperand =
        [ OMCOperand operandWithDecimalNumber: [ NSDecimalNumber decimalNumberWithDecimal: decimalValue ]
                                        inAry: self.currentAry
                                     calStyle: self.calStyle ];
                                     
    [ newOperand setWaitingForFloatNumber: [ self.numericString contains: OMCDot ] ];

    return newOperand;
    }

- ( instancetype ) pow: ( OMCOperand* )_Exponent
    {
    double exponent = [ _Exponent.decimalNumber doubleValue ];
    double result = pow( self.decimalNumber.doubleValue, exponent );

    OMCOperand* newOperand = [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                                      inAry: self.currentAry
                                                   calStyle: self.calStyle ];
    return newOperand;
    }

- ( instancetype ) square
    {
    return [ self multiply: self ];
    }

- ( instancetype ) cube
    {
    return [ [ self square ] multiply: self ];
    }

- ( instancetype ) sqrt
    {
    double result = sqrt( self.decimalNumber.doubleValue );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

- ( instancetype ) percent
    {
    OMCOperand* oneHundred = [ OMCOperand operandWithString: @"100" inAry: self.currentAry calStyle: self.calStyle ];
    OMCOperand* resultOperand = [ self divide: oneHundred ];
    [ resultOperand setCurrentAry: self.currentAry ];
    [ resultOperand setCalStyle: self.calStyle ];

    return resultOperand;
    }

- ( instancetype ) reciprocal
    {
    OMCOperand* resultOperand = [ [ OMCOperand one ] divide: self ];
    [ resultOperand setCurrentAry: self.currentAry ];
    [ resultOperand setCalStyle: self.calStyle ];

    return resultOperand;
    }

/* Computes the natural (base 2) logarithm of current value */
- ( instancetype ) log2
    {
    double result = log2( self.decimalNumber.doubleValue );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes the natural (base 10) logarithm of current value */
- ( instancetype ) log10
    {
    double result = log10( self.decimalNumber.doubleValue );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes the natural (base e) logarithm of current value */
- ( instancetype ) naturalLogarithm
    {
    double result = log( self.decimalNumber.doubleValue  );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes the sine of current value (measured in radians) */
- ( instancetype ) sin
    {
    double result = sin( self.decimalNumber.doubleValue );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes the cosine of current value (measured in radians) */
- ( instancetype ) cos
    {
    double result = cos( self.decimalNumber.doubleValue );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes the tangent of current value (measured in radians) */
- ( instancetype ) tan
    {
    double result = tan( self.decimalNumber.doubleValue );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes hyperbolic sine of current value */
- ( instancetype ) sinh
    {
    double result = sinh( self.decimalNumber.doubleValue );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes hyperbolic cosine of current value */
- ( instancetype ) cosh
    {
    double result = cosh( self.decimalNumber.doubleValue );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes hyperbolic tangent of current value */
- ( instancetype ) tanh
    {
    double result = tanh( self.decimalNumber.doubleValue );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
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
            {
            decimalForm = [ NSString stringWithFormat: @"%@", [ self.decimalNumber description ] ];

            if ( self.isWaitingForFloatNumber && ( [ self decimalPlaces ] == 0 ) )
                decimalForm = [ decimalForm stringByAppendingString: OMCDot ];
            } break;

    case OMCProgrammerStyle:
            {
            decimalForm = [ NSString stringWithFormat: @"%lu", [ self.decimalNumber unsignedIntegerValue ] ];
            } break;
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
                NSBeep();

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

            if ( _Ary == OMCDecimal )           baseNumber = 10;
                else if ( _Ary == OMCOctal )    baseNumber = 8;
                else if ( _Ary == OMCHex )      baseNumber = 16;

            NSDecimalNumber* digitNumeric = [ NSDecimalNumber decimalNumberWithString: [ NSString stringWithFormat: @"%ld", _Digit ] ];
            NSDecimalNumber* exponent = [ NSDecimalNumber decimalNumberWithString: [ NSString stringWithFormat: @"%g", pow( ( double )baseNumber, ( double )_Count ) ] ];

            NSDecimalNumberHandler* roundUpBehavior = [ NSDecimalNumberHandler roundUpBehavior ];
            NSDecimalNumberHandler* roundDownBehavior = [ NSDecimalNumberHandler roundDownBehavior ];

            /* TODO: To be graceful */

            NSDecimalNumber* newNumeric = nil;

            /* The initial numeric, and it is waiting for testing of consistency, so the value may not be a final value */
            newNumeric = [ [ self.decimalNumber decimalNumberBySubtracting: digitNumeric ] decimalNumberByDividingBy: exponent withBehavior: roundUpBehavior ];

            /* This operand is just for testing of consistency! */
            OMCOperand* operandJustForTestingConsistency = [ OMCOperand operandWithDecimalNumber: newNumeric inAry: self.currentAry calStyle: self.calStyle ];

            /* If inconsistent due to round up... */
            NSString* theCorrectFormAfterDeletingTheLastDigit = [ self.description substringToIndex: self.description.length - 1 ];
            if ( ![ operandJustForTestingConsistency.description isEqualToString: theCorrectFormAfterDeletingTheLastDigit ] )
                /* ...round down */
                newNumeric = [ [ self.decimalNumber decimalNumberBySubtracting: digitNumeric ] decimalNumberByDividingBy: exponent withBehavior: roundDownBehavior ];

            /* ^ It's double insurance, it's very useful, but it's very ugly. Hmmm...I admit that. ^ */

            [ self setDecimalNumber: newNumeric ];

            OMCOperand* resultOperand = [ OMCOperand operandWithDecimalNumber: newNumeric inAry: self.currentAry calStyle: self.calStyle ];
            [ self.numericString replaceAllWithString: [ resultOperand numericString ] ];
            } break;
        }
    }

- ( BOOL ) isZero
    {
    return [ self.decimalNumber compare: [ NSDecimalNumber zero ] ] == NSOrderedSame;
    }

- ( void ) zeroed
    {
    if ( self.isWaitingForFloatNumber )
        self.isWaitingForFloatNumber = NO;

    if ( self.isInMemory )
        self.isInMemory = NO;

    self.decimalNumber = [ NSDecimalNumber zero ];

    NSString* zeroString = nil;
    if ( self.currentAry == OMCProgrammerStyle )
        zeroString = @"0x0";
    else
        zeroString = @"0";

    [ self.numericString replaceAllWithString: zeroString ];
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
    if ( self.numericString.length == 0 )
        [ self.numericString replaceAllWithString: @"0" ];

    self.decimalNumber = [ NSDecimalNumber decimalNumberWithString: self.numericString ];
    }

- ( NSString* ) _numericStringInAry: ( OMCAry )_Ary
    {
    if ( [ self.exceptionCarried isEqualToString: OMCOperandDivideByZeroException ] )
        return @"DivByZero";

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

    OMCOperand* resultOperand = [ OMCOperand operandWithDecimalNumber: resultDecimal
                                                                inAry: self.currentAry
                                                             calStyle: self.calStyle ];
    return resultOperand;
    }

- ( OMCOperand* ) subtract: ( OMCOperand* )_Rhs
    {
    NSDecimalNumber* resultDecimal = [ self.decimalNumber decimalNumberBySubtracting: _Rhs.decimalNumber
                                                                        withBehavior: self ];

    OMCOperand* resultOperand = [ OMCOperand operandWithDecimalNumber: resultDecimal
                                                                inAry: self.currentAry
                                                             calStyle: self.calStyle ];
    return resultOperand;
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

// NSDecimalNumberHandler + OMCOperand
@implementation NSDecimalNumberHandler ( OMCOperand )

+ ( instancetype ) roundUpBehavior
    {
    return [ NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode: NSRoundUp
                                                                   scale: 0
                                                        raiseOnExactness: NO
                                                         raiseOnOverflow: NO
                                                        raiseOnUnderflow: NO
                                                     raiseOnDivideByZero: NO ];
    }

+ ( instancetype ) roundDownBehavior
    {
    return [ NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode: NSRoundDown
                                                                   scale: 0
                                                        raiseOnExactness: NO
                                                         raiseOnOverflow: NO
                                                        raiseOnUnderflow: NO
                                                     raiseOnDivideByZero: NO ];
    }

@end // NSDecimalNumberHandler + OMCOperand

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