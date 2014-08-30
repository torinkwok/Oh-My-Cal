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

#import "OMCLCDScreen.h"
#import "OMCCalculation.h"

NSInteger static const kSpaceBarsCount = 4;

// OMCLCDScreen class
@implementation OMCLCDScreen
    {
    NSRect _LCDBoundary;
    NSRect _gridPathBoundary;
    }

@synthesize _calculation;

@synthesize linePath = _linePath;
@synthesize gridPath = _gridPath;

@synthesize bottommostSpaceBar = _bottommostSpaceBar;
@synthesize secondSpaceBar = _secondSpaceBar;
@synthesize thirdSpaceBar = _thirdSpaceBar;
@synthesize topmostSpaceBar = _topmostSpaceBar;

@synthesize gridColor = _gridColor;
@synthesize auxiliaryLineColor = _auxiliaryLineColor;
@synthesize operandsColor = _operandsColor;
@synthesize operatorsColor = _operatorsColor;
@synthesize storageFormulasColor = _storageFormulasColor;

@synthesize operandsFont = _operandsFont;
@synthesize operatorsFont = _operatorsFont;
@synthesize storageFormulasFont = _storageFormulasFont;

@synthesize typingState = _typingState;
@synthesize currentAry = _currentAry;

- ( BOOL ) canBecomeKeyView
    {
    return YES;
    }

#pragma mark Initializers & Deallocators
- ( void ) awakeFromNib
    {
    self.gridColor = [ [ NSColor lightGrayColor ] colorWithAlphaComponent: .3 ];
    self.auxiliaryLineColor = [ NSColor colorWithDeviceRed: .3373f green: .3373f blue: .3412f alpha: 1.f ];
    self.operandsColor = [ NSColor whiteColor ];
    self.operatorsColor = self.operandsColor;
    self.storageFormulasColor = [ NSColor whiteColor ];

    self.operandsFont = [ NSFont fontWithName: @"Lucida Grande" size: 15 ];
    self.operatorsFont = [ [ NSFontManager sharedFontManager ] convertFont: self.operandsFont toSize: 11 ];
    self.storageFormulasFont = self.operandsFont;

    [ self setTypingState: OMCWaitAllOperands ];
    [ self setCurrentAry: ( OMCAry )[ USER_DEFAULTS objectForKey: OMCDefaultsKeyAry ] ];

    [ NOTIFICATION_CENTER addObserver: self
                             selector: @selector( currentTypingStateDidChanged: )
                                 name: OMCCurrentTypingStateDidChangedNotification
                               object: self._calculation ];
    }

- ( void ) currentTypingStateDidChanged: ( NSNotification* )_Notif
    {
    [ self setNeedsDisplay: YES ];
    }

- ( void ) viewWillMoveToWindow: ( NSWindow* )_Window
    {
    _LCDBoundary = [ self bounds ];

    // Line Path
    [ self _initializeLinePath ];
    }

- ( void ) _initializeOperandSpaceBars
    {
    [ self _initializeGridPath ];

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
    }

- ( void ) _initializeLinePath
    {
    if ( !self.linePath )
        {
        [ self _initializeOperandSpaceBars ];

        self.linePath = [ NSBezierPath bezierPath ];
        [ self.linePath moveToPoint: NSMakePoint( NSMinX( self.bottommostSpaceBar ), NSMaxY( self.bottommostSpaceBar ) ) ];
        [ self.linePath lineToPoint: NSMakePoint( NSMaxX( self.bottommostSpaceBar ), NSMaxY( self.bottommostSpaceBar ) ) ];
        [ self.linePath setLineWidth: 2 ];
        }
    }

- ( void ) _initializeGridPath
    {
    if ( !self.gridPath )
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
    }

#pragma mark Customize Drawing
- ( void ) _drawTheAuxiliaryLine
    {
    [ NSGraphicsContext saveGraphicsState ];
        [ self.auxiliaryLineColor set ];
        [ self.linePath stroke ];
    [ NSGraphicsContext restoreGraphicsState ];
    }

