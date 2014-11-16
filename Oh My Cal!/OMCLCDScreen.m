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

#import <Carbon/Carbon.h>
#import "OMFPanelBackgroundView.h"

#import "OMCLCDScreen.h"
#import "OMCOperand.h"

#import "OMCBasicStyleCalculation.h"
#import "OMCScientificStyleCalculation.h"
#import "OMCProgrammerStyleCalculation.h"

#import "OMCCalWithBasicStyle.h"
#import "OMCCalWithScientificStyle.h"
#import "OMCCalWithProgrammerStyle.h"

#import <FBKVOController/NSObject+FBKVOController.h>

NSInteger static const kSpaceBarsCount = 4;

NSString static* const kKeyPathForTrigonometircModeInCalculations = @"self.trigonometricMode";
NSString static* const kKeyPathForHasMemoryInCalculations = @"self.hasMemory";
NSString static* const kKeyPathForTypingStateInCalculations = @"self.typingState";
NSString static* const kKeyPathForCurrentAryInCalculations = @"self.currentAry";
NSString static* const kKeyPathForIsInShiftInCalculations = @"self.isInShift";

// OMCLCDScreen class
@implementation OMCLCDScreen
    {
    NSRect _LCDBoundary;
    NSRect _gridPathBoundary;
    }

@synthesize KVOController = _KVOController;

@synthesize _mainPanelBackgroundView;

@synthesize _basicStyleCalculation;
@synthesize _scientificStyleCalculation;
@synthesize _programmerStyleCalculation;

@synthesize _calWithBasicStyle;
@synthesize _calWithScientificStyle;
@synthesize _calWithProgrammerStyle;

@dynamic currentCalculator;

@synthesize auxiliaryLinePath = _auxiliaryLinePath;
@synthesize gridPath = _gridPath;

@synthesize bottommostSpaceBar = _bottommostSpaceBar;
@synthesize secondSpaceBar = _secondSpaceBar;
@synthesize thirdSpaceBar = _thirdSpaceBar;
@synthesize topmostSpaceBar = _topmostSpaceBar;
@synthesize statusSpaceBar = _statusSpaceBar;

@synthesize gridColor = _gridColor;
@synthesize auxiliaryLineColor = _auxiliaryLineColor;
@synthesize operandsColor = _operandsColor;
@synthesize operatorsColor = _operatorsColor;
@synthesize storageFormulasColor = _storageFormulasColor;
@synthesize statusColor = _statusColor;

@synthesize operandsFont = _operandsFont;
@synthesize operatorsFont = _operatorsFont;
@synthesize storageFormulasFont = _storageFormulasFont;
@synthesize statusFont = _statusFont;

@dynamic typingState;
@dynamic currentAry;

@dynamic currentCalculation;

#pragma mark Overrides
- ( BOOL ) canBecomeKeyView
    {
    return YES;
    }

- ( BOOL ) acceptsFirstResponder
    {
    return YES;
    }

- ( BOOL ) resignFirstResponder
    {
    return NO;
    }

#pragma mark Initializers & Deallocators
- ( void ) awakeFromNib
    {
    self.gridColor = [ [ NSColor lightGrayColor ] colorWithAlphaComponent: .3 ];
    self.auxiliaryLineColor = [ NSColor colorWithDeviceRed: .3373f green: .3373f blue: .3412f alpha: 1.f ];
    self.operandsColor = [ NSColor whiteColor ];
    self.operatorsColor = self.operandsColor;   // Same as the color for operands
    self.storageFormulasColor = [ NSColor whiteColor ];
    self.statusColor = [ NSColor whiteColor ];

    self.operandsFont = [ NSFont fontWithName: @"PT Mono" size: 15 ];
    self.operatorsFont = [ [ NSFontManager sharedFontManager ] convertFont: self.operandsFont toSize: 13 ];
    self.storageFormulasFont = self.operandsFont;   // Same as the font for operands
    self.statusFont = [ NSFont fontWithName: @"Lucida Grande" size: 10 ];

    self.KVOController = [ FBKVOController controllerWithObserver: self ];
    [ self _addObserverForCalculations: self._basicStyleCalculation ];
    [ self _addObserverForCalculations: self._scientificStyleCalculation ];
    [ self _addObserverForCalculations: self._programmerStyleCalculation ];
    }

