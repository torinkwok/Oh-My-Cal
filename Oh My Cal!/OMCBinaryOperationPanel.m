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

#import "OMCBinaryOperationPanel.h"
#import "OMCBinaryAndDecimalConversion.h"

#define BIT_COUNT       64
#define BIT_GROUP       4
#define BIT_GROUP_COUNT BIT_COUNT / BIT_GROUP
#define BIT_GROUP_GAP   5

// OMCBinaryOperationPanel class
@implementation OMCBinaryOperationPanel

@synthesize bitsRects = _bitsRects;

@synthesize currentResultVal = _currentResultVal;
@synthesize binaryInString = _binaryInString;

- ( void ) awakeFromNib
    {
    self.bitsRects = [ NSMutableArray arrayWithCapacity: BIT_COUNT ];

    self.currentResultVal = 0;
    self.binaryInString = [ NSString string ];

    NSLog( @"%@", [ self convertDecimalToBinary: 18446744073709551527 ] );
    }

#pragma mark Conforms OMCBinaryAndDecimalConversion protocol
- ( NSString* ) convertDecimalToBinary: ( NSInteger )_DecimalVal
    {
    NSMutableString* binaryInString = [ NSMutableString string ];
    [ binaryInString fillWith: @"0" count: BIT_COUNT ];

    NSInteger quotient = _DecimalVal;
    for ( NSInteger index = BIT_COUNT - 1; index >= 0; index-- )
        {
        [ binaryInString replaceCharactersInRange: NSMakeRange( index, 1 )
                                       withString: [ NSString stringWithFormat: @"%ld", quotient % 2 ] ];

        quotient /= 2;
        }

    return [ binaryInString copy ];
    }

#pragma mark Customize Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    
//    [ [ NSColor whiteColor ] set ];
//    NSFrameRect( _DirtyRect );
    }

@end // OMCBinaryOperationPanel

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