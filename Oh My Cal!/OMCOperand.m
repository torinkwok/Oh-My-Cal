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

// OMCOperand class
@implementation OMCOperand

@synthesize baseNumber = _baseNumber;

@synthesize inOctal = _inOctal;
@synthesize inDecimal = _inDecimal;
@synthesize inHex = _inHex;

#pragma mark Initializers & Deallocators
+ ( id ) operandWithNumber: ( NSNumber* )_Number
    {
    return [ [ [ [ self class ] alloc ] initWithNumber: _Number ] autorelease ];
    }

- ( id ) initWithNumber: ( NSNumber* )_Number
    {
    if ( self = [ super init ] )
        {
        self.baseNumber = _Number;
        }

    return self;
    }

#pragma mark Accessors
- ( NSString* ) inOctal
    {
    return [ NSString stringWithFormat: @"%lo", self.baseNumber.integerValue ];
    }

- ( NSString* ) inDecimal
    {
    return [ NSString stringWithFormat: @"%ld", self.baseNumber.integerValue ];
    }

- ( NSString* ) inHex
    {
    NSString* hexValueInUppercase = [ NSString stringWithFormat: @"%lx", self.baseNumber.integerValue ].uppercaseString;
    return [ NSString stringWithFormat: @"0x%@", hexValueInUppercase ];
    }

- ( void ) appendDigit: ( NSInteger )_Digit
                 count: ( NSInteger )_Count
                   ary: ( OMCAry )_Ary
    {
    NSUInteger currentNumber = [ self baseNumber ].integerValue;
    NSUInteger baseNumber = 0;

    if ( _Ary == OMCDecimal )           baseNumber = 10;
        else if ( _Ary == OMCOctal )    baseNumber = 8;
        else if ( _Ary == OMCHex )      baseNumber = 16;

    self.baseNumber =
        [ NSNumber numberWithUnsignedInteger: ( NSUInteger )( currentNumber * pow( ( double )baseNumber, ( double )_Count ) + _Digit ) ];
    }

- ( void ) deleteDigit: ( NSInteger )_Digit
                 count: ( NSInteger )_Count
                   ary: ( OMCAry )_Ary
    {
    NSUInteger currentNumber = [ self baseNumber ].integerValue;
    NSUInteger baseNumber = 0;

    if ( _Ary == OMCDecimal )           baseNumber = 10;
        else if ( _Ary == OMCOctal )    baseNumber = 8;
        else if ( _Ary == OMCHex )      baseNumber = 16;

    self.baseNumber =
        [ NSNumber numberWithUnsignedInteger: ( NSUInteger )( ( currentNumber - _Digit ) / pow( ( double )baseNumber, ( double )_Count ) ) ];
    }

- ( BOOL ) isZero
    {
    return [ self baseNumber ].integerValue == 0;
    }

@end // OMCOperand class

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