- ( void ) _addObserverForCalculations: ( OMCCalculation* )_Calculation
    {
    [ self.KVOController observe: _Calculation
                        keyPaths: @[ kKeyPathForTrigonometircModeInCalculations
                                   , kKeyPathForHasMemoryInCalculations
                                   , kKeyPathForCurrentAryInCalculations
                                   , kKeyPathForTypingStateInCalculations
                                   , kKeyPathForIsInShiftInCalculations ]
                         options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                           block:
        ^( NSString* _KeyPath, OMCLCDScreen* _Observer, OMCCalculation* _ObservedObject, NSDictionary* _Change )
            {
            if ( [ _KeyPath isEqualToString: kKeyPathForCurrentAryInCalculations ]
                        || [ _KeyPath isEqualToString: kKeyPathForTypingStateInCalculations ] )
                [ self setNeedsDisplay: YES ];

            else if ( [ _KeyPath isEqualToString: kKeyPathForTrigonometircModeInCalculations ]
                        || [ _KeyPath isEqualToString: kKeyPathForHasMemoryInCalculations ]
                        /* || [ _KeyPath isEqualToString: kKeyPathForCurrentAryInCalculations ] */
                        || [ _KeyPath isEqualToString: kKeyPathForIsInShiftInCalculations ] )
                [ self setNeedsDisplayInRect: self.statusSpaceBar ];
            } ];
    }

- ( void ) viewWillMoveToWindow: ( NSWindow* )_Window
    {
    _LCDBoundary = [ self bounds ];

    // Line Path
    [ self _regenerateLinePath ];
    }

- ( void ) _regenerateOperandSpaceBars
    {
    [ self _regenerateGridPath ];

    CGFloat spaceBarX = NSMinX( _gridPathBoundary );
    CGFloat spaceBarWidth = NSWidth( _gridPathBoundary );
    CGFloat spaceBarHeight = NSHeight( _gridPathBoundary ) / kSpaceBarsCount;

    self->_bottommostSpaceBar = NSMakeRect( spaceBarX
                                          , NSMinY( _gridPathBoundary )
                                          , spaceBarWidth
                                          , spaceBarHeight
                                          );

    self->_secondSpaceBar = NSMakeRect( spaceBarX
                                      , NSMaxY( self->_bottommostSpaceBar )
                                      , spaceBarWidth
                                      , spaceBarHeight
                                      );

    self->_thirdSpaceBar = NSMakeRect( spaceBarX
                                     , NSMaxY( self->_secondSpaceBar )
                                     , spaceBarWidth
                                     , spaceBarHeight
                                     );

    self->_topmostSpaceBar = NSMakeRect( spaceBarX
                                       , NSMaxY( self->_thirdSpaceBar )
                                       , spaceBarWidth
                                       , spaceBarHeight
                                       );

    CGFloat statusBarX = spaceBarX;
    CGFloat statusBarY = 5.f;
    CGFloat statusBarWidth = spaceBarWidth;
    CGFloat statusBarHeight = 20.f;
    self->_statusSpaceBar = NSMakeRect( statusBarX
                                      , statusBarY
                                      , statusBarWidth
                                      , statusBarHeight
                                      );
    }

- ( void ) _regenerateLinePath
    {
    [ self _regenerateOperandSpaceBars ];

    self.auxiliaryLinePath = [ NSBezierPath bezierPath ];
    [ self.auxiliaryLinePath moveToPoint: NSMakePoint( NSMinX( self.bottommostSpaceBar ), NSMaxY( self.bottommostSpaceBar ) ) ];
    [ self.auxiliaryLinePath lineToPoint: NSMakePoint( NSMaxX( self.bottommostSpaceBar ), NSMaxY( self.bottommostSpaceBar ) ) ];
    [ self.auxiliaryLinePath setLineWidth: 2 ];
    }

- ( void ) _regenerateGridPath
    {
    NSRect gridPathBounds = NSInsetRect( self.bounds, 10, 10 );
    gridPathBounds.size.height -= 26.5;

    NSAffineTransform* affine = [ NSAffineTransform transform ];
    [ affine translateXBy: 0.f yBy: 26.5 ];
    gridPathBounds.origin = [ affine transformPoint: gridPathBounds.origin ];

    _gridPathBoundary = gridPathBounds;

    self.gridPath = [ NSBezierPath bezierPathWithRect: gridPathBounds ];

    CGFloat height = gridPathBounds.size.height;
    CGFloat horizontalGridSpacing = height / kSpaceBarsCount;

    for ( int hor = 1; hor < height / horizontalGridSpacing; hor++ )
        {
        [ self.gridPath moveToPoint: NSMakePoint( NSMinX( gridPathBounds ), NSMinY( gridPathBounds ) + hor * horizontalGridSpacing ) ];
        [ self.gridPath lineToPoint: NSMakePoint( NSMaxX( gridPathBounds ), NSMinY( gridPathBounds ) + hor * horizontalGridSpacing ) ];
        }

    CGFloat dashes[ 2 ];
    dashes[ 0 ] = 1;
    dashes[ 1 ] = 2;
    [ self.gridPath setLineDash: dashes count: 2 phase: .0f ];
    }

#pragma mark Customize Drawing
- ( void ) _drawTheAuxiliaryLine
    {
    [ NSGraphicsContext saveGraphicsState ];
        [ self.auxiliaryLineColor set ];
        [ self.auxiliaryLinePath stroke ];
    [ NSGraphicsContext restoreGraphicsState ];
    }

