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
#import "OMCCalculation.h"

#define BIT_COUNT       64
#define BIT_GROUP       4
#define BIT_GROUP_COUNT BIT_COUNT / BIT_GROUP
#define BIT_GROUP_HORIZONTAL_GAP    15.f
#define BIT_GROUP_VERTICAL_GAP      10.f

NSString static* const kKeyPathForResultValInCalculationObject = @"self.resultValue.baseNumber.unsignedIntegerValue";

// OMCBinaryOperationPanel class
@implementation OMCBinaryOperationPanel

@synthesize _calculation;

@synthesize currentResultVal = _currentResultVal;
@synthesize binaryInString = _binaryInString;

@synthesize rectsBitsOccupied = _rectsBitsOccupied;
@synthesize bitColor = _bitColor;
@synthesize bitFont = _bitFont;
@synthesize bitSize = _bitSize;

#pragma mark Initializers & Deallocators
- ( void ) awakeFromNib
    {
    self.currentResultVal = 0U;
    self.binaryInString = [ self convertDecimalToBinary: 35235235 ];

    [ _calculation addObserver: self
                    forKeyPath: kKeyPathForResultValInCalculationObject
                       options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                       context: NULL ];

    self.bitColor = [ NSColor whiteColor ];
    self.bitFont = [ NSFont fontWithName: @"Courier Std" size: 13.f ];
    self.bitSize = [ @"0" sizeWithAttributes: @{ NSFontAttributeName : self.bitFont } ];

    [ self _initializeRectsBitOccupied ];
    }

- ( void ) observeValueForKeyPath: ( NSString* )_KeyPath
                         ofObject: ( id )_Object
                           change: ( NSDictionary* )_Change
                          context: ( void* )_Context
    {
    if ( [ _KeyPath isEqualToString: kKeyPathForResultValInCalculationObject ] )
        {
        self.binaryInString = [ self convertDecimalToBinary: [ _Change[ @"new" ] unsignedIntegerValue ] ];
        [ self setNeedsDisplay: YES ];
        }
    }

- ( void ) _initializeRectsBitOccupied
    {
    NSMutableArray* rects = [ NSMutableArray arrayWithCapacity: BIT_COUNT ];

    NSRect bounds = [ self bounds ];

    CGFloat bitWidth = self.bitSize.width + 1.f;
    CGFloat bitHeight = self.bitSize.height;
    CGFloat bitX = 0.f;
    CGFloat bitY = 0.f;

    NSRect bitRect = NSZeroRect;

    for ( int index = 0; index < BIT_COUNT / 2; index++ )
        {
        bitX = NSMaxX( [ [ rects lastObject ] rectValue ] );

        if ( ( index % 4 ) == 0 && index != 0 )
            bitX += 7;

        bitRect = NSMakeRect( bitX, bitY, bitWidth, bitHeight );

        [ rects addObject: [ NSValue valueWithRect: bitRect ] ];
        }

    for ( int index = 0; index < BIT_COUNT / 2; index++ )
        {
        bitX = NSMaxX( [ [ rects lastObject ] rectValue ] );

        if ( ( index % 4 ) == 0 && index != 0 )
            bitX += 7;

        bitY = bitHeight + BIT_GROUP_VERTICAL_GAP;
        bitRect = NSMakeRect( bitX, bitY, bitWidth, bitHeight );

        [ rects addObject: [ NSValue valueWithRect: bitRect ] ];
        }

    self.rectsBitsOccupied = rects;
    }

#pragma mark Conforms <OMCBinaryAndDecimalConversion> protocol
- ( NSString* ) convertDecimalToBinary: ( NSUInteger )_DecimalVal
    {
    NSMutableString* binaryInString = [ NSMutableString string ];
    [ binaryInString fillWith: @"0" count: BIT_COUNT ];

    NSUInteger quotient = _DecimalVal;
    for ( NSInteger index = BIT_COUNT - 1; index >= 0; index-- )
        {
        /* For example:
         * We want to retrieve the binary form of 75, we can...
         * 75 / 2 = 37	residue 1
         * 37 / 2 = 18	residue 1
         * 18 / 2 = 9	residue 0
         *  9 / 2 = 4	residue 1
         *  4 / 2 = 2 	residue 0
         *  2 / 2 = 1 	residue 0
         *  1 / 2 = 0	residue 1
         * so the binary form of 75 is '0000 0000 0100 1011'
         */
        [ binaryInString replaceCharactersInRange: NSMakeRange( index, 1 )
                                       withString: [ NSString stringWithFormat: @"%ld", quotient % 2 /* 0 or 1 */ ] ];
        quotient /= 2;
        }

    return [ binaryInString copy ];
    }

#pragma mark Customize Drawing
- ( BOOL ) isFlipped
    {
    return YES;
    }

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ [ NSColor whiteColor ] set ];

    [ self.rectsBitsOccupied enumerateObjectsUsingBlock:
        ^( NSValue* _RectVal, NSUInteger _Index, BOOL* _Stop )
            {
            [ [ self.binaryInString substringWithRange: NSMakeRange( _Index, 1 ) ]
                    drawInRect: [ _RectVal rectValue ] withAttributes: @{ NSFontAttributeName : self.bitFont
                                                                        , NSForegroundColorAttributeName : self.bitColor
                                                                        } ];
            } ];
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