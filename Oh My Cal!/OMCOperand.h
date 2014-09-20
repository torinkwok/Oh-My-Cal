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

#import <Foundation/Foundation.h>

#define UNSIGNED_INT_OPERAND_MAX_DIGIT  17

NSString extern* const OMCDot;

// Exception names
NSString extern* const OMCOperandExactnessException;
NSString extern* const OMCOperandOverflowException;
NSString extern* const OMCOperandUnderflowException;
NSString extern* const OMCOperandDivideByZeroException;

// OMCOperand class
@interface OMCOperand : NSObject <NSCopying>
    {
@private
    NSDecimalNumber* _decimalNumber;
    NSMutableString* _numericString;

    OMCCalStyle _calStyle;
    OMCAry      _currentAry;

    BOOL _isWaitingForFloatNumber;  // TRUE only after user pressing the `.` button

#if DEBUG   // Just for testing
    NSDecimalNumberHandler* _decimalNumberHandler;
#endif
    }

@property ( nonatomic, retain ) NSDecimalNumber* decimalNumber;
@property ( nonatomic, retain ) NSMutableString* numericString;

@property ( nonatomic, copy, readonly ) NSString* inOctal;
@property ( nonatomic, copy, readonly ) NSString* inDecimal;
@property ( nonatomic, copy, readonly ) NSString* inHex;

@property ( nonatomic, assign, readonly ) NSUInteger unsignedInteger;

@property ( nonatomic, assign ) OMCCalStyle calStyle;
@property ( nonatomic, assign ) OMCAry currentAry;

@property ( nonatomic, assign, readonly ) int decimalPlaces;

@property ( nonatomic, assign, setter = setWaitingForFloatNumber: ) BOOL isWaitingForFloatNumber;

@property ( nonatomic, retain ) NSDecimalNumberHandler* decimalNumberHandler;

#pragma mark Initializers
+ ( id ) operandWithDecimalNumber: ( NSDecimalNumber* )_DecimalNumber;

+ ( id ) operandWithDecimalNumber: ( NSDecimalNumber* )_DecimalNumber
                            inAry: ( OMCAry )_Ary
                         calStyle: ( OMCCalStyle )_CalStyle;

+ ( id ) operandWithUnsignedInteger: ( NSUInteger )_UnsignedInteger;

+ ( id ) operandWithUnsignedInteger: ( NSUInteger )_UnsignedInteger
                              inAry: ( OMCAry )_Ary
                           calStyle: ( OMCCalStyle )_CalStyle;

+ ( id ) zero;
+ ( id ) one;

- ( NSComparisonResult ) compare: ( OMCOperand* )_Rhs;

#pragma mark Degit Operations
- ( void ) appendDigit: ( NSInteger )_Digit
                 count: ( NSInteger )_Count
                   ary: ( OMCAry )_Ary;

- ( void ) deleteDigit: ( NSInteger )_Digit
                 count: ( NSInteger )_Count
                   ary: ( OMCAry )_Ary;

- ( BOOL ) isZero;
- ( void ) zeroed;

#pragma mark Calculation
- ( OMCOperand* ) add: ( OMCOperand* )_Rhs;
- ( OMCOperand* ) subtract: ( OMCOperand* )_Rhs;
- ( OMCOperand* ) multiply: ( OMCOperand* )_Rhs;
- ( OMCOperand* ) divide: ( OMCOperand* )_Rhs;
- ( OMCOperand* ) mod: ( OMCOperand* )_Rhs;

- ( OMCOperand* ) factorial;

- ( OMCOperand* ) bitwiseAnd: ( OMCOperand* )_Rhs;
- ( OMCOperand* ) bitwiseOr: ( OMCOperand* )_Rhs;
- ( OMCOperand* ) bitwiseNor: ( OMCOperand* )_Rhs;
- ( OMCOperand* ) bitwiseXor: ( OMCOperand* )_Rhs;
- ( OMCOperand* ) Lsh: ( OMCOperand* )_Rhs;
- ( OMCOperand* ) Rsh: ( OMCOperand* )_Rhs;

- ( OMCOperand* ) RoL;
- ( OMCOperand* ) RoR;

- ( OMCOperand* ) flipBytes;

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