- ( void ) _drawLhsOperandWithAttributes: ( NSDictionary* )_Attributes
    {
    /* When the user is typing left operand... */

    OMCOperand* operand = self.currentCalculation.lhsOperand;

    NSString* lhsOperandInString = ( self.typingState == OMCWaitAllOperands ) ? [ operand numericString ] : [ operand description ];
    lhsOperandInString = [ self _truncateStringFormOfOperand: lhsOperandInString
                                   withAttributesForOperands: _Attributes
                                              andForOperator: _Attributes ];

    /* ...we should only draw the left operand into the bottommost space bar. It's easy, isn't it? :) */
    [ lhsOperandInString drawAtPoint: [ self _pointUsedForDrawingOperands: lhsOperandInString inSpaceBar: self.bottommostSpaceBar ]
                      withAttributes: _Attributes ];
    }

- ( void ) _drawRhsOperandWithAttributesForOperands: ( NSDictionary* )_AttributesForOperands
                                     andForOperator: ( NSDictionary* )_AttributesForOperator
    {
    /* When the user is typing right operand... */

    OMCOperand* lhsOperand = self.currentCalculation.lhsOperand;
    OMCOperand* rhsOperand = self.currentCalculation.rhsOperand;

    NSString* lhsOperandInString = ( self.typingState == OMCWaitAllOperands ) ? [ lhsOperand numericString ] : [ lhsOperand description ];
    NSString* rhsOperandInString = ( self.typingState == OMCWaitRhsOperand ) ? [ rhsOperand numericString ] : [ rhsOperand description ];

    lhsOperandInString = [ self _truncateStringFormOfOperand: lhsOperandInString withAttributesForOperands: _AttributesForOperands andForOperator: _AttributesForOperator ];
    rhsOperandInString = [ self _truncateStringFormOfOperand: rhsOperandInString withAttributesForOperands: _AttributesForOperands andForOperator: _AttributesForOperator ];

    /* ...we must draw a left operand into the bottom third space bar... */
    [ lhsOperandInString drawAtPoint: [ self _pointUsedForDrawingOperands: lhsOperandInString inSpaceBar: self.thirdSpaceBar ]
                      withAttributes: _AttributesForOperands ];

    /* ...draw the right operand the user is typing into the bottom second space bar... */
    [ rhsOperandInString drawAtPoint: [ self _pointUsedForDrawingOperands: rhsOperandInString inSpaceBar: self.secondSpaceBar ]
                      withAttributes: _AttributesForOperands ];

    /* ...draw the operator the user selected into the bottom second space bar... */
    [ self.currentCalculation.theOperator drawAtPoint: [ self _pointUsedForDrawingOperators: self.currentCalculation.theOperator ]
                                       withAttributes: _AttributesForOperator ];

    /* ...and draw a auxiliary line! */
    [ self _drawTheAuxiliaryLine ];

    /* But wait! You might want to ask: where is the result value? Aha! */
    }

- ( void ) _drawResultValWithAttributesForOperands: ( NSDictionary* )_AttributesForOperands
                                    andForOperator: ( NSDictionary* )_AttributesForOperator
    {
    OMCOperand* resultValue = self.currentCalculation.resultValue;

    NSString* resultValueInString = [ resultValue description ];
    resultValueInString = [ self _truncateStringFormOfOperand: resultValueInString withAttributesForOperands: _AttributesForOperands andForOperator: _AttributesForOperator ];

    [ resultValueInString drawAtPoint: [ self _pointUsedForDrawingOperands: resultValueInString inSpaceBar: self.bottommostSpaceBar ]
                       withAttributes: _AttributesForOperands ];

    /* Draw all operand only for binomial
     * If current expression is monomial, draw the result value only... */
    if ( self.currentCalculation.isBinomialInLastCalculation
            && ![ resultValue.exceptionCarried isEqualToString: OMCOperandDivideByZeroException ] )
        [ self _drawRhsOperandWithAttributesForOperands: _AttributesForOperands
                                         andForOperator: _AttributesForOperator ];
    }

- ( NSString* ) _truncateStringFormOfOperand: ( NSString* )_OperandInString
                   withAttributesForOperands: ( NSDictionary* )_AttributesForOperands
                              andForOperator: ( NSDictionary* )_AttributesForOperator
    {
    NSSize sizeForCurrentOperator = [ self.currentCalculation.theOperator sizeWithAttributes: _AttributesForOperator ];
    NSSize sizeForDrawingOperandInString = [ _OperandInString sizeWithAttributes: _AttributesForOperands ];
    CGFloat widthOfBounds = NSWidth( self.bottommostSpaceBar ) - sizeForCurrentOperator.width - 20.f;

    if ( sizeForDrawingOperandInString.width > widthOfBounds )
        {
        NSString* sampleString = @"0";
        NSString* tail = @"...";

        NSInteger count = floor( widthOfBounds / [ sampleString sizeWithAttributes: _AttributesForOperands ].width ) - [ tail length ];
        NSString* truncatedString = [ _OperandInString substringToIndex: count ];
        truncatedString = [ truncatedString stringByAppendingString: tail ];

        return truncatedString;
        }

    return _OperandInString;
    }

