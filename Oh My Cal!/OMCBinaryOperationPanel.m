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

#import "OMCOperand.h"
#import "OMCBinaryOperationPanel.h"
#import "OMCBinaryAndDecimalConversion.h"
#import "OMCProgrammerStyleCalculation.h"

#import <FBKVOController/NSObject+FBKVOController.h>

// Notification names
NSString* const OMCBinaryStringDidChanged = @"OMCBinaryStringDidChanged";

NSString static* const kKeyPathForLhsOperandInCalculationObject = @"self.lhsOperand.decimalNumber";
NSString static* const kKeyPathForRhsOperandInCalculationObject = @"self.rhsOperand.decimalNumber";
NSString static* const kKeyPathForResultValInCalculationObject = @"self.resultValue.decimalNumber";

// OMCBinaryOperationPanel class
@implementation OMCBinaryOperationPanel

@synthesize KVOController = _KVOController;

@synthesize _calculation;

@synthesize currentResultVal = _currentResultVal;
@synthesize binaryInString = _binaryInString;

@synthesize rectsTheTopLevelBitsOccupied = _rectsTheTopLevelBitsOccupied;
@synthesize rectsTheBottomLevelBitsOccupied = _rectsTheBottomLevelBitsOccupied;

@synthesize bitColor = _bitColor;
@synthesize bitFont = _bitFont;

@synthesize anchorColor = _anchorColor;
@synthesize anchorFont = _anchorFont;

@synthesize bitSize = _bitSize;
@synthesize anchorSize = _anchorSize;

#pragma mark Initializers & Deallocators
- ( void ) awakeFromNib
    {
    self.currentResultVal = 0U;
    self.binaryInString = [ self convertDecimalToBinary: 0 ];

    self.KVOController = [ FBKVOController controllerWithObserver: self ];
    [ self.KVOController observe: _calculation
                        keyPaths: @[ kKeyPathForResultValInCalculationObject
                                   , kKeyPathForLhsOperandInCalculationObject
                                   , kKeyPathForRhsOperandInCalculationObject ]
                         options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                           block:
        ^( NSString* _KeyPath, OMCBinaryOperationPanel* _Observer, OMCCalculation* _ObservedObject, NSDictionary* _Change )
            {
            if ( [ _KeyPath isEqualToString: kKeyPathForResultValInCalculationObject ]
                    || [ _KeyPath isEqualToString: kKeyPathForLhsOperandInCalculationObject ]
                    || [ _KeyPath isEqualToString: kKeyPathForRhsOperandInCalculationObject ] )
                {
                self.binaryInString = [ self convertDecimalToBinary: [ _Change[ @"new" ] unsignedIntegerValue ] ];
                [ self setNeedsDisplay: YES ];
                }
            } ];

    self.bitColor = [ NSColor whiteColor ];
    self.bitFont = [ NSFont fontWithName: @"Courier" size: 13.f ];

    self.anchorColor = [ NSColor colorWithDeviceWhite: .6f alpha: .5f ];
    self.anchorFont = [ NSFont fontWithName: @"Courier" size: 8.f ];

    self.bitSize = [ @"0" sizeWithAttributes: @{ NSFontAttributeName : self.bitFont } ];
    self.anchorSize = [ @"64" sizeWithAttributes: @{ NSFontAttributeName : self.anchorFont } ];

    [ self _initializeRectsBitOccupied ];
    }