- ( void ) _drawLhsOperandWithAttributes: ( NSDictionary* )_Attributes
    {
    [ self._calculation.lhsOperand drawAtPoint: [ self _pointUsedForDrawingOperands: self._calculation.lhsOperand inSpaceBar: self.bottommostSpaceBar ]
                                withAttributes: _Attributes ];
    }

- ( void ) _drawRhsOperandWithAttributesForOperands: ( NSDictionary* )_AttributesForOperands
                                     andForOperator: ( NSDictionary* )_AttributesForOperator
    {
    [ self._calculation.lhsOperand drawAtPoint: [ self _pointUsedForDrawingOperands: self._calculation.lhsOperand inSpaceBar: self.thirdSpaceBar ]
                    withAttributes: _AttributesForOperands ];

    [ self._calculation.rhsOperand drawAtPoint: [ self _pointUsedForDrawingOperands: self._calculation.rhsOperand inSpaceBar: self.secondSpaceBar ]
                                withAttributes: _AttributesForOperands ];

    [ self._calculation.theOperator drawAtPoint: [ self _pointUsedForDrawingOperators: self._calculation.theOperator ]
                    withAttributes: _AttributesForOperator ];

    [ self _drawTheAuxiliaryLine ];
    }

- ( void ) _drawResultValWithAttributesForOperands: ( NSDictionary* )_AttributesForOperands
                                    andForOperator: ( NSDictionary* )_AttributesForOperator
    {
    [ self._calculation.resultValue drawAtPoint: [ self _pointUsedForDrawingOperands: self._calculation.resultValue inSpaceBar: self.bottommostSpaceBar ]
                                 withAttributes: _AttributesForOperands ];

    [ self _drawRhsOperandWithAttributesForOperands: _AttributesForOperands
                                     andForOperator: _AttributesForOperator ];
    }

- ( void ) _drawInitialStateWithAttributes: ( NSDictionary* )_Attribtues
    {
    NSString* initialState = @"0";
    [ initialState drawAtPoint: [ self _pointUsedForDrawingOperands: initialState inSpaceBar: self.bottommostSpaceBar ]
                withAttributes: _Attribtues ];
    }

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    [ self.gridColor set ];
    [ self.gridPath stroke ];

    NSDictionary* drawingAttributesForOperands = @{ NSFontAttributeName : self.operandsFont
                                                  , NSForegroundColorAttributeName : self.operandsColor
                                                  };

    NSDictionary* drawingAttributesForOperators = @{ NSFontAttributeName : self.operatorsFont
                                                   , NSForegroundColorAttributeName : self.operatorsColor
                                                   };

    if ( self._calculation.typingState == OMCWaitAllOperands
            && self._calculation.lhsOperand.length == 0 )
        [ self _drawInitialStateWithAttributes: drawingAttributesForOperands ];

    switch ( self._calculation.typingState )
        {
    case OMCWaitAllOperands:
            {
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

#if 0
    [ self.lhsOperand drawAtPoint: [ self _pointUsedForDrawingOperands: self.lhsOperand inSpaceBar: self.bottommostSpaceBar ]
                   withAttributes: drawingAttributesForOperands ];

    [ self.rhsOperand drawAtPoint: [ self _pointUsedForDrawingOperands: self.rhsOperand inSpaceBar: self.secondSpaceBar ]
                   withAttributes: drawingAttributesForOperands ];

    [ self.resultValue drawAtPoint: [ self _pointUsedForDrawingOperands: self.resultValue inSpaceBar: self.thirdSpaceBar ]
                    withAttributes: drawingAttributesForOperands ];

    [ self.resultValue drawAtPoint: [ self _pointUsedForDrawingOperands: self.resultValue inSpaceBar: self.topmostSpaceBar ]
                    withAttributes: drawingAttributesForOperands ];

    [ @"AND" drawAtPoint: [ self _pointUsedForDrawingOperators: @"+" ]
          withAttributes: @{ NSFontAttributeName : self.operatorsFont
                           , NSForegroundColorAttributeName: self.operatorsColor } ];

    [ self.auxiliaryLineColor set ];
    [ self.linePath stroke ];
#endif
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