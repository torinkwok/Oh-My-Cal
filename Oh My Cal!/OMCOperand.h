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

#define UNSIGNED_INT_OPERAND_MAX_DIGIT  16

NSString extern* const OMCDot;

NSString extern* const OMCOperandPboardType;

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

    NSString* _exceptionCarried;
    }

@property ( nonatomic, retain ) NSDecimalNumber* decimalNumber;
@property ( nonatomic, retain ) NSMutableString* numericString;

@property ( nonatomic, copy, readonly ) NSString* inOctal;
@property ( nonatomic, copy, readonly ) NSString* inDecimal;
@property ( nonatomic, copy, readonly ) NSString* inHex;

@property ( nonatomic, assign, readonly ) NSUInteger unsignedInteger;

@property ( nonatomic, assign ) OMCCalStyle calStyle;
@property ( nonatomic, assign ) OMCAry currentAry;
@property ( nonatomic, copy, readonly ) NSString* calStyleInString;
@property ( nonatomic, copy, readonly ) NSString* currentAryInString;

@property ( nonatomic, assign, setter = setInMemory: ) BOOL isInMemory;

@property ( nonatomic, assign, readonly ) int decimalPlaces;

@property ( nonatomic, assign, setter = setWaitingForFloatNumber: ) BOOL isWaitingForFloatNumber;

@property ( nonatomic, copy ) NSString* exceptionCarried;

@property ( nonatomic, retain ) NSDecimalNumberHandler* decimalNumberHandler;

#pragma mark Initializers
+ ( instancetype ) operandWithDecimalNumber: ( NSDecimalNumber* )_DecimalNumber;

+ ( instancetype ) operandWithDecimalNumber: ( NSDecimalNumber* )_DecimalNumber
                                      inAry: ( OMCAry )_Ary
                                   calStyle: ( OMCCalStyle )_CalStyle;

+ ( instancetype ) operandWithString: ( NSString* )_NumericString;

+ ( instancetype ) operandWithString: ( NSString* )_NumericString
                               inAry: ( OMCAry )_Ary
                            calStyle: ( OMCCalStyle )_CalStyle;

+ ( instancetype ) operandWithUnsignedInteger: ( NSUInteger )_UnsignedInteger;

+ ( instancetype ) operandWithUnsignedInteger: ( NSUInteger )_UnsignedInteger
                                        inAry: ( OMCAry )_Ary
                                     calStyle: ( OMCCalStyle )_CalStyle;

+ ( instancetype ) zero;
+ ( instancetype ) one;
+ ( instancetype ) divByZero;
+ ( instancetype ) pi;
+ ( instancetype ) e;

+ ( instancetype ) rand;

- ( NSComparisonResult ) compare: ( OMCOperand* )_Rhs;

#pragma mark Degit Operations
- ( void ) appendDigit: ( NSInteger )_Digit
                 count: ( NSInteger )_Count
                   ary: ( OMCAry )_Ary;

- ( void ) deleteDigit: ( NSInteger )_Digit
                 count: ( NSInteger )_Count
                   ary: ( OMCAry )_Ary;

- ( BOOL ) isNaN;
- ( BOOL ) isZero;
- ( void ) zeroed;

@end // OMCOperand class

#pragma mark Unitary Operations
@interface OMCOperand ( OMCOperand_UnitaryOperations )

- ( instancetype ) abs;
- ( instancetype ) positiveOrNegative;

- ( instancetype ) pow: ( OMCOperand* )_Rhs;
- ( instancetype ) EE: ( OMCOperand* )_Rhs;
- ( instancetype ) square;
- ( instancetype ) cube;
- ( instancetype ) sqrt;
- ( instancetype ) cubeRoot;
- ( instancetype ) xRoot: ( OMCOperand* )_Rhs;
- ( instancetype ) e_x;
- ( instancetype ) _2_x;
- ( instancetype ) _10_x;

- ( instancetype ) percent;
- ( instancetype ) reciprocal;

/* Computes the natural (base 2) logarithm of current value */
- ( instancetype ) log2;
/* Computes the natural (base 10) logarithm of current value */
- ( instancetype ) log10;
/* Computes the natural (base e) logarithm of current value */
- ( instancetype ) naturalLogarithm;

/* Computes the sine of current value (measured in radians) */
- ( instancetype ) sinWithRadians;
/* Computes the cosine of current value (measured in radians) */
- ( instancetype ) cosWithRadians;
/* Computes the tangent of current value (measured in radians) */
- ( instancetype ) tanWithRadians;

