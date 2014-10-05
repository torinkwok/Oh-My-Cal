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
#import "OMCCalWithBasicStyle.h"

@class OMCScientificStyleCalculation;

// OMCCalWithScientificStyle class
@interface OMCCalWithScientificStyle : OMCCalWithBasicStyle

@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _shift;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _percent;

@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _reciprocal;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _square;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _cube;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _xPower;

@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _cubeRoot;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _xRoot;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _e_x;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _2_x;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _10_x;

@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _factorial;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _sqrt;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _rad;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _log2;

@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _sin;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _cos;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _tan;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _asin;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _acos;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _atan;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _log10;

@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _sinh;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _cosh;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _tanh;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _asinh;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _acosh;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _atanh;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _In;

@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _pi;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _e;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _rand;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _EE;

@property ( nonatomic, unsafe_unretained ) IBOutlet OMCScientificStyleCalculation* _calculation;

@end // OMCCal

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