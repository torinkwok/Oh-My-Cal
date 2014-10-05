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

@interface OMCCal : NSView

@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _memoryClear;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _memoryPlus;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _memorySub;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _memoryRead;

@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _one;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _two;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _three;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _four;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _five;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _six;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _seven;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _eight;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _nine;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _zero;

@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _additionOperator;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _subtractionOperator;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _multiplicationOperator;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _divisionOperator;

#pragma mark Control Button
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _del;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _clearAll;
@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _clear;

@property ( nonatomic, unsafe_unretained ) IBOutlet NSButton* _enterOperator;

@end

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