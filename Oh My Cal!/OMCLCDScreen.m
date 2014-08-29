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

CGFloat static const kXPadding = 20.f;
CGFloat static const kYPadding = 10.f;

// OMCLCDScreen class
@implementation OMCLCDScreen
    {
    NSFont* _drawingFont;

    NSRect _boundary;
    NSRect _gridPathBoundary;
    CGFloat _spaceX;
    CGFloat _spaceWidth;
    CGFloat _spaceHeight;
    }

@synthesize _calculation;

@synthesize linePath = _linePath;
@synthesize gridPath = _gridPath;

@synthesize bottommostSpaceBar = _bottommostSpaceBar;
@synthesize secondSpaceBar = _secondSpaceBar;
@synthesize thirdSpaceBar = _thirdSpaceBar;
@synthesize topmostSpaceBar = _topmostSpaceBar;

- ( BOOL ) canBecomeKeyView
    {
    return YES;
    }

#pragma mark Initializers & Deallocators
- ( void ) viewWillMoveToWindow: ( NSWindow* )_Window
    {
    _boundary = [ self bounds ];

    _spaceX = NSMinX( _boundary ) + kXPadding;
    _spaceWidth = NSWidth( _boundary ) - kXPadding;
    _spaceHeight = 26.5f;

    // Grid Path
    [ self _initializeGridPath ];

    // Operands
    [ self _initializeOprands ];

    // Operand Spaces
    [ self _initializeOperandSpaces ];

    // Line Path
    [ self _initializeLinePath ];

    self->_drawingFont = [ [ NSFont fontWithName: @"Lucida Grande" size: 15 ] retain ];
    }

- ( void ) _initializeOperandSpaces
    {
    self->_bottommostSpaceBar = NSMakeRect( NSMinX( _gridPathBoundary )
                                          , NSMinY( _gridPathBoundary )
                                          , _spaceWidth
                                          , _spaceHeight
                                          );

    self->_secondSpaceBar = NSMakeRect( NSMinX( _gridPathBoundary )
                                      , NSMaxY( self->_bottommostSpaceBar )
                                      , _spaceWidth
                                      , _spaceHeight
                                      );

    self->_thirdSpaceBar = NSMakeRect( NSMinX( _gridPathBoundary )
                                     , NSMaxY( self->_secondSpaceBar )
                                     , _spaceWidth
                                     , _spaceHeight
                                     );

    self->_topmostSpaceBar = NSMakeRect( NSMinX( _gridPathBoundary )
                                       , NSMaxY( self->_thirdSpaceBar )
                                       , _spaceWidth
                                       , _spaceHeight
                                       );
    }

- ( void ) _initializeOprands
    {
    if ( !self.lhsOperand )
        self.lhsOperand = [ NSMutableString string ];
//    [ self.lhsOperand appendString: @"31241" ];

    if ( !self.rhsOperand )
        self.rhsOperand = [ NSMutableString string ];
//    [ self.rhsOperand appendString: @"4234235235" ];

    if ( !self.resultValue )
        self.resultValue = [ NSMutableString string ];
//    [ self.resultValue appendString: @"5645647487" ];
    }

- ( void ) _initializeLinePath
    {
    if ( !self.linePath )
        {
        self.linePath = [ NSBezierPath bezierPath ];
        [ self.linePath moveToPoint: NSMakePoint( _spaceX, NSMaxY( self->_bottommostSpaceBar ) + kYPadding / 2 ) ];
        [ self.linePath lineToPoint: NSMakePoint( _spaceX + _spaceWidth, NSMaxY( self->_bottommostSpaceBar ) + kYPadding / 2 ) ];
        }
    }

- ( void ) _initializeGridPath
    {
    if ( !self.gridPath )
        {
        NSRect gridPathBounds = NSInsetRect( self.bounds, 10, 10 );
        gridPathBounds.size.height -= 25;

        NSAffineTransform* affine = [ NSAffineTransform transform ];
        [ affine translateXBy: 0.f yBy: 25 ];
        gridPathBounds.origin = [ affine transformPoint: gridPathBounds.origin ];

        _gridPathBoundary = gridPathBounds;

        self.gridPath = [ NSBezierPath bezierPathWithRect: gridPathBounds ];

        CGFloat height = gridPathBounds.size.height;
        CGFloat horizontalGridSpacing = height / 4;

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
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    NSFrameRect( self->_bottommostSpaceBar );
    NSFrameRect( self->_secondSpaceBar );
    NSFrameRect( self->_thirdSpaceBar );
    NSFrameRect( self->_topmostSpaceBar );

    [ [ [ NSColor lightGrayColor ] colorWithAlphaComponent: .3 ] set ];
    [ self.gridPath stroke ];

    NSColor* drawingColor = [ NSColor whiteColor ];
    [ drawingColor set ];

    NSDictionary* drawingAttributes = @{ NSFontAttributeName : self->_drawingFont
                                       , NSForegroundColorAttributeName : drawingColor
                                       };

//    [ self.lhsOperand drawAtPoint: NSMakePoint( NSMaxX( self.lhsOperandSpace ) -  [ self.lhsOperand sizeWithAttributes: drawingAttributes ].width
//                                              , NSMinY( self.lhsOperandSpace ) + 2 )
//                   withAttributes: drawingAttributes ];
//
//    [ self.rhsOperand drawAtPoint: NSMakePoint( NSMaxX( self.rhsOperandSpace ) - [ self.rhsOperand sizeWithAttributes: drawingAttributes ].width
//                                              , NSMinY( self.rhsOperandSpace ) + 2 )
//                   withAttributes: drawingAttributes ];
//
//    [ self.resultValue drawAtPoint: NSMakePoint( NSMaxX( self.tmpOperandSpace ) -  [ self.resultValue sizeWithAttributes: drawingAttributes ].width
//                                              , NSMinY( self.tmpOperandSpace ) + 2 )
//                   withAttributes: drawingAttributes ];
//    [ self.linePath stroke ];
    }

#pragma mark Accessors
//- ( void ) setLhsOperand: ( NSString* )_LhsOperand
//    {
//    if ( ![ self->_lhsOperand isEqualToString: _LhsOperand ] )
//        {
//        [ self->_lhsOperand replaceCharactersInRange: NSMakeRange( 0, self->_lhsOperand.length ) withString: _LhsOperand ];
//
//        [ self setNeedsDisplay: YES ];
//        }
//    }
//
//- ( void ) setRhsOperand: ( NSString* )_RhsOperand
//    {
//    if ( ![ self->_rhsOperand isEqualToString: _RhsOperand ] )
//        {
//        [ self->_rhsOperand replaceCharactersInRange: NSMakeRange( 0, self->_rhsOperand.length ) withString: _RhsOperand ];
//
//        [ self setNeedsDisplay: YES ];
//        }
//    }
//
//- ( void ) setResultValue: ( NSString* )_ResultValue
//    {
//    if ( ![ self->_resultValue isEqualToString: _ResultValue ] )
//        {
//        [ self->_resultValue replaceCharactersInRange: NSMakeRange( 0, self->_resultValue.length ) withString: _ResultValue ];
//
//        [ self setNeedsDisplay: YES ];
//        }
//    }

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