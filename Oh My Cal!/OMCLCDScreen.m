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

#import "OMFPanelBackgroundView.h"

#import "OMCLCDScreen.h"
#import "OMCOperand.h"

#import "OMCBasicStyleCalculation.h"
#import "OMCScientificStyleCalculation.h"
#import "OMCProgrammerStyleCalculation.h"

#import "OMCCalWithBasicStyle.h"
#import "OMCCalWithProgrammerStyle.h"

NSInteger static const kSpaceBarsCount = 4;

NSString static* const kKeyPathForCurrentCalStyleInMainPanelBackgroundView = @"self._currentCalStyle";
NSString static* const kKeyPathForTrigonometircModeInCalculations = @"self.trigonometricMode";
NSString static* const kKeyPathForHasMemoryInCalculations = @"self.hasMemory";
NSString static* const kKeyPathCurrentAryInCalculations = @"self.currentAry";

// OMCLCDScreen class
@implementation OMCLCDScreen
    {
    NSRect _LCDBoundary;
    NSRect _gridPathBoundary;
    }

@synthesize _mainPanelBackgroundView;

@synthesize _basicStyleCalculation;
@synthesize _scientificStyleCalculation;
@synthesize _programmerStyleCalculation;

@synthesize _calWithBasicStyle;
@synthesize _calWithScientificStyle;
@synthesize _calWithProgrammerStyle;

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

@synthesize typingState = _typingState;
@synthesize currentAry = _currentAry;

@synthesize currentCalculation = _currentCalculation;

- ( BOOL ) canBecomeKeyView
    {
    return YES;
    }

- ( BOOL ) acceptsFirstResponder
    {
    return YES;
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

    [ self setTypingState: OMCWaitAllOperands ];
    [ self setCurrentAry: ( OMCAry )[ USER_DEFAULTS objectForKey: OMCDefaultsKeyAry ] ];

    [ self _addObserverForCalculations: self._basicStyleCalculation ];
    [ self _addObserverForCalculations: self._scientificStyleCalculation ];
    [ self _addObserverForCalculations: self._programmerStyleCalculation ];

    [ self._mainPanelBackgroundView addObserver: self
                                     forKeyPath: kKeyPathForCurrentCalStyleInMainPanelBackgroundView
                                        options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                        context: NULL ];
                                        
    [ self.currentCalculation addObserver: self
                               forKeyPath: kKeyPathForCurrentCalStyleInMainPanelBackgroundView
                                  options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                  context: NULL ];
    }

- ( void ) observeValueForKeyPath: ( NSString* )_KeyPath
                         ofObject: ( id )_Object
                           change: ( NSDictionary* )_Change
                           context: ( void* )_Context
    {
    if ( [ _KeyPath isEqualToString: kKeyPathForCurrentCalStyleInMainPanelBackgroundView ] )
        {
        OMCCalStyle style = ( OMCCalStyle )[ _Change[ @"new" ] intValue ];

        if ( style == OMCBasicStyle )
            self.currentCalculation = self._basicStyleCalculation;
        else if ( style == OMCScientificStyle )
            self.currentCalculation = self._scientificStyleCalculation;
        else if ( style == OMCProgrammerStyle )
            self.currentCalculation = self._programmerStyleCalculation;
        }
    else if ( [ _KeyPath isEqualToString: kKeyPathForTrigonometircModeInCalculations ]
                || [ _KeyPath isEqualToString: kKeyPathForHasMemoryInCalculations ]
                || [ _KeyPath isEqualToString: kKeyPathCurrentAryInCalculations ] )
        [ self setNeedsDisplayInRect: self.statusSpaceBar ];
    }

- ( void ) _addObserverForCalculations: ( OMCCalculation* )_Calculation
    {
    [ NOTIFICATION_CENTER addObserver: self
                             selector: @selector( currentTypingStateDidChanged: )
                                 name: OMCCurrentTypingStateDidChangedNotification
                               object: _Calculation ];

    [ NOTIFICATION_CENTER addObserver: self
                             selector: @selector( currentTypingStateDidChanged: )
                                 name: OMCCurrentAryDidChangedNotification
                               object: _Calculation ];

    [ _Calculation addObserver: self
                    forKeyPath: kKeyPathForTrigonometircModeInCalculations
                       options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                       context: NULL ];

    [ _Calculation addObserver: self
                    forKeyPath: kKeyPathForHasMemoryInCalculations
                       options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                       context: NULL ];

    [ _Calculation addObserver: self
                    forKeyPath: kKeyPathCurrentAryInCalculations
                       options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                       context: NULL ];
    }

- ( void ) currentTypingStateDidChanged: ( NSNotification* )_Notif
    {
    [ self setTypingState: [ _Notif.userInfo[ OMCCalculationNewTypingState ] intValue ] ];
    [ self setNeedsDisplay: YES ];
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

    [ resultValueInString drawAtPoint: [ self _pointUsedForDrawingOperands: resultValueInString inSpaceBar: self.bottommostSpaceBar ]
                       withAttributes: _AttributesForOperands ];

    /* Draw all operand only for binomial
     * If current expression is monomial, draw the result value only... */
    if ( self.currentCalculation.isBinomialInLastCalculation
            && ![ resultValue.exceptionCarried isEqualToString: OMCOperandDivideByZeroException ] )
        [ self _drawRhsOperandWithAttributesForOperands: _AttributesForOperands
                                         andForOperator: _AttributesForOperator ];
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
    OMCAry currentAry = self.currentCalculation.currentAry;

    if ( currentAry == OMCOctal || currentAry == OMCDecimal )
        placeholder = @"0";
    else if ( currentAry == OMCHex )
        placeholder = @"0x0";

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

    [ self _drawPlaceholderForTypingState: self.currentCalculation.typingState
                           withAttributes: drawingAttributesForOperands ];

    switch ( self.currentCalculation.typingState )
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
    if ( self.currentCalculation.currentAry == OMCDecimal )         currentAryInString = @"DEC";
        else if ( self.currentCalculation.currentAry == OMCOctal )  currentAryInString = @"OCT";
        else if ( self.currentCalculation.currentAry == OMCHex )    currentAryInString = @"HEX";

    NSSize sizeForCurrentAryInString = [ currentAryInString sizeWithAttributes: drawingAttributesForStatus ];
    NSRect rectForCurrentAryInString = NSMakeRect( NSMaxX( rectForHasMemoryStatus ) + gapInStatus
                                                 , rectForHasMemoryStatus.origin.y
                                                 , sizeForCurrentAryInString.width
                                                 , sizeForCurrentAryInString.height
                                                 );

    if ( self.currentCalculation.calStyle == OMCProgrammerStyle )
    [ currentAryInString drawInRect: rectForCurrentAryInString withAttributes: drawingAttributesForStatus ];
    }

- ( void ) _drawTrigonometricStatusWithAttributes: ( NSDictionary* )_Attributes
    {

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
    NSUInteger modifierFlags = [ _Event modifierFlags ];
    NSString* characters = [ _Event charactersIgnoringModifiers ];
    BOOL isHex = [ self.currentCalculation currentAry ] == OMCHex;

    SEL actionToBeSent = @selector( calculate: );
    id actionSender = nil;

    if ( [ characters isEqualToString: @"1" ] )
        actionSender = self._calWithProgrammerStyle._one;
    else if ( [ characters isEqualToString: @"2" ] )
        actionSender = self._calWithProgrammerStyle._two;
    else if ( [ characters isEqualToString: @"3" ] )
        actionSender = self._calWithProgrammerStyle._three;
    else if ( [ characters isEqualToString: @"4" ] )
        actionSender = self._calWithProgrammerStyle._four;
    else if ( [ characters isEqualToString: @"5" ] )
        actionSender = self._calWithProgrammerStyle._five;
    else if ( [ characters isEqualToString: @"6" ] )
        actionSender = self._calWithProgrammerStyle._six;
    else if ( [ characters isEqualToString: @"7" ] )
        actionSender = self._calWithProgrammerStyle._seven;
    else if ( [ characters isEqualToString: @"8" ] )
        actionSender = self._calWithProgrammerStyle._eight;
    else if ( [ characters isEqualToString: @"9" ] )
        actionSender = self._calWithProgrammerStyle._nine;
    else if ( [ characters isEqualToString: @"0" ] && !( modifierFlags & NSAlternateKeyMask ) )
        actionSender = self._calWithProgrammerStyle._zero;
    // 00: : ⌥-0
    else if ( [ characters isEqualToString: @"0" ] && ( modifierFlags & NSAlternateKeyMask ) )
        actionSender = self._calWithProgrammerStyle._doubleZero;

    else if ( isHex && [ characters isCaseInsensitiveLike: @"A" ] && !( modifierFlags & NSCommandKeyMask ) )
        actionSender = self._calWithProgrammerStyle._0xA;
    else if ( isHex && [ characters isCaseInsensitiveLike: @"B" ] )
        actionSender = self._calWithProgrammerStyle._0xB;
    else if ( isHex && [ characters isCaseInsensitiveLike: @"C" ] )
        actionSender = self._calWithProgrammerStyle._0xC;
    else if ( isHex && [ characters isCaseInsensitiveLike: @"D" ] )
        actionSender = self._calWithProgrammerStyle._0xD;
    else if ( isHex && [ characters isCaseInsensitiveLike: @"E" ] )
        actionSender = self._calWithProgrammerStyle._0xE;
    else if ( isHex && [ characters isCaseInsensitiveLike: @"F" ] && !( modifierFlags & NSAlternateKeyMask ) )
        actionSender = self._calWithProgrammerStyle._0xF;
    // FF: ⌥-F
    else if ( isHex && [ characters isCaseInsensitiveLike: @"F" ] && ( modifierFlags & NSAlternateKeyMask ) )
        actionSender = self._calWithProgrammerStyle._0xFF;

    // AND: ⌘-A
    else if ( [ characters isCaseInsensitiveLike: @"A" ] && ( modifierFlags & NSCommandKeyMask ) )
        actionSender = self._calWithProgrammerStyle._andOperator;
    // OR: ⌘-O
    else if ( [ characters isCaseInsensitiveLike: @"O" ] && ( modifierFlags & NSCommandKeyMask ) )
        actionSender = self._calWithProgrammerStyle._orOperator;
    // NOR: ⌘-N
    else if ( [ characters isCaseInsensitiveLike: @"N" ] && ( modifierFlags & NSCommandKeyMask ) )
        actionSender = self._calWithProgrammerStyle._norOperator;
    // XOR: ⌘-X
    else if ( [ characters isCaseInsensitiveLike: @"X" ] && ( modifierFlags & NSCommandKeyMask ) )
        actionSender = self._calWithProgrammerStyle._xorOperator;

    // RoL
    else if ( [ characters isCaseInsensitiveLike: @"L" ] && !( modifierFlags & NSCommandKeyMask ) )
        actionSender = self._calWithProgrammerStyle._rolOperator;
    // RoR
    else if ( [ characters isCaseInsensitiveLike: @"R" ] && !( modifierFlags & NSCommandKeyMask ) )
        actionSender = self._calWithProgrammerStyle._rorOperator;
    // Lsh: ⌘-L
    else if ( [ characters isCaseInsensitiveLike: @"L" ] && ( modifierFlags & NSCommandKeyMask ) )
        actionSender = self._calWithProgrammerStyle._lshOperator;
    // Rsh: ⌘-R
    else if ( [ characters isCaseInsensitiveLike: @"R" ] && ( modifierFlags & NSCommandKeyMask ) )
        actionSender = self._calWithProgrammerStyle._rshOperator;

    // +
    else if ( [ characters isEqualToString: @"+" ] )
        actionSender = self._calWithProgrammerStyle._additionOperator;
    // -
    else if ( [ characters isEqualToString: @"-" ] )
        actionSender = self._calWithProgrammerStyle._subtractionOperator;
    // *
    else if ( [ characters isEqualToString: @"*" ] )
        actionSender = self._calWithProgrammerStyle._multiplicationOperator;
    // /
    
    else if ( [ characters isEqualToString: @"/" ] )
        actionSender = self._calWithProgrammerStyle._divisionOperator;

    // Mod: ⌘-M
    else if ( [ characters isCaseInsensitiveLike: @"M" ] && ( modifierFlags & NSCommandKeyMask ) )
        actionSender = self._calWithProgrammerStyle._modOperator;
    // Factorial
    else if ( [ characters isEqualToString: @"!" ] )
        actionSender = self._calWithProgrammerStyle._factorialOperator;

    // DEL: Delete
    else if ( _Event.keyCode == 51 && !( modifierFlags & NSCommandKeyMask ) && !( modifierFlags & NSShiftKeyMask ) )
        actionSender = self._calWithProgrammerStyle._del;
    // Clear: ⌘-Delete
    else if ( _Event.keyCode == 51 && ( modifierFlags & NSCommandKeyMask ) && !( modifierFlags & NSShiftKeyMask ) )
        actionSender = self._calWithProgrammerStyle._clear;
    // Clear All: ⌘-⇧-Delete
    else if ( _Event.keyCode == 51 && ( modifierFlags & NSCommandKeyMask ) && ( modifierFlags & NSShiftKeyMask ) )
        actionSender = self._calWithProgrammerStyle._clearAll;

    // Enter: Return
    else if ( _Event.keyCode == 36 )
        actionSender = self._calWithProgrammerStyle._enterOperator;

    if ( actionSender )
        {
        [ NSApp sendAction: actionToBeSent to: self.currentCalculation from: actionSender ];
        return;
        }

    [ super keyDown: _Event ];
    }

@end // OMCLCDScreen class

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