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

@synthesize calStyle = _calStyle;

@synthesize isWaitingForFloatNumber = _isWaitingForFloatNumber;

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
    return [ NSString stringWithFormat: @"%lu", self.baseNumber.unsignedIntegerValue ];
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

    switch ( self.calStyle )
        {
    case OMCBasicStyle:
            {
            double currentNumber = [ self baseNumber ].doubleValue;

            if ( !self.isWaitingForFloatNumber )
                self.baseNumber =
                    [ NSNumber numberWithDouble: ( NSUInteger )( currentNumber * pow( ( double )baseNumber, ( double )_Count ) + _Digit ) ];
            } break;

    case OMCScientificStyle:    break;

    case OMCProgrammerStyle:
            {
            NSUInteger currentNumber = [ self baseNumber ].unsignedIntegerValue;

            if ( _Ary == OMCDecimal )           baseNumber = 10;
                else if ( _Ary == OMCOctal )    baseNumber = 8;
                else if ( _Ary == OMCHex )      baseNumber = 16;

            self.baseNumber =
                [ NSNumber numberWithUnsignedInteger: ( NSUInteger )( currentNumber * pow( ( double )baseNumber, ( double )_Count ) + _Digit ) ];
            } break;
        }
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
                [ NSNumber numberWithUnsignedInteger: ( NSUInteger )( ( currentNumber - _Digit ) / pow( ( double )baseNumber, ( double )_Count ) ) ];
            } break;
        }
    }

- ( BOOL ) isZero
    {
    return [ self baseNumber ].unsignedIntegerValue == 0;
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