- ( void ) _initializeRectsBitOccupied
    {
    NSMutableArray* topLevelRects = [ NSMutableArray arrayWithCapacity: BIT_COUNT / 2 ];
    NSMutableArray* bottomLevelRects = [ NSMutableArray arrayWithCapacity: BIT_COUNT / 2 ];

    CGFloat bitWidth = self.bitSize.width + 1.f;
    CGFloat bitHeight = self.bitSize.height;
    CGFloat bitX = 0.f;
    CGFloat bitY = 0.f;

    NSRect bitRect = NSZeroRect;

    BOOL isMoreThanHalf = NO;

    for ( int index = 0; index < BIT_COUNT; index++ )
        {
        isMoreThanHalf = ( index >= BIT_COUNT / 2 );
        bitX = NSMaxX( [ [ ( isMoreThanHalf ? bottomLevelRects : topLevelRects ) lastObject ] rectValue ] );

        if ( ( index % 4 ) == 0 && index != 0 && index != BIT_COUNT / 2 )
            bitX += 7.2f;

        if ( isMoreThanHalf )
            bitY = bitHeight + BIT_GROUP_VERTICAL_GAP;

        bitRect = NSMakeRect( bitX, bitY, bitWidth, bitHeight );

        [ ( isMoreThanHalf ? bottomLevelRects : topLevelRects ) addObject: [ NSValue valueWithRect: bitRect ] ];
        }

    self.rectsTheTopLevelBitsOccupied = topLevelRects;
    self.rectsTheBottomLevelBitsOccupied = bottomLevelRects;
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
         *
         * 75 / 2 = 37	residue 1
         * 37 / 2 = 18	residue 1
         * 18 / 2 = 9	residue 0
         *  9 / 2 = 4	residue 1
         *  4 / 2 = 2 	residue 0
         *  2 / 2 = 1 	residue 0
         *  1 / 2 = 0	residue 1
         *
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
    NSDictionary* attributesForDrawingBits = @{ NSFontAttributeName : self.bitFont
                                              , NSForegroundColorAttributeName : self.bitColor
                                              };

    NSDictionary* attributesForDrawingAnchors = @{ NSFontAttributeName : self.anchorFont
                                                 , NSForegroundColorAttributeName : self.anchorColor
                                                 };

    [ self.rectsTheTopLevelBitsOccupied enumerateObjectsUsingBlock:
        ^( NSValue* _RectVal, NSUInteger _Index, BOOL* _Stop )
            {
            [ [ self.binaryInString substringWithRange: NSMakeRange( _Index, 1 ) ]
                    drawInRect: [ _RectVal rectValue ] withAttributes: attributesForDrawingBits ];
            } ];

    [ self.rectsTheBottomLevelBitsOccupied enumerateObjectsUsingBlock:
        ^( NSValue* _RectVal, NSUInteger _Index, BOOL* _Stop )
            {
            [ [ self.binaryInString substringWithRange: NSMakeRange( _Index + BIT_COUNT / 2, 1 ) ]
                    drawInRect: [ _RectVal rectValue ] withAttributes: attributesForDrawingBits ];
            } ];

    NSRect rectForCertainBit = NSZeroRect;

    // Drawing anchors in top level
    rectForCertainBit = [ self.rectsTheTopLevelBitsOccupied.firstObject rectValue ];
    rectForCertainBit.origin.y -= 4.f;
    [ @"63" drawAtPoint: NSMakePoint( NSMinX( rectForCertainBit ), NSMaxY( rectForCertainBit ) )
         withAttributes: attributesForDrawingAnchors ];

    rectForCertainBit = [ self.rectsTheTopLevelBitsOccupied[ 16 ] rectValue ];
    rectForCertainBit.origin.x -= 2.f;
    rectForCertainBit.origin.y -= 4.f;
    [ @"47" drawAtPoint: NSMakePoint( NSMinX( rectForCertainBit ), NSMaxY( rectForCertainBit ) )
         withAttributes: attributesForDrawingAnchors ];

    rectForCertainBit = [ self.rectsTheTopLevelBitsOccupied[ 31 ] rectValue ];
    rectForCertainBit.origin.x -= 2.f;
    rectForCertainBit.origin.y -= 4.f;
    [ @"32" drawAtPoint: NSMakePoint( NSMinX( rectForCertainBit ), NSMaxY( rectForCertainBit ) )
         withAttributes: attributesForDrawingAnchors ];

    // Drawing anchors in bottom level
    rectForCertainBit = [ self.rectsTheBottomLevelBitsOccupied.firstObject rectValue ];
    rectForCertainBit.origin.y -= 4.f;
    [ @"31" drawAtPoint: NSMakePoint( NSMinX( rectForCertainBit ), NSMaxY( rectForCertainBit ) )
         withAttributes: attributesForDrawingAnchors ];

    rectForCertainBit = [ self.rectsTheBottomLevelBitsOccupied[ 16 ] rectValue ];
    rectForCertainBit.origin.x -= 2.f;
    rectForCertainBit.origin.y -= 4.f;
    [ @"15" drawAtPoint: NSMakePoint( NSMinX( rectForCertainBit ), NSMaxY( rectForCertainBit ) )
         withAttributes: attributesForDrawingAnchors ];

    rectForCertainBit = [ self.rectsTheBottomLevelBitsOccupied[ 31 ] rectValue ];
    rectForCertainBit.origin.x += 1.f;
    rectForCertainBit.origin.y -= 4.f;
    [ @"0" drawAtPoint: NSMakePoint( NSMinX( rectForCertainBit ), NSMaxY( rectForCertainBit ) )
         withAttributes: attributesForDrawingAnchors ];
    }

#pragma mark Events Handling
- ( void ) mouseDown: ( NSEvent* )_Event
    {
    NSPoint location = [ self convertPoint: _Event.locationInWindow fromView: nil ];

    NSInteger bit = 0;
    BOOL isMoreThanHalf = NO;
    NSArray* rectsBitsOccupied = nil;

    for ( int index = 0; index < BIT_COUNT; index++ )
        {
        isMoreThanHalf = ( index >= BIT_COUNT / 2 );

        rectsBitsOccupied = isMoreThanHalf ? self.rectsTheBottomLevelBitsOccupied : self.rectsTheTopLevelBitsOccupied;

        int bitIndex = isMoreThanHalf ? ( index - BIT_COUNT / 2 ) : index;
        if ( NSPointInRect( location, [ rectsBitsOccupied[ bitIndex ] rectValue ] ) )
            {
            bit = [ self.binaryInString substringWithRange: NSMakeRange( index, 1 ) ].integerValue;

            self.binaryInString = [ self.binaryInString stringByReplacingCharactersInRange: NSMakeRange( index, 1 )
                                                                                withString: ( bit == 0 ) ? @"1" : @"0" ];

            [ NOTIFICATION_CENTER postNotificationName: OMCBinaryStringDidChanged
                                                object: self ];

            [ self setNeedsDisplay: YES ];
            break;
            }
        }
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