/* Initial state of Oh My Cal!: 1. Left Operand is empty
 *                              2. Right Operand is empty
 *                              3. Operator is empty
 *                              4. Result Val is empty
 */
- ( void ) _drawPlaceholderForTypingState: ( OMCTypingState )_CurrentTypingState
                           withAttributes: ( NSDictionary* )_Attributes
    {
    NSString* placeholder = nil;
    OMCAry ary = self.currentAry;

    if ( self.currentCalculation.calStyle == OMCProgrammerStyle )
        {
        if ( ary == OMCOctal || ary == OMCDecimal )
            placeholder = @"0";
        else if ( ary == OMCHex )
            placeholder = @"0x0";
        }
    else
        placeholder = @"0";

     /* If Oh My Cal! is in the initial state or user has already typed *nothing* for current operand
      * draw a "0" for Octal and Decimal and a "0x0" for Hex, respectively. */
    if ( _CurrentTypingState == OMCWaitAllOperands
            /* If the length of lhsOperand is greater than 0, that means no need to draw the placeholder for left operand */
            && self.currentCalculation.lhsOperand.isZero
            && !self.currentCalculation.lhsOperand.isWaitingForFloatNumber )
        {
        // As with all calculators, the initial state should only be drawn in the bottommost space bar.
        [ placeholder drawAtPoint: [ self _pointUsedForDrawingOperands: placeholder inSpaceBar: self.bottommostSpaceBar ]
                   withAttributes: _Attributes ];
        }
    else if ( _CurrentTypingState == OMCWaitRhsOperand
            /* If the length of rhsOperand is greater than 0, that means no need to draw the placeholder for right operand */
            && self.currentCalculation.rhsOperand.isZero
            && !self.currentCalculation.rhsOperand.isWaitingForFloatNumber )
        {
        [ placeholder drawAtPoint: [ self _pointUsedForDrawingOperands: placeholder inSpaceBar: self.secondSpaceBar ]
                   withAttributes: _Attributes ];
        }
    }

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    [ self _regenerateLinePath ];
    [ self _regenerateGridPath ];
    [ self _regenerateOperandSpaceBars ];

    [ self.gridColor set ];
    [ self.gridPath stroke ];

    NSDictionary* drawingAttributesForOperands = @{ NSFontAttributeName : self.operandsFont
                                                  , NSForegroundColorAttributeName : self.operandsColor
                                                  };

    NSDictionary* drawingAttributesForOperators = @{ NSFontAttributeName : self.operatorsFont
                                                   , NSForegroundColorAttributeName : self.operatorsColor
                                                   };

    [ self _drawPlaceholderForTypingState: self.typingState
                           withAttributes: drawingAttributesForOperands ];

    switch ( self.typingState )
        {
    case OMCWaitAllOperands:
            {
            // User has not typed the right operand, he is just typing the left operand.
            [ self _drawLhsOperandWithAttributes: drawingAttributesForOperands ];
            } break;

    case OMCWaitRhsOperand:
            {
            [ self _drawRhsOperandWithAttributesForOperands: drawingAttributesForOperands
                                             andForOperator: drawingAttributesForOperators ];
            } break;

    case OMCFinishedTyping:
            {
            [ self _drawResultValWithAttributesForOperands: drawingAttributesForOperands
                                            andForOperator: drawingAttributesForOperators ];
            } break;
        }

    [ self _drawStatus ];
    }

