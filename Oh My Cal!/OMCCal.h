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

@property ( nonatomic, assign ) IBOutlet NSButton* _memoryClear;
@property ( nonatomic, assign ) IBOutlet NSButton* _memoryPlus;
@property ( nonatomic, assign ) IBOutlet NSButton* _memorySub;
@property ( nonatomic, assign ) IBOutlet NSButton* _memoryRead;

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

@property ( nonatomic, assign ) IBOutlet NSButton* _additionOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _subtractionOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _multiplicationOperator;
@property ( nonatomic, assign ) IBOutlet NSButton* _divisionOperator;

#pragma mark Control Button
@property ( nonatomic, assign ) IBOutlet NSButton* _del;
@property ( nonatomic, assign ) IBOutlet NSButton* _clearAll;
@property ( nonatomic, assign ) IBOutlet NSButton* _clear;

@property ( nonatomic, assign ) IBOutlet NSButton* _enterOperator;

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