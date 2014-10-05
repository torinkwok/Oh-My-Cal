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
#import "OMCCal.h"

@class OMCProgrammerStyleCalculation;

// OMCCalWithProgrammerStyle class
@interface OMCCalWithProgrammerStyle : OMCCal

#pragma mark Buttons with bitwise operators
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _andOperator;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _orOperator;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _norOperator;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _xorOperator;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _lshOperator;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _rshOperator;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _rolOperator;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _rorOperator;

#pragma mark Buttons with mathematical operators
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _modOperator;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _factorialOperator;

#pragma mark Buttons with operands
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _doubleZero;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _0xA;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _0xB;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _0xC;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _0xD;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _0xE;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _0xF;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _0xFF;

@property ( nonatomic, unsafe_unretained ) IBOutlet OMCProgrammerStyleCalculation* _calculation;

#pragma mark IBActions
- ( IBAction ) aryChanged: ( id )_Sender;

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