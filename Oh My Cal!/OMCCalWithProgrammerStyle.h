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

// OMCCalWithProgrammerStyle class
@interface OMCCalWithProgrammerStyle : NSView

#pragma mark Buttons with bitwise operators
@property ( nonatomic, assign ) IBOutlet NSButton* _andOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _orOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _norOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _xorOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _lshOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _rshOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _2_sOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _1_sOperator;

#pragma mark Buttons with mathematical operators
@property ( nonatomic, assign ) IBOutlet NSButton* _modOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _factorialOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _additionOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _subtractionOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _multiplicationOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _divisionOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _lhsParenthesis;
@property ( nonatomic, assign ) IBOutlet NSButton* _rhsParenthesis;
@property ( nonatomic, assign ) IBOutlet NSButton* _enterOperator;

#pragma mark Buttons with operands
@property ( nonatomic, assign ) IBOutlet NSButton* _one;
@property ( nonatomic, assign ) IBOutlet NSButton* _two;
@property ( nonatomic, assign ) IBOutlet NSButton* _three;
@property ( nonatomic, assign ) IBOutlet NSButton* _four;
@property ( nonatomic, assign ) IBOutlet NSButton* _five;
@property ( nonatomic, assign ) IBOutlet NSButton* _six;
@property ( nonatomic, assign ) IBOutlet NSButton* _seven;
@property ( nonatomic, assign ) IBOutlet NSButton* _eight;
@property ( nonatomic, assign ) IBOutlet NSButton* _nine;
@property ( nonatomic, assign ) IBOutlet NSButton* _zero;
@property ( nonatomic, assign ) IBOutlet NSButton* _doubleZero;
@property ( nonatomic, assign ) IBOutlet NSButton* _0xA;
@property ( nonatomic, assign ) IBOutlet NSButton* _0xB;
@property ( nonatomic, assign ) IBOutlet NSButton* _0xC;
@property ( nonatomic, assign ) IBOutlet NSButton* _0xD;
@property ( nonatomic, assign ) IBOutlet NSButton* _0xE;
@property ( nonatomic, assign ) IBOutlet NSButton* _0xF;
@property ( nonatomic, assign ) IBOutlet NSButton* _0xFF;

#pragma mark Control Button
@property ( nonatomic, assign ) IBOutlet NSButton* _del;
@property ( nonatomic, assign ) IBOutlet NSButton* _clearAll;
@property ( nonatomic, assign ) IBOutlet NSButton* _clear;

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