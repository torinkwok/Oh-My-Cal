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

@property ( nonatomic, assign ) IBOutlet NSButton* _shift;
@property ( nonatomic, assign ) IBOutlet NSButton* _lhsParenthesis;
@property ( nonatomic, assign ) IBOutlet NSButton* _rhsParenthesis;
@property ( nonatomic, assign ) IBOutlet NSButton* _percent;

@property ( nonatomic, assign ) IBOutlet NSButton* _reciprocal;
@property ( nonatomic, assign ) IBOutlet NSButton* _square;
@property ( nonatomic, assign ) IBOutlet NSButton* _cube;
@property ( nonatomic, assign ) IBOutlet NSButton* _xPower;

@property ( nonatomic, assign ) IBOutlet NSButton* _factorial;
@property ( nonatomic, assign ) IBOutlet NSButton* _sqrt;
@property ( nonatomic, assign ) IBOutlet NSButton* _rad;
@property ( nonatomic, assign ) IBOutlet NSButton* _log2;

@property ( nonatomic, assign ) IBOutlet NSButton* _sin;
@property ( nonatomic, assign ) IBOutlet NSButton* _cos;
@property ( nonatomic, assign ) IBOutlet NSButton* _tan;
@property ( nonatomic, assign ) IBOutlet NSButton* _asin;
@property ( nonatomic, assign ) IBOutlet NSButton* _acos;
@property ( nonatomic, assign ) IBOutlet NSButton* _atan;
@property ( nonatomic, assign ) IBOutlet NSButton* _log10;

@property ( nonatomic, assign ) IBOutlet NSButton* _sinh;
@property ( nonatomic, assign ) IBOutlet NSButton* _cosh;
@property ( nonatomic, assign ) IBOutlet NSButton* _tanh;
@property ( nonatomic, assign ) IBOutlet NSButton* _asinh;
@property ( nonatomic, assign ) IBOutlet NSButton* _acosh;
@property ( nonatomic, assign ) IBOutlet NSButton* _atanh;
@property ( nonatomic, assign ) IBOutlet NSButton* _In;

@property ( nonatomic, assign ) IBOutlet NSButton* _pi;
@property ( nonatomic, assign ) IBOutlet NSButton* _e;
@property ( nonatomic, assign ) IBOutlet NSButton* _rand;
@property ( nonatomic, assign ) IBOutlet NSButton* _EE;

@property ( nonatomic, assign ) IBOutlet OMCScientificStyleCalculation* _calculation;

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