/* Draw status */
- ( void ) _drawStatus
    {
    NSDictionary* drawingAttributesForStatus = @{ NSFontAttributeName : self.statusFont
                                                , NSForegroundColorAttributeName : self.statusColor
                                                };
    CGFloat gapInStatus = 10.f;

    //=======================================================================================================//
    // Drawing trigonometric mode
    NSString* RAD = @"Rad";
    NSString* DEG = @"Deg";
    NSString* trigonometricModeInString = ( self.currentCalculation.trigonometricMode == OMCRadianMode ) ? RAD : DEG;

    NSSize sizeForRAD = [ RAD sizeWithAttributes: drawingAttributesForStatus ];
    NSSize sizeForDEG = [ DEG sizeWithAttributes: drawingAttributesForStatus ];
    NSSize sizeForTrigonometricStatus = NSMakeSize( MAX( sizeForDEG.width, sizeForRAD.width ), MAX( sizeForDEG.height, sizeForRAD.height ) );

    NSRect rectForTrigonometricStatus = NSMakeRect( self.statusSpaceBar.origin.x
                                                  , self.statusSpaceBar.origin.y
                                                  , sizeForTrigonometricStatus.width
                                                  , sizeForTrigonometricStatus.height
                                                  );

    if ( self.currentCalculation.calStyle == OMCScientificStyle )
        [ trigonometricModeInString drawInRect: rectForTrigonometricStatus withAttributes: drawingAttributesForStatus ];

    //=======================================================================================================//
    // Drawing has memory
    NSString* hasMemoryInString = @"M";
    NSSize sizeForHasMemoryInString = [ hasMemoryInString sizeWithAttributes: drawingAttributesForStatus ];

    NSRect rectForHasMemoryStatus = NSMakeRect( NSMaxX( rectForTrigonometricStatus ) + gapInStatus
                                              , rectForTrigonometricStatus.origin.y
                                              , sizeForHasMemoryInString.width
                                              , sizeForHasMemoryInString.height
                                              );
    if ( self.currentCalculation.hasMemory )
        [ hasMemoryInString drawInRect: rectForHasMemoryStatus withAttributes: drawingAttributesForStatus ];

    //=======================================================================================================//
    // Drawing current ary
    NSString* currentAryInString = nil;
    if ( self.currentAry == OMCDecimal )         currentAryInString = @"DEC";
        else if ( self.currentAry == OMCOctal )  currentAryInString = @"OCT";
        else if ( self.currentAry == OMCHex )    currentAryInString = @"HEX";

    NSSize sizeForCurrentAryInString = [ currentAryInString sizeWithAttributes: drawingAttributesForStatus ];
    NSRect rectForCurrentAryInString = NSMakeRect( NSMaxX( rectForHasMemoryStatus ) + gapInStatus
                                                 , rectForHasMemoryStatus.origin.y
                                                 , sizeForCurrentAryInString.width
                                                 , sizeForCurrentAryInString.height
                                                 );

    if ( self.currentCalculation.calStyle == OMCProgrammerStyle )
        [ currentAryInString drawInRect: rectForCurrentAryInString withAttributes: drawingAttributesForStatus ];

    //=======================================================================================================//
    // Drawing shift state
    NSString* shiftStateInString = @"⇧";
    NSSize sizeForShiftInString = [ shiftStateInString sizeWithAttributes: drawingAttributesForStatus ];
    NSRect rectForShiftInString = NSMakeRect( NSMaxX( rectForCurrentAryInString ) + gapInStatus
                                            , rectForCurrentAryInString.origin.y
                                            , sizeForShiftInString.width
                                            , sizeForShiftInString.height
                                            );
                                            
    if ( self.currentCalculation.calStyle == OMCScientificStyle && self.currentCalculation.isInShift )
        [ shiftStateInString drawInRect: rectForShiftInString withAttributes: drawingAttributesForStatus ];
    }

- ( NSPoint ) _pointUsedForDrawingOperators: ( NSString* )_Operator
    {
    NSPoint pointUsedForDrawing = NSZeroPoint;

    if ( _Operator && _Operator.length > 0 )
        {
        NSSize size = [ _Operator sizeWithAttributes: @{ NSFontAttributeName : self.operatorsFont } ];

        CGFloat paddingForAesthetic = 5.f;
        pointUsedForDrawing.x = NSMinX( self->_secondSpaceBar ) + paddingForAesthetic;
        pointUsedForDrawing.y = NSMinY( self->_secondSpaceBar ) + ( NSHeight( self->_secondSpaceBar ) - size.height ) / 2;
        }

    return pointUsedForDrawing;
    }

- ( NSPoint ) _pointUsedForDrawingOperands: ( NSString* )_Operand
                                inSpaceBar: ( OMCSpaceBarRect )_SpaceBarRect
    {
    NSPoint pointUsedForDrawing = NSZeroPoint;

    if ( _Operand && _Operand.length > 0 )
        {
        NSSize size = [ _Operand sizeWithAttributes: @{ NSFontAttributeName : self.operandsFont } ];

        CGFloat paddingForAesthetic = 5.f;
        pointUsedForDrawing.x = NSMaxX( _SpaceBarRect ) - size.width - paddingForAesthetic;

        // Centered Vertically
        pointUsedForDrawing.y = NSMinY( _SpaceBarRect ) + ( NSHeight( _SpaceBarRect ) - size.height ) / 2;
        }

    return pointUsedForDrawing;
    }

