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
@property ( nonatomic, assign ) IBOutlet NSButton* _andOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _orOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _norOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _xorOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _lshOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _rshOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _rolOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _rorOperator;

#pragma mark Buttons with mathematical operators
@property ( nonatomic, assign ) IBOutlet NSButton* _modOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _factorialOperator;

#pragma mark Buttons with operands
@property ( nonatomic, assign ) IBOutlet NSButton* _doubleZero;
@property ( nonatomic, assign ) IBOutlet NSButton* _0xA;
@property ( nonatomic, assign ) IBOutlet NSButton* _0xB;
@property ( nonatomic, assign ) IBOutlet NSButton* _0xC;
@property ( nonatomic, assign ) IBOutlet NSButton* _0xD;
@property ( nonatomic, assign ) IBOutlet NSButton* _0xE;
@property ( nonatomic, assign ) IBOutlet NSButton* _0xF;
@property ( nonatomic, assign ) IBOutlet NSButton* _0xFF;

@property ( nonatomic, assign ) IBOutlet OMCProgrammerStyleCalculation* _calculation;

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