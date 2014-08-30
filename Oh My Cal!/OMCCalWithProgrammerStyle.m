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

#import "OMCCalWithProgrammerStyle.h"
#import "OMCCalculation.h"

// OMCCalWithProgrammerStyle class
@implementation OMCCalWithProgrammerStyle

#pragma mark Buttons with bitwise operators
@synthesize _andOperator;
@synthesize _orOperator;
@synthesize _norOperator;
@synthesize _xorOperator;
@synthesize _lshOperator;
@synthesize _rshOperator;
@synthesize _2_sOperator;
@synthesize _1_sOperator;

#pragma mark Buttons with mathematical operators
@synthesize _modOperator;
@synthesize _factorialOperator;
@synthesize _additionOperator;
@synthesize _subtractionOperator;
@synthesize _multiplicationOperator;
@synthesize _divisionOperator;
@synthesize _lhsParenthesis;
@synthesize _rhsParenthesis;
@synthesize _enterOperator;

#pragma mark Buttons with operands
@synthesize _one;
@synthesize _two;
@synthesize _three;
@synthesize _four;
@synthesize _five;
@synthesize _six;
@synthesize _seven;
@synthesize _eight;
@synthesize _nine;
@synthesize _zero;
@synthesize _doubleZero;
@synthesize _0xA;
@synthesize _0xB;   
@synthesize _0xC;
@synthesize _0xD;
@synthesize _0xE;
@synthesize _0xF;
@synthesize _0xFF;

#pragma mark Control Button
@synthesize _del;
@synthesize _clearAll;
@synthesize _clear;

@synthesize _calculation;

#pragma mark Initializers & Deallocators
- ( void ) awakeFromNib
    {
    [ self _toggleSpecialButtonsBasedAry: ( OMCAry )[ USER_DEFAULTS integerForKey: OMCDefaultsKeyAry ] ];
    }

#pragma mark IBActions
- ( IBAction ) aryChanged: ( id )_Sender
    {
    NSSegmentedControl* arySeg = ( NSSegmentedControl* )_Sender;

    self._calculation.currentAry = ( OMCAry )[ arySeg.cell tagForSegment: [ arySeg selectedSegment ] ];
    [ self _toggleSpecialButtonsBasedAry: self._calculation.currentAry ];

    if ( self._calculation.currentAry == OMCOctal )
        {
        NSLog( @"Value in oct: %ld", self._calculation.lhsOperand.integerValue );
        [ self._calculation.lhsOperand replaceAllWithString: [ NSString stringWithFormat: @"%lo", self._calculation.lhsOperand.integerValue ] ];
        [ self._calculation.rhsOperand replaceAllWithString: [ NSString stringWithFormat: @"%lo", self._calculation.rhsOperand.integerValue ] ];
        [ self._calculation.resultValue replaceAllWithString: [ NSString stringWithFormat: @"%lo", self._calculation.resultValue.integerValue ] ];
        }
    else if ( self._calculation.currentAry == OMCDecimal )
        {
        NSLog( @"Value in dec: %ld", self._calculation.lhsOperand.integerValue );
        [ self._calculation.lhsOperand replaceAllWithString: [ NSString stringWithFormat: @"%ld", self._calculation.lhsOperand.integerValue ] ];
        [ self._calculation.rhsOperand replaceAllWithString: [ NSString stringWithFormat: @"%ld", self._calculation.rhsOperand.integerValue ] ];
        [ self._calculation.resultValue replaceAllWithString: [ NSString stringWithFormat: @"%ld", self._calculation.resultValue.integerValue ] ];
        }
    else if ( self._calculation.currentAry == OMCHex )
        {
        NSLog( @"Value in hex: %ld", self._calculation.lhsOperand.integerValue );
        [ self._calculation.lhsOperand replaceAllWithString: [ NSString stringWithFormat: @"%lx", self._calculation.lhsOperand.integerValue ] ];
        [ self._calculation.rhsOperand replaceAllWithString: [ NSString stringWithFormat: @"%lx", self._calculation.rhsOperand.integerValue ] ];
        [ self._calculation.resultValue replaceAllWithString: [ NSString stringWithFormat: @"0x%lx", self._calculation.resultValue.integerValue ] ];
        }

    [ USER_DEFAULTS setInteger: self._calculation.currentAry forKey: OMCDefaultsKeyAry ];
    }

- ( void ) _toggleSpecialButtonsBasedAry: ( OMCAry )_Ary
    {
    BOOL isHex = ( _Ary == OMCHex );
    [ self._0xA setEnabled: isHex ];
    [ self._0xB setEnabled: isHex ];
    [ self._0xC setEnabled: isHex ];
    [ self._0xD setEnabled: isHex ];
    [ self._0xE setEnabled: isHex ];
    [ self._0xF setEnabled: isHex ];
    [ self._0xFF setEnabled: isHex ];

    BOOL isOctal = ( _Ary == OMCOctal );
    [ self._eight setEnabled: !isOctal ];
    [ self._nine setEnabled: !isOctal ];
    }

@end // OMCCalWithProgrammerStyle class

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