#pragma mark Events Handling
- ( void ) keyDown: ( NSEvent* )_Event
    {
    unsigned short keyCodeOfTheEvent = [ _Event keyCode ];

    NSUInteger modifierFlags = [ _Event modifierFlags ];
    NSString* characters = [ _Event charactersIgnoringModifiers ];

    #define COMPARE_WITH_CHARACTERS( _Rhs ) COMPARE_WITH_CASE_INSENSITIVE( characters, _Rhs )

    BOOL isBasicStyle = ( self.currentCalculator == self._calWithBasicStyle );
    BOOL isScientificStyle = ( self.currentCalculator == self._calWithScientificStyle );
    BOOL isProgrammerStyle = ( self.currentCalculator == self._calWithProgrammerStyle );
    BOOL isHex = [ self.currentCalculation currentAry ] == OMCHex;

    SEL actionToBeSent = @selector( calculate: );
    id actionSender = nil;

    if ( COMPARE_WITH_CHARACTERS( @"1" ) )                  actionSender = self.currentCalculator._one;
    else if ( COMPARE_WITH_CHARACTERS( @"2" ) )             actionSender = self.currentCalculator._two;
    else if ( COMPARE_WITH_CHARACTERS( @"3" ) )             actionSender = self.currentCalculator._three;
    else if ( COMPARE_WITH_CHARACTERS( @"4" ) )             actionSender = self.currentCalculator._four;
    else if ( COMPARE_WITH_CHARACTERS( @"5" ) )             actionSender = self.currentCalculator._five;
    else if ( COMPARE_WITH_CHARACTERS( @"6" ) )             actionSender = self.currentCalculator._six;
    else if ( COMPARE_WITH_CHARACTERS( @"7" ) )             actionSender = self.currentCalculator._seven;
    else if ( COMPARE_WITH_CHARACTERS( @"8" ) )             actionSender = self.currentCalculator._eight;
    else if ( COMPARE_WITH_CHARACTERS( @"9" ) )             actionSender = self.currentCalculator._nine;

    else if ( COMPARE_WITH_CHARACTERS( @"0" ) && !( modifierFlags & NSAlternateKeyMask ) )
        /* Double zero is only available for Programmer Style */
        actionSender = self.currentCalculator._zero;
    // 00: : ⌥-0
    else if ( isProgrammerStyle && COMPARE_WITH_CHARACTERS( @"0" ) && ( modifierFlags & NSAlternateKeyMask ) )
        actionSender = self._calWithProgrammerStyle._doubleZero;

    else if ( ( isBasicStyle || isScientificStyle ) && COMPARE_WITH_CHARACTERS( @"." ) )
                                                            actionSender = self._calWithBasicStyle._floatPoint;

    // +
    else if ( COMPARE_WITH_CHARACTERS( @"+" ) )             actionSender = self.currentCalculator._additionOperator;
    // -
    else if ( COMPARE_WITH_CHARACTERS( @"-" ) )             actionSender = self.currentCalculator._subtractionOperator;
    // *
    else if ( COMPARE_WITH_CHARACTERS( @"*" ) )             actionSender = self.currentCalculator._multiplicationOperator;
    // /
    else if ( COMPARE_WITH_CHARACTERS( @"/" ) )             actionSender = self.currentCalculator._divisionOperator;

    // Percent
    else if ( isScientificStyle && COMPARE_WITH_CHARACTERS( @"%" ) )
                                                            actionSender = self._calWithScientificStyle._percent;
    // Pow
    else if ( isScientificStyle && COMPARE_WITH_CHARACTERS( @"^" ) )
                                                            actionSender = self._calWithScientificStyle._xPower;
    // In
    else if ( isScientificStyle && COMPARE_WITH_CHARACTERS( @"e" ) && !( modifierFlags & NSShiftKeyMask ) )
                                                            actionSender = self._calWithScientificStyle._In;
    // EE
    else if ( isScientificStyle && COMPARE_WITH_CHARACTERS( @"e" ) && ( modifierFlags & NSShiftKeyMask ) )
                                                            actionSender = self._calWithScientificStyle._EE;

    // Factorial
    else if ( ( isScientificStyle || isProgrammerStyle ) && COMPARE_WITH_CHARACTERS( @"!" ) )
        actionSender = self._calWithProgrammerStyle._factorialOperator;

    //=======================================================================================================
    // The following characters are only available for Programmer Style */
    else if ( isProgrammerStyle && isHex && COMPARE_WITH_CHARACTERS( @"A" ) && !( modifierFlags & NSCommandKeyMask ) )
                                                            actionSender = self._calWithProgrammerStyle._0xA;
    else if ( isProgrammerStyle && isHex && COMPARE_WITH_CHARACTERS( @"B" ) )
                                                            actionSender = self._calWithProgrammerStyle._0xB;
    else if ( isProgrammerStyle && isHex && COMPARE_WITH_CHARACTERS( @"C" ) )
                                                            actionSender = self._calWithProgrammerStyle._0xC;
    else if ( isProgrammerStyle && isHex && COMPARE_WITH_CHARACTERS( @"D" ) )
                                                            actionSender = self._calWithProgrammerStyle._0xD;
    else if ( isProgrammerStyle && isHex && COMPARE_WITH_CHARACTERS( @"E" ) )
                                                            actionSender = self._calWithProgrammerStyle._0xE;

    else if ( isProgrammerStyle && isHex && COMPARE_WITH_CHARACTERS( @"F" ) && !( modifierFlags & NSAlternateKeyMask ) )
        actionSender = self._calWithProgrammerStyle._0xF;
    // FF: ⌥F
    else if ( isProgrammerStyle && isHex && COMPARE_WITH_CHARACTERS( @"F" ) && ( modifierFlags & NSAlternateKeyMask ) )
        actionSender = self._calWithProgrammerStyle._0xFF;

    // AND: ⌘A
    else if ( COMPARE_WITH_CHARACTERS( @"A" ) && ( modifierFlags & NSCommandKeyMask ) )
        actionSender = self._calWithProgrammerStyle._andOperator;
    // OR: ⌘O
    else if ( COMPARE_WITH_CHARACTERS( @"O" ) && ( modifierFlags & NSCommandKeyMask ) )
        actionSender = self._calWithProgrammerStyle._orOperator;
    // NOR: ⌘N
    else if ( COMPARE_WITH_CHARACTERS( @"N" ) && ( modifierFlags & NSCommandKeyMask ) )
        actionSender = self._calWithProgrammerStyle._norOperator;
    // XOR: ⌘⇧X
    else if ( COMPARE_WITH_CHARACTERS( @"X" ) && ( modifierFlags & NSCommandKeyMask ) && ( modifierFlags & NSShiftKeyMask ) )
        actionSender = self._calWithProgrammerStyle._xorOperator;

    // RoL
    else if ( isProgrammerStyle && COMPARE_WITH_CHARACTERS( @"L" ) && !( modifierFlags & NSCommandKeyMask ) )
        actionSender = self._calWithProgrammerStyle._rolOperator;
    // RoR
    else if ( isProgrammerStyle && COMPARE_WITH_CHARACTERS( @"R" ) && !( modifierFlags & NSCommandKeyMask ) )
        actionSender = self._calWithProgrammerStyle._rorOperator;
    // Lsh: ⌘L
    else if ( isProgrammerStyle && COMPARE_WITH_CHARACTERS( @"L" ) && ( modifierFlags & NSCommandKeyMask ) )
        actionSender = self._calWithProgrammerStyle._lshOperator;
    // Rsh: ⌘R
    else if ( isProgrammerStyle && COMPARE_WITH_CHARACTERS( @"R" ) && ( modifierFlags & NSCommandKeyMask ) )
        actionSender = self._calWithProgrammerStyle._rshOperator;

    // Mod: ⌘M
    else if ( isProgrammerStyle && COMPARE_WITH_CHARACTERS( @"M" ) && ( modifierFlags & NSCommandKeyMask ) )
        actionSender = self._calWithProgrammerStyle._modOperator;

    // DEL: ⌫
    else if ( ( keyCodeOfTheEvent == kVK_Delete || keyCodeOfTheEvent == kVK_ForwardDelete )
                && !( modifierFlags & NSCommandKeyMask ) && !( modifierFlags & NSShiftKeyMask ) )
        actionSender = self.currentCalculator._del;
    // Clear: ⌘⌫
    else if ( ( keyCodeOfTheEvent == kVK_Delete  && ( modifierFlags & NSCommandKeyMask ) && !( modifierFlags & NSShiftKeyMask ) )
                || keyCodeOfTheEvent == kVK_ANSI_KeypadClear /* kVK_ANSI_K */)
        actionSender = self.currentCalculator._clear;

    // Clear All: ⌘⇧⌫
    else if ( keyCodeOfTheEvent == kVK_Delete && ( modifierFlags & NSCommandKeyMask ) && ( modifierFlags & NSShiftKeyMask ) )
        actionSender = self.currentCalculator._clearAll;

    // Enter: ↵
    else if ( keyCodeOfTheEvent == kVK_Return || keyCodeOfTheEvent == kVK_ANSI_KeypadEnter || keyCodeOfTheEvent == kVK_ANSI_KeypadEquals /* kVK_ANSI_Q */)
        actionSender = self.currentCalculator._enterOperator;

    if ( actionSender )
        {
        [ NSApp sendAction: actionToBeSent to: self.currentCalculation from: actionSender ];
        return;
        }

    [ super keyDown: _Event ];
    }

