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
#import "OMCBinaryAndDecimalConversion.h"

// Notification names
NSString extern* const OMCBinaryStringDidChanged;

@class OMCCalculation;

// OMCBinaryOperationPanel class
@interface OMCBinaryOperationPanel : NSView <OMCBinaryAndDecimalConversion>
    {
@private
    NSUInteger      _currentResultVal;
    NSString*       _binaryInString;

    NSArray*        _rectsTheTopLevelBitsOccupied;
    NSArray*        _rectsTheBottomLevelBitsOccupied;

    NSColor*        _bitColor;
    NSFont*         _bitFont;

    NSColor*        _anchorColor;
    NSFont*         _anchorFont;

    NSSize          _bitSize;
    NSSize          _anchorSize;
    }

@property ( nonatomic, assign ) IBOutlet OMCCalculation* _calculation;

@property ( nonatomic, assign ) NSUInteger currentResultVal;
@property ( nonatomic, copy ) NSString* binaryInString;

@property ( nonatomic, copy ) NSArray* rectsTheTopLevelBitsOccupied;
@property ( nonatomic, copy ) NSArray* rectsTheBottomLevelBitsOccupied;

@property ( nonatomic, retain ) NSColor* bitColor;
@property ( nonatomic, retain ) NSFont* bitFont;

@property ( nonatomic, retain ) NSColor* anchorColor;
@property ( nonatomic, retain ) NSFont* anchorFont;

@property ( nonatomic, assign ) NSSize bitSize;
@property ( nonatomic, assign ) NSSize anchorSize;

@end // OMCBinaryOperationPanel class

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