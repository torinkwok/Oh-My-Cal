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

#import <Cocoa/Cocoa.h>

// OMCNumber class
@interface OMCNumber : NSObject
    {
@private
    NSUInteger  _unsignedIntegerValue;
    double      _doubleValue;
    }

@property ( nonatomic, assign ) NSUInteger  unsignedIntegerValue;
@property ( nonatomic, assign ) double      doubleValue;

+ ( OMCNumber* ) numberWithUnsignedInteger: ( NSUInteger )_UnsignedInteger;
+ ( OMCNumber* ) numberWithDouble: ( double )_DoubleVal;

@end // OMCNumber

// OMCOperand class
@interface OMCOperand : NSObject
    {
@private
    OMCNumber* _baseNumber;
    NSDecimalNumber* _decimalNumber;

    NSString* _inOctal;
    NSString* _inDecimal;
    NSString* _inHex;

    OMCCalStyle _calStyle;

    BOOL _isWaitingForFloatNumber;  // TRUE only after user pressing the `.` button
    }

@property ( nonatomic, retain ) OMCNumber* baseNumber;
@property ( nonatomic, retain ) NSDecimalNumber* decimalNumber;

@property ( nonatomic, copy, readonly ) NSString* inOctal;
@property ( nonatomic, copy, readonly ) NSString* inDecimal;
@property ( nonatomic, copy, readonly ) NSString* inHex;

@property ( nonatomic, assign ) OMCCalStyle calStyle;

@property ( nonatomic, assign, setter = setWaitingForFloatNumber: ) BOOL isWaitingForFloatNumber;

+ ( id ) operandWithNumber: ( OMCNumber* )_Number;

- ( void ) appendDigit: ( NSInteger )_Digit
                 count: ( NSInteger )_Count
                   ary: ( OMCAry )_Ary;

- ( void ) deleteDigit: ( NSInteger )_Digit
                 count: ( NSInteger )_Count
                   ary: ( OMCAry )_Ary;

- ( BOOL ) isZero;

@end // OMCOperand class

// OMCOperand + OMCDecimalNumberBehaviors
@interface OMCOperand ( OMCDecimalNumberBehaviors ) <NSDecimalNumberBehaviors>

- ( short ) scale;

- ( NSRoundingMode ) roundingMode;

- ( NSDecimalNumber* ) exceptionDuringOperation: ( SEL )_OperationMethod
                                          error: ( NSCalculationError )_Error
                                    leftOperand: ( NSDecimalNumber* )_LhsOperand
                                   rightOperand: ( NSDecimalNumber* )_RhsOperand;

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