/* Computes the sine of current value (measured in degrees) */
- ( instancetype ) sinWithDegrees;
/* Computes the cosine of current value (measured in degrees) */
- ( instancetype ) cosWithDegrees;
/* Computes the tangent of current value (measured in degrees) */
- ( instancetype ) tanWithDegrees;;

/* Computes the principal values of the arc sine of current value (measured in radians) */
- ( instancetype ) asinWithRadians;
/* Computes the principal values of the arc cosine of current value (measured in radians) */
- ( instancetype ) acosWithRadians;
/* Computes the principal values of the arc tangent of current value (measured in radians) */
- ( instancetype ) atanWithRadians;

/* Computes the principal values of the arc sine of current value (measured in degrees) */
- ( instancetype ) asinWithDegrees;
/* Computes the principal values of the arc cosine of current value (measured in degrees) */
- ( instancetype ) acosWithDegrees;
/* Computes the principal values of the arc tangent of current value (measured in degrees) */
- ( instancetype ) atanWithDegrees;

/* Computes hyperbolic sine of current value */
- ( instancetype ) sinh;
/* Computes hyperbolic cosine of current value */
- ( instancetype ) cosh;
/* Computes hyperbolic tangent of current value */
- ( instancetype ) tanh;

/* Computes the inverse hyperbolic sine of current value */
- ( instancetype ) asinh;
/* Computes the inverse hyperbolic cosine of current value */
- ( instancetype ) acosh;
/* Computes the inverse hyperbolic tangent of current value */
- ( instancetype ) atanh;

- ( instancetype ) RoL;
- ( instancetype ) RoR;

- ( instancetype ) flipBytes;

- ( instancetype ) factorial;

@end // OMCOperand + OMCOperations

#pragma mark Binary Operations
@interface OMCOperand ( OMCOperand_BinaryOperations )

- ( instancetype ) add: ( OMCOperand* )_Rhs;
- ( instancetype ) subtract: ( OMCOperand* )_Rhs;
- ( instancetype ) multiply: ( OMCOperand* )_Rhs;
- ( instancetype ) divide: ( OMCOperand* )_Rhs;
- ( instancetype ) mod: ( OMCOperand* )_Rhs;

- ( instancetype ) bitwiseAnd: ( OMCOperand* )_Rhs;
- ( instancetype ) bitwiseOr: ( OMCOperand* )_Rhs;
- ( instancetype ) bitwiseNor: ( OMCOperand* )_Rhs;
- ( instancetype ) bitwiseXor: ( OMCOperand* )_Rhs;
- ( instancetype ) Lsh: ( OMCOperand* )_Rhs;
- ( instancetype ) Rsh: ( OMCOperand* )_Rhs;

@end // OMCOperand + OMCOperand_BinaryOperations

#pragma mark Decimal Number Behaviors
@interface OMCOperand ( OMCDecimalNumberBehaviors ) <NSDecimalNumberBehaviors>

- ( short ) scale;

- ( NSRoundingMode ) roundingMode;

- ( NSDecimalNumber* ) exceptionDuringOperation: ( SEL )_OperationMethod
                                          error: ( NSCalculationError )_Error
                                    leftOperand: ( NSDecimalNumber* )_LhsOperand
                                   rightOperand: ( NSDecimalNumber* )_RhsOperand;

@end // OMCOperand + OMCDecimalNumberBehaviors

#pragma mark Pasteboard Support
@interface OMCOperand ( OMCPasteboardSupport ) <NSCoding, NSPasteboardWriting, NSPasteboardReading>

- ( id ) initWithCoder: ( NSCoder* )_Coder;
- ( void ) encodeWithCoder: ( NSCoder* )_Coder;

// Conforms <NSPasteboardWriting> protocol
- ( NSArray* ) writableTypesForPasteboard: ( NSPasteboard* )_Pboard;
- ( id ) pasteboardPropertyListForType: ( NSString* )_Type;

// Conforms <NSPasteboardReading> protocol
+ ( NSArray* ) readableTypesForPasteboard: ( NSPasteboard* )_Pboard;
+ ( NSPasteboardReadingOptions ) readingOptionsForType: ( NSString* )_Type
                                            pasteboard: ( NSPasteboard* )_Pboard;

- ( BOOL ) writeToPasteboard: ( NSPasteboard* )_Pboard;

@end // OMCOperand + OMCCodingBehaviors

#pragma mark NSDecimalNumberHandler + OMCOperand
@interface NSDecimalNumberHandler ( OMCOperand )

+ ( instancetype ) roundUpBehavior;
+ ( instancetype ) roundDownBehavior;

@end // NSDecimalNumberHandler + OMCOperand

#pragma mark Utility Functions
NSUInteger OMCOperandConvertHexToDecimal( NSString* );

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