#pragma mark Dynamically Synthesize the Accessors
+ ( BOOL ) resolveInstanceMethod: ( SEL )_Sel
    {
    Class class = [ self class ];

    IMP implementation = nil;
    char* types = nil;
    if ( _Sel == @selector( typingState ) )
        {
        implementation = ( IMP )_typingStateIMP;
        types = "s@:";
        }
    else if ( _Sel == @selector( currentAry ) )
        {
        implementation = ( IMP )_currentAryIMP;
        types = "s@:";
        }
    else if ( _Sel == @selector( currentCalculation ) )
        {
        implementation = ( IMP )_currentCalculationIMP;
        types = "@@:";
        }
    else if ( _Sel == @selector( currentCalculator ) )
        {
        implementation = ( IMP )_currentCalculatorIMP;
        types = "@@:";
        }

    if ( ( implementation && types )
            && class_addMethod( class, _Sel, implementation, types ) )
        return YES;

    return [ super resolveInstanceMethod: _Sel ];
    }

OMCTypingState _typingStateIMP( id self, SEL _cmd )
    {
    return ( ( OMCLCDScreen* )self ).currentCalculation.typingState;
    }

OMCAry _currentAryIMP( id self, SEL _cmd )
    {
    return ( ( OMCLCDScreen* )self ).currentCalculation.currentAry;
    }

