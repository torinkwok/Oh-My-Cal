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

// OMCNumber class
@implementation OMCNumber

@synthesize unsignedIntegerValue = _unsignedIntegerValue;
@synthesize doubleValue = _doubleValue;

#pragma mark Initializers & Dealloactors
- ( id ) initWithUnsignedInteger: ( NSUInteger )_UnsignedInteger
    {
    if ( self = [ super init ] )
        {
        self.unsignedIntegerValue = _UnsignedInteger;
        self.doubleValue = ( double )_UnsignedInteger;
        }

    return self;
    }

- ( id ) initWithDouble: ( double )_DoubleVal
    {
    if ( self = [ super init ] )
        {
        self.unsignedIntegerValue = ( NSUInteger )_DoubleVal;
        self.doubleValue = _DoubleVal;
        }

    return self;
    }

+ ( OMCNumber* ) numberWithUnsignedInteger: ( NSUInteger )_UnsignedInteger
    {
    return [ [ [ [ self class ] alloc ] initWithUnsignedInteger: _UnsignedInteger ] autorelease ];
    }

+ ( OMCNumber* ) numberWithDouble: ( double )_DoubleVal
    {
    return [ [ [ [ self class ] alloc ] initWithDouble: _DoubleVal ] autorelease ];
    }

@end // OMCNumber

// OMCOperand class
@implementation OMCOperand

@synthesize baseNumber = _baseNumber;
@synthesize decimalNumber = _decimalNumber;

@synthesize inOctal = _inOctal;
@synthesize inDecimal = _inDecimal;
@synthesize inHex = _inHex;

@synthesize calStyle = _calStyle;

@synthesize isWaitingForFloatNumber = _isWaitingForFloatNumber;

#pragma mark Initializers & Deallocators
+ ( id ) operandWithNumber: ( OMCNumber* )_Number
    {
    return [ [ [ [ self class ] alloc ] initWithNumber: _Number ] autorelease ];
    }

- ( id ) initWithNumber: ( OMCNumber* )_Number
    {
    if ( self = [ super init ] )
        {
        self.baseNumber = _Number;

        self.calStyle = OMCBasicStyle;
        self.isWaitingForFloatNumber = NO;
        }

    return self;
    }

#pragma mark Accessors
- ( NSString* ) inOctal
    {
    return [ NSString stringWithFormat: @"%lo", self.baseNumber.unsignedIntegerValue ];
    }

- ( NSString* ) inDecimal
    {
    NSString* decimalForm = nil;

    switch ( self.calStyle )
        {
    case OMCBasicStyle:
    case OMCScientificStyle:
        decimalForm = [ NSString stringWithFormat: @"%g", self.baseNumber.doubleValue ];
        break;

    case OMCProgrammerStyle:
        decimalForm = [ NSString stringWithFormat: @"%lu", self.baseNumber.unsignedIntegerValue ];
        break;
        }

    return decimalForm;
    }

- ( NSString* ) inHex
    {
    NSString* hexValueInUppercase = [ NSString stringWithFormat: @"%lx", self.baseNumber.unsignedIntegerValue ].uppercaseString;
    return [ NSString stringWithFormat: @"0x%@", hexValueInUppercase ];
    }

- ( void ) appendDigit: ( NSInteger )_Digit
                 count: ( NSInteger )_Count
                   ary: ( OMCAry )_Ary
    {
    NSUInteger baseNumber = 10;
    NSLog( @"%d", [ self decimalPlacesForAFloatNumber: 43.2342427878798] );

    switch ( self.calStyle )
        {
    case OMCBasicStyle:
            {
            double currentNumber = [ self baseNumber ].doubleValue;

            if ( _Digit == -1 )
                self.isWaitingForFloatNumber = YES;
            else
                {
                if ( self.isWaitingForFloatNumber )
                    {
                    int decimalPlaces = [ self decimalPlacesForAFloatNumber: currentNumber ];

                    if ( decimalPlaces >= 5 )
                        {
                        NSBeep();
                        break;
                        }

                    self.baseNumber = [ OMCNumber numberWithDouble: ( currentNumber + ( double )_Digit / pow( 10, decimalPlaces + 1 ) ) ];
                    }
                else if ( !self.isWaitingForFloatNumber )
                    self.baseNumber = [ OMCNumber numberWithDouble: ( NSUInteger )( currentNumber * pow( ( double )baseNumber, ( double )_Count ) + _Digit ) ];
                }
            } break;

    case OMCScientificStyle:    break;

    case OMCProgrammerStyle:
            {
            NSUInteger currentNumber = [ self baseNumber ].unsignedIntegerValue;

            if ( _Ary == OMCDecimal )           baseNumber = 10;
                else if ( _Ary == OMCOctal )    baseNumber = 8;
                else if ( _Ary == OMCHex )      baseNumber = 16;

            self.baseNumber =
                [ OMCNumber numberWithUnsignedInteger: ( NSUInteger )( currentNumber * pow( ( double )baseNumber, ( double )_Count ) + _Digit ) ];
            } break;
        }
    }

- ( int ) decimalPlacesForAFloatNumber: ( double )_FloatNumber
    {
    /* Retrieve the fractional part of currentNumber
     * for example: 10.34, the fractional part is 0.34 */
    NSString* fractionalPart = [ NSString stringWithFormat: @"%.15g", _FloatNumber - ( int )_FloatNumber ];

//    NSString* fuckString = @"523542.5255235262";
//    double fuckDouble = [ fuckString doubleValue ];
    NSLog( @"%.20g", 42424.342424000 );

    /* Decimal Places
     * for example: for 5, decimalPlaces is 1
     * for 6.5, decimalPlaces is 2
     * for 7.753 decimalPlaces is 4 */
    int decimalPlaces = 0;
    while ( true )
        {
        if ( ( fractionalPart.doubleValue - ( int )fractionalPart.doubleValue ) == 0.f )
            break;
        else
            {
            fractionalPart = [ NSString stringWithFormat: @"%g", fractionalPart.doubleValue * 10 ];
            decimalPlaces++;
            }
        }

    return decimalPlaces;
    }

- ( void ) deleteDigit: ( NSInteger )_Digit
                 count: ( NSInteger )_Count
                   ary: ( OMCAry )_Ary
    {
    switch ( self.calStyle )
        {
    case OMCBasicStyle:         break;
    case OMCScientificStyle:    break;
    case OMCProgrammerStyle:
            {
            NSUInteger currentNumber = [ self baseNumber ].unsignedIntegerValue;

            NSUInteger baseNumber = 0;
            if ( _Ary == OMCDecimal )           baseNumber = 10;
                else if ( _Ary == OMCOctal )    baseNumber = 8;
                else if ( _Ary == OMCHex )      baseNumber = 16;

            self.baseNumber =
                [ OMCNumber numberWithUnsignedInteger: ( NSUInteger )( ( currentNumber - _Digit ) / pow( ( double )baseNumber, ( double )_Count ) ) ];
            } break;
        }
    }

- ( BOOL ) isZero
    {
    return [ self baseNumber ].unsignedIntegerValue == 0;
    }

@end // OMCOperand class

// OMCOperand + OMCDecimalNumberBehaviors
@implementation OMCOperand ( OMCDecimalNumberBehaviors )

- ( short ) scale
    {
    return NSDecimalNoScale;
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
    return nil;
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