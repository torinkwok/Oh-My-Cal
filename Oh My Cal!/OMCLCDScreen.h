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

@class OMCCalculation;

// OMCLCDScreen class
@interface OMCLCDScreen : BGHUDView
    {
@private
    NSRect _lhsOperandSpace;
    NSRect _rhsOperandSpace;
    NSRect _tmpOperandSpace;

    NSBezierPath* _linePath;
    NSBezierPath* _gridPath;

    NSMutableString* _lhsOperand;
    NSMutableString* _rhsOperand;
    NSMutableString* _resultValue;
    }

@property ( nonatomic, assign ) IBOutlet OMCCalculation* _calculation;

@property ( nonatomic, assign, readonly ) NSRect lhsOperandSpace;
@property ( nonatomic, assign, readonly ) NSRect rhsOperandSpace;
@property ( nonatomic, assign, readonly ) NSRect tmpOperandSpace;

@property ( nonatomic, retain ) NSBezierPath* linePath;
@property ( nonatomic, retain ) NSBezierPath* gridPath;

@property ( nonatomic, retain ) NSMutableString* lhsOperand;
@property ( nonatomic, retain ) NSMutableString* rhsOperand;
@property ( nonatomic, retain ) NSMutableString* resultValue;

@end // OMCLCDScreen

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