OMCCalculation* _currentCalculationIMP( id self, SEL _cmd )
    {
    OMCCalStyle defaultCalStyle = [ ( ( OMCLCDScreen* )self )._mainPanelBackgroundView _currentCalStyle ];

    if ( defaultCalStyle == OMCBasicStyle )             return ( ( OMCLCDScreen* )self )._basicStyleCalculation;
    else if ( defaultCalStyle == OMCScientificStyle )   return ( ( OMCLCDScreen* )self )._scientificStyleCalculation;
    else if ( defaultCalStyle == OMCProgrammerStyle )   return ( ( OMCLCDScreen* )self )._programmerStyleCalculation;

    return nil;
    }

OMCCal* _currentCalculatorIMP( id self, SEL _cmd )
    {
    return ( ( OMCLCDScreen* )self )._mainPanelBackgroundView.currentCalculator;
    }

#pragma mark IBActions
- ( IBAction ) cut: ( id )_Sender
    {
    [ self copy: _Sender ];

    OMCTypingState currentTypingState = [ self typingState ];
    if ( currentTypingState == OMCWaitAllOperands )
        {
        [ self.currentCalculation.lhsOperand zeroed ];
        self.currentCalculation.typingState = OMCWaitAllOperands;
        }
    else if ( currentTypingState == OMCWaitRhsOperand )
        {
        [ self.currentCalculation.rhsOperand zeroed ];
        self.currentCalculation.typingState = OMCWaitRhsOperand;
        }
    else if ( currentTypingState == OMCFinishedTyping )
        {
        [ self.currentCalculation clearAllAndReset ];
        self.currentCalculation.typingState = OMCWaitAllOperands;
        }
    }

- ( IBAction ) copy: ( id )_Sender
    {
    OMCTypingState currentTypingState = [ self typingState ];
    OMCOperand* operandToBeCopied = nil;

    if ( currentTypingState == OMCWaitAllOperands )
        operandToBeCopied = [ [ self currentCalculation ] lhsOperand ];
    else if ( currentTypingState == OMCWaitRhsOperand )
        operandToBeCopied = [ [ self currentCalculation ] rhsOperand ];
    else if ( currentTypingState == OMCFinishedTyping )
        operandToBeCopied = [ [ self currentCalculation ] resultValue ];

    [ operandToBeCopied writeToPasteboard: GENERAL_PASTEBOARD ];
    }

- ( IBAction ) paste: ( id )_Sender
    {
    NSArray* classes = @[ [ OMCOperand class ] ];
    NSDictionary* readingOptions = [ NSDictionary dictionary ];
    OMCTypingState currentTypingState = [ self typingState ];

    if ( [ GENERAL_PASTEBOARD canReadObjectForClasses: classes options: readingOptions ] )
        {
        OMCOperand* operandFromPboard = [ GENERAL_PASTEBOARD readObjectsForClasses: classes options: readingOptions ].firstObject;

        /* The calStyle and currentAry in operandFromPboard may be out of date:
         * current calStyle and currentAry properties may be changed after this operand was archived */
        [ operandFromPboard setCalStyle: self.currentCalculation.calStyle ];
        [ operandFromPboard setCurrentAry: self.currentAry ];

        if ( currentTypingState == OMCWaitAllOperands )
            {
            self.currentCalculation.lhsOperand = operandFromPboard;
            self.currentCalculation.typingState = OMCWaitAllOperands;
            }
        else if ( currentTypingState == OMCWaitRhsOperand )
            {
            self.currentCalculation.rhsOperand = operandFromPboard;
            self.currentCalculation.typingState = OMCWaitRhsOperand;
            }
        else if ( currentTypingState == OMCFinishedTyping )
            {
            [ self.currentCalculation clearAllAndReset ];
            self.currentCalculation.lhsOperand = operandFromPboard;
            self.currentCalculation.typingState = OMCWaitAllOperands;
            }
        }
    }

@end // OMCLCDScreen class

#pragma mark Validate the 'Cut', 'Copy' and 'Paste' menu item
@implementation OMCLCDScreen ( OMCLCDScreenValidation )

- ( BOOL ) validateUserInterfaceItem: ( id <NSValidatedUserInterfaceItem> )_TheItemToBeValidated
    {
    if ( [ _TheItemToBeValidated action ] == @selector( paste: ) )
        {
        NSArray* classes = @[ [ OMCOperand class ] ];
        NSDictionary* options = [ NSDictionary dictionary ];
        if ( [ GENERAL_PASTEBOARD canReadObjectForClasses: classes options: options ] )
            {
            OMCOperand* theOperandOnPasteboard = [ GENERAL_PASTEBOARD readObjectsForClasses: classes options: options ].firstObject;

            if ( !theOperandOnPasteboard || [ theOperandOnPasteboard isNaN ] )
                return NO;
            }
        else
            return NO;
        }

    return YES;

    /* The Super class of OMCLCDScreen doesn't conform to <NSUserInterfaceValidations> protocol
     * so there is no necessary to forward this method to super */
    }

@end // OMCLCDScreen + OMCLCDScreenValidation

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