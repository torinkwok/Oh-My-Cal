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

NSString* const OMCOperandPboardType = @"individual.TongGuo.Oh-My-Cal.operand";

// Exception names
NSString* const OMCOperandExactnessException = @"OMCOperandExactnessException";
NSString* const OMCOperandOverflowException = @"OMCOperandOverflowException";
NSString* const OMCOperandUnderflowException = @"OMCOperandUnderflowException";
NSString* const OMCOperandDivideByZeroException = @"OMCOperandDivideByZeroException";

// OMCOperand class
@implementation OMCOperand

@synthesize decimalNumber = _decimalNumber;
@synthesize numericString = _numericString;

@dynamic inOctal;
@dynamic inDecimal;
@dynamic inHex;

@dynamic unsignedInteger;

@synthesize calStyle = _calStyle;
@synthesize currentAry = _currentAry;
@dynamic calStyleInString;
@dynamic currentAryInString;

@synthesize isInMemory = _isInMemory;
@dynamic decimalPlaces;

@synthesize isWaitingForFloatNumber = _isWaitingForFloatNumber;

@synthesize exceptionCarried = _exceptionCarried;

@synthesize decimalNumberHandler = _decimalNumberHandler;

#pragma mark Overrides
- ( NSString* ) description
    {
    return [ self _numericStringInAry: self.currentAry ];
    }

- ( NSString* ) debugDescription
    {
    return [ NSString stringWithFormat: @"<%@: %p \"%@\">"
                                      , [ self class ]
                                      , self
                                      , @{ @"Decimal Number" : self.decimalNumber
                                         , @"Numeric String" : self.numericString
                                         , @"Description" : self.description
                                         , @"Unsigned Integer" : @( self.unsignedInteger )
                                         , @"Current Cal Style" : self.calStyleInString
                                         , @"Current Ary" : self.currentAryInString
                                         , @"Is in Memory" : self.isInMemory ? @"YES" : @"NO"
                                         , @"Decimal Places" : @( self.decimalPlaces )
                                         , @"Exception Carried" : self.exceptionCarried
                                         , @"Decimal Number Handler" : self.decimalNumberHandler
                                         } ];
    }

- ( id ) copyWithZone: ( NSZone* )_Zone
    {
    id newOperand = [ [ self class ] operandWithDecimalNumber: [ self.decimalNumber copy ]
                                                        inAry: self.currentAry
                                                     calStyle: self.calStyle ];
    return newOperand;
    }

- ( id ) init
    {
    @throw [ NSException exceptionWithName: NSInternalInconsistencyException
                                    reason: @"Must use factory class methods instead."
                                  userInfo: nil ];
    }

- ( void ) dealloc
    {
    RELEASE_AND_NIL( self->_decimalNumber );
    RELEASE_AND_NIL( self->_numericString );
    RELEASE_AND_NIL( self->_exceptionCarried );
    RELEASE_AND_NIL( self->_decimalNumberHandler );

    [ super dealloc ];
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

- ( NSComparisonResult ) compare: ( OMCOperand* )_Rhs
    {
    return [ self.decimalNumber compare: _Rhs.decimalNumber ];
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
                else
                    NSBeep();
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

- ( BOOL ) isNaN
    {
    return [ self.decimalNumber compare: [ NSDecimalNumber notANumber ] ] == NSOrderedSame;
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
        {
        NSBeep();
        return;
        }

    [ self.numericString deleteTheLastCharacter ];

    /* If the numeric string is empty... */
    if ( self.numericString.length == 0
            /* or there is only a negative sign in numeric string... */
            || ( ( self.numericString.length == 1 ) && [ self.numericString isEqualToString: @"-" ] )
            /* or there is a "-0" in numeric string... */
            || ( ( self.numericString.length == 2 ) && [ self.numericString isEqualToString: @"-0" ] ) )
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

- ( void ) setCurrentAry: ( OMCAry )_Ary
    {
    if ( self->_currentAry != _Ary )
        {
        self->_currentAry = _Ary;
        [ self.numericString replaceAllWithString: [ self _numericStringInAry: self->_currentAry ] ];
        }
    }

- ( void ) setDecimalNumber: ( NSDecimalNumber* )_DecimalNumber
    {
    if ( self->_decimalNumber != _DecimalNumber )
        {
        [ self->_decimalNumber release ];
        self->_decimalNumber = [ _DecimalNumber retain ];
        }
    }

- ( void ) setCalStyle: ( OMCCalStyle )_CalStyle
    {
    if ( self->_calStyle != _CalStyle )
        {
        self->_calStyle = _CalStyle;

        if ( self->_calStyle == OMCProgrammerStyle )
            {
            NSString* numericStringAfterFlooring = [ NSString stringWithFormat: @"%.16g", floor( self.decimalNumber.doubleValue ) ];
            self.decimalNumber = [ NSDecimalNumber decimalNumberWithString: numericStringAfterFlooring ];
            [ self.numericString replaceAllWithString: [ self _numericStringInAry: self.currentAry ] ];
            }
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

- ( NSString* ) calStyleInString
    {
    NSString* string = nil;
    switch ( self.calStyle )
        {
    case OMCBasicStyle:         string = @"OMCCalStyle";          break;
    case OMCScientificStyle:    string = @"OMCScientificStyle";   break;
    case OMCProgrammerStyle:    string = @"OMCProgrammerStyle";   break;
        }

    return string;
    }

- ( NSString* ) currentAryInString
    {
    NSString* string = nil;
    switch ( self.currentAry )
        {
    case OMCOctal:      string = @"OMCOctal";   break;
    case OMCDecimal:    string = @"OMCDecimal"; break;
    case OMCHex:        string = @"OMCHex";     break;
        }

    return string;
    }

- ( NSUInteger ) unsignedInteger
    {
    return self.decimalNumber.unsignedIntegerValue;
    }

@end // OMCOperand class

#pragma mark Unitary Operations
@implementation OMCOperand ( OMCOperand_UnitaryOperations )

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
    return newOperand;
    }

- ( instancetype ) pow: ( OMCOperand* )_Rhs
    {
    double exponent = [ _Rhs.decimalNumber doubleValue ];
    double result = pow( self.decimalNumber.doubleValue, exponent );

    OMCOperand* newOperand = [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                                      inAry: self.currentAry
                                                   calStyle: self.calStyle ];
    return newOperand;
    }

- ( instancetype ) EE: ( OMCOperand* )_Rhs
    {
    OMCOperand* ten = [ OMCOperand operandWithString: @"10" inAry: self.currentAry calStyle: self.calStyle ];

    return [ self multiply: [ ten pow: _Rhs ] ];
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

- ( instancetype ) cubeRoot
    {
    OMCOperand* three = [ OMCOperand operandWithString: @"3" inAry: self.currentAry calStyle: self.calStyle ];
    return [ self pow: [ [ OMCOperand one ] divide: three ] ];
    }

- ( instancetype ) xRoot: ( OMCOperand* )_Rhs
    {
    /* x root = pow( val, 1 / x ) */
    return [ self pow: [ [ OMCOperand one ] divide: _Rhs ] ];
    }

- ( instancetype ) e_x
    {
    return [ [ OMCOperand e ] pow: self ];
    }

- ( instancetype ) _2_x
    {
    OMCOperand* two = [ OMCOperand operandWithString: @"2" ];
    return [ two pow: self ];
    }

- ( instancetype ) _10_x
    {
    OMCOperand* ten = [ OMCOperand operandWithString: @"10" ];
    return [ ten pow: self ];
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
- ( instancetype ) sinWithRadians;
    {
    double result = sin( self.decimalNumber.doubleValue );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes the cosine of current value (measured in radians) */
- ( instancetype ) cosWithRadians
    {
    double result = cos( self.decimalNumber.doubleValue );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes the tangent of current value (measured in radians) */
- ( instancetype ) tanWithRadians
    {
    double result = tan( self.decimalNumber.doubleValue );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes the sine of current value (measured in degrees) */
- ( instancetype ) sinWithDegrees
    {
    double result = sin( self.decimalNumber.doubleValue * PI / 180 );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes the cosine of current value (measured in degrees) */
- ( instancetype ) cosWithDegrees
    {
    double result = cos( self.decimalNumber.doubleValue * PI / 180 );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes the tangent of current value (measured in degrees) */
- ( instancetype ) tanWithDegrees;
    {
    double result = tan( self.decimalNumber.doubleValue * PI / 180 );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes the principal values of the arc sine of current value (measured in radians) */
- ( instancetype ) asinWithRadians
    {
    double result = asin( self.decimalNumber.doubleValue );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes the principal values of the arc cosine of current value (measured in radians) */
- ( instancetype ) acosWithRadians
    {
    double result = acos( self.decimalNumber.doubleValue );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes the principal values of the arc tangent of current value (measured in radians) */
- ( instancetype ) atanWithRadians
    {
    double result = atan( self.decimalNumber.doubleValue );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes the principal values of the arc sine of current value (measured in degrees) */
- ( instancetype ) asinWithDegrees
    {
    double result = asin( self.decimalNumber.doubleValue ) * 180 / PI;

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes the principal values of the arc cosine of current value (measured in degrees) */
- ( instancetype ) acosWithDegrees
    {
    double result = acos( self.decimalNumber.doubleValue ) * 180 / PI;

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes the principal values of the arc tangent of current value (measured in degrees) */
- ( instancetype ) atanWithDegrees
    {
    double result = atan( self.decimalNumber.doubleValue ) * 180 / PI;

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

/* Computes the inverse hyperbolic sine of current value */
- ( instancetype ) asinh
    {
    double result = asinh( self.decimalNumber.doubleValue );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes the inverse hyperbolic cosine of current value */
- ( instancetype ) acosh
    {
    double result = acosh( self.decimalNumber.doubleValue );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

/* Computes the inverse hyperbolic tangent of current value */
- ( instancetype ) atanh
    {
    double result = atanh( self.decimalNumber.doubleValue );

    return [ OMCOperand operandWithString: [ NSString stringWithFormat: @"%.16g", result ]
                                    inAry: self.currentAry
                                 calStyle: self.calStyle ];
    }

- ( instancetype ) RoL
    {
    return [ self Lsh: [ OMCOperand one ] ];
    }

- ( instancetype ) RoR
    {
    return [ self Rsh: [ OMCOperand one ] ];
    }

- ( instancetype ) flipBytes
    {
    return [ OMCOperand operandWithUnsignedInteger: ~self.unsignedInteger
                                             inAry: self.currentAry
                                          calStyle: self.calStyle ];
    }

- ( instancetype ) factorial
    {
    return [ OMCOperand operandWithUnsignedInteger: factorial( self.unsignedInteger )
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

@end // OMCOperand + OMCOperand_UnitaryOperations

#pragma mark Binary Operations
@implementation OMCOperand ( OMCOperand_BinaryOperations )

- ( instancetype ) add: ( OMCOperand* )_Rhs
    {
    NSDecimalNumber* resultDecimal = [ self.decimalNumber decimalNumberByAdding: _Rhs.decimalNumber
                                                                   withBehavior: self ];

    OMCOperand* resultOperand = [ OMCOperand operandWithDecimalNumber: resultDecimal
                                                                inAry: self.currentAry
                                                             calStyle: self.calStyle ];
    return resultOperand;
    }

- ( instancetype ) subtract: ( OMCOperand* )_Rhs
    {
    NSDecimalNumber* resultDecimal = [ self.decimalNumber decimalNumberBySubtracting: _Rhs.decimalNumber
                                                                        withBehavior: self ];

    OMCOperand* resultOperand = [ OMCOperand operandWithDecimalNumber: resultDecimal
                                                                inAry: self.currentAry
                                                             calStyle: self.calStyle ];
    return resultOperand;
    }

- ( instancetype ) multiply: ( OMCOperand* )_Rhs
    {
    NSDecimalNumber* resultDecimal = [ self.decimalNumber decimalNumberByMultiplyingBy: _Rhs.decimalNumber
                                                                          withBehavior: self ];
    return [ OMCOperand operandWithDecimalNumber: resultDecimal
                                           inAry: self.currentAry
                                        calStyle: self.calStyle ];
    }

- ( instancetype ) divide: ( OMCOperand* )_Rhs
    {
    if ( [ _Rhs isZero ] )
        return [ OMCOperand divByZero ];

    NSDecimalNumber* resultDecimal = [ self.decimalNumber decimalNumberByDividingBy: _Rhs.decimalNumber
                                                                       withBehavior: self ];
    return [ OMCOperand operandWithDecimalNumber: resultDecimal
                                           inAry: self.currentAry
                                        calStyle: self.calStyle ];
    }

- ( instancetype ) mod: ( OMCOperand* )_Rhs
    {
    return [ OMCOperand operandWithUnsignedInteger: self.unsignedInteger % _Rhs.unsignedInteger
                                             inAry: self.currentAry
                                          calStyle: self.calStyle ];
    }

- ( instancetype ) bitwiseAnd: ( OMCOperand* )_Rhs
    {
    return [ OMCOperand operandWithUnsignedInteger: self.unsignedInteger & _Rhs.unsignedInteger
                                             inAry: self.currentAry
                                          calStyle: self.calStyle ];
    }

- ( instancetype ) bitwiseOr: ( OMCOperand* )_Rhs
    {
    return [ OMCOperand operandWithUnsignedInteger: self.unsignedInteger | _Rhs.unsignedInteger
                                             inAry: self.currentAry
                                          calStyle: self.calStyle ];
    }
    
- ( instancetype ) bitwiseNor: ( OMCOperand* )_Rhs
    {
    return [ OMCOperand operandWithUnsignedInteger: ~( self.unsignedInteger | _Rhs.unsignedInteger )
                                             inAry: self.currentAry
                                          calStyle: self.calStyle ];
    }

- ( instancetype ) bitwiseXor: ( OMCOperand* )_Rhs
    {
    return [ OMCOperand operandWithUnsignedInteger: self.unsignedInteger ^ _Rhs.unsignedInteger
                                             inAry: self.currentAry
                                          calStyle: self.calStyle ];
    }

- ( instancetype ) Lsh: ( OMCOperand* )_Rhs
    {
    return [ OMCOperand operandWithUnsignedInteger: self.unsignedInteger << _Rhs.unsignedInteger
                                             inAry: self.currentAry
                                          calStyle: self.calStyle ];
    }

- ( instancetype ) Rsh: ( OMCOperand* )_Rhs
    {
    return [ OMCOperand operandWithUnsignedInteger: self.unsignedInteger >> _Rhs.unsignedInteger
                                             inAry: self.currentAry
                                          calStyle: self.calStyle ];
    }

@end // OMCOperand + OMCOperand_BinaryOperations

#pragma mark Decimal Number Behaviors
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

#pragma mark Pasteboard Support
@implementation OMCOperand ( OMCPasteboardSupport )

NSString static* kDecimalNumberKey = @"kDecimalNumberKey";
NSString static* kNumericStringKey = @"kNumericStringKey";
NSString static* kCalStyleKey = @"kCalStyleKey";
NSString static* kCurrentAryKey = @"kCurrentAryKey";
NSString static* kExceptionCarriedKey = @"kExceptionCarriedKey";

- ( id ) initWithCoder: ( NSCoder* )_Coder
    {
    return [ self initWithDecimalNumber: [ _Coder decodeObjectForKey: kDecimalNumberKey ]
                                  inAry: ( OMCAry )[ _Coder decodeIntForKey: kCurrentAryKey ]
                               calStyle: ( OMCCalStyle )[ _Coder decodeIntForKey: kCalStyleKey ] ];
    }

- ( void ) encodeWithCoder: ( NSCoder* )_Coder
    {
    [ _Coder encodeObject: [ self decimalNumber ] forKey: kDecimalNumberKey ];
    [ _Coder encodeObject: [ self numericString ] forKey: kNumericStringKey ];
    [ _Coder encodeInt: ( int )[ self calStyle ] forKey: kCalStyleKey ];
    [ _Coder encodeInt: ( int )[ self currentAry ] forKey: kCurrentAryKey ];
    [ _Coder encodeObject: [ self exceptionCarried ] forKey: kExceptionCarriedKey ];
    }

// Conforms <NSPasteboardWriting> protocol
- ( NSArray* ) writableTypesForPasteboard: ( NSPasteboard* )_Pboard
    {
    NSArray static* writableTypes = nil;

    if ( !writableTypes )
        writableTypes = [ @[ OMCOperandPboardType, NSPasteboardTypeString ] retain ];

    return writableTypes;
    }

- ( id ) pasteboardPropertyListForType: ( NSString* )_Type
    {
    id propertyListObject = nil;

    if ( [ _Type isEqualToString: OMCOperandPboardType ] )
        propertyListObject = [ NSKeyedArchiver archivedDataWithRootObject: self ];

    else if ( [ _Type isEqualToString: NSPasteboardTypeString ] )
        propertyListObject = [ self.numericString pasteboardPropertyListForType: NSPasteboardTypeString ];

    return propertyListObject;
    }

// Conforms <NSPasteboardReading> protocol
+ ( NSArray* ) readableTypesForPasteboard: ( NSPasteboard* )_Pboard
    {
    NSArray static* readableTypes = nil;

    if ( !readableTypes )
        readableTypes = [ @[ OMCOperandPboardType, NSPasteboardTypeString ] retain ];

    return readableTypes;
    }

+ ( NSPasteboardReadingOptions ) readingOptionsForType: ( NSString* )_Type
                                            pasteboard: ( NSPasteboard* )_Pboard
    {
    NSPasteboardReadingOptions readingOptions = 0;

    if ( [ _Type isEqualToString: OMCOperandPboardType ] )
        readingOptions = NSPasteboardReadingAsKeyedArchive;

    else if ( [ _Type isEqualToString: NSPasteboardTypeString ] )
        readingOptions = NSPasteboardReadingAsPropertyList;

    return readingOptions;
    }

- ( id ) initWithPasteboardPropertyList: ( id )_PropertyList
                                 ofType: ( NSString* )_Type
    {
    if ( [ _Type isEqualToString: NSPasteboardTypeString ] )
        {
        NSString* valueString = ( NSString* )_PropertyList;
        NSString* prefixForHex = @"0x";

        NSDecimalNumber* theDecimalNumber = nil;

        if ( [ valueString hasPrefix: prefixForHex ] )
            {
            NSNumber* unsignedNumber = [ NSNumber numberWithUnsignedInteger: OMCOperandConvertHexToDecimal( valueString ) ];
            theDecimalNumber = [ NSDecimalNumber decimalNumberWithString: [ unsignedNumber stringValue ] ];
            }
        else
            theDecimalNumber = [ NSDecimalNumber decimalNumberWithString: _PropertyList ];

        return [ self initWithDecimalNumber: theDecimalNumber ];
        }

    return nil;
    }

- ( BOOL ) writeToPasteboard: ( NSPasteboard* )_Pboard
    {
    [ _Pboard clearContents ];
    return [ _Pboard writeObjects: @[ self ] ];
    }

@end // OMCOperand +OMCCodingBehaviors

#pragma mark NSDecimalNumberHandler + OMCOperand
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

#pragma mark Utility Functions
BOOL isCharInAtoE( NSString* );
NSUInteger mapHexAlphaToDecimalNumeric( NSString* _AlphaInHexNumeric );

NSUInteger OMCOperandConvertHexToDecimal( NSString* _HexNumeric )
    {
    NSString* prefixForHex = @"0x";
    if ( ![ _HexNumeric hasPrefix: prefixForHex ] )
        return NAN;

    NSString* hexNumericWithoutPrefix = [ _HexNumeric substringFromIndex: prefixForHex.length ];

    NSUInteger resultInDecimal = 0U;
    double exponent = 0.f;
    for ( int index = ( int )hexNumericWithoutPrefix.length - 1; index >= 0; index-- )
        {
        NSString* stringForCurrentDigit = [ hexNumericWithoutPrefix substringWithRange: NSMakeRange( index, 1 ) ];
        NSUInteger valueForCurrentDigit = 0U;

        if ( isCharInAtoE( stringForCurrentDigit ) )
            valueForCurrentDigit = mapHexAlphaToDecimalNumeric( stringForCurrentDigit );
        else
            valueForCurrentDigit = ( NSUInteger )[ stringForCurrentDigit integerValue ];

        resultInDecimal += valueForCurrentDigit * ( NSUInteger )pow( 16, exponent++ );
        }

    return resultInDecimal;
    }

BOOL isCharInAtoE( NSString* _Char )
    {
    if ( COMPARE_WITH_CASE_INSENSITIVE( _Char, @"A" )
            || COMPARE_WITH_CASE_INSENSITIVE( _Char, @"B" )
            || COMPARE_WITH_CASE_INSENSITIVE( _Char, @"C" )
            || COMPARE_WITH_CASE_INSENSITIVE( _Char, @"D" )
            || COMPARE_WITH_CASE_INSENSITIVE( _Char, @"E" )
            || COMPARE_WITH_CASE_INSENSITIVE( _Char, @"F" ) )
        return YES;
    else
        return NO;
    }

NSUInteger mapHexAlphaToDecimalNumeric( NSString* _AlphaInHexNumeric )
    {
    if ( COMPARE_WITH_CASE_INSENSITIVE( _AlphaInHexNumeric, @"A" ) )
        return 10;

    if ( COMPARE_WITH_CASE_INSENSITIVE( _AlphaInHexNumeric, @"B" ) )
        return 11U;

    if ( COMPARE_WITH_CASE_INSENSITIVE( _AlphaInHexNumeric, @"C" ) )
        return 12U;

    if ( COMPARE_WITH_CASE_INSENSITIVE( _AlphaInHexNumeric, @"D" ) )
        return 13U;

    if ( COMPARE_WITH_CASE_INSENSITIVE( _AlphaInHexNumeric, @"E" ) )
        return 14U;

    if ( COMPARE_WITH_CASE_INSENSITIVE( _AlphaInHexNumeric, @"F" ) )
        return 15U;

    return NAN;
    }

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