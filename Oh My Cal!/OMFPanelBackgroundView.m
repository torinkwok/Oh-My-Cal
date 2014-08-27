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
#import "OMCCalWithProgrammerStyle.h"

#define ARROW_WIDTH     20.f
#define ARROW_HEIGHT    8.f

#define CORNER_RADIUS   20.f

#define GRAY_SCALE      .12549f
#define ALPHA_VAL       .85f

// OMFPanelBackgroundView class
@implementation OMFPanelBackgroundView

@synthesize _currentCalStyle;
@synthesize _LCDScreen;
@synthesize _calWithProgrammerStyle;

@synthesize arrowX = _arrowX;

#pragma mark Conforms <NSAwakeFromNib> protocol
- ( void ) awakeFromNib
    {
    _currentCalStyle = ( OMCCalStyle )[ [ USER_DEFAULTS objectForKey: OMCDefaultsKeyCalStyle ] intValue ];

    NSView* currentCal = nil;
    switch( _currentCalStyle )
        {
    case OMCBasicStyle: /* TODO: NOTHING */ break;
    case OMCProgrammerStyle: currentCal = self._calWithProgrammerStyle; break;
        }

    [ self._LCDScreen setFrame: NSMakeRect( NSMinX( self.bounds ) + 12
                                          , NSMaxY( self._calWithProgrammerStyle.bounds )
                                          , NSWidth( self._calWithProgrammerStyle.bounds ) - 12 * 2
                                          , 160
                                          ) ];

    NSRect newWindowFrame = NSMakeRect( 0, 0 // Because of the openPanel: method in OMCMainPanelController, the origin of window does not matter.
                                      , NSWidth( self._calWithProgrammerStyle.bounds )
                                      , NSHeight( self._calWithProgrammerStyle.bounds ) + NSHeight( self._LCDScreen.bounds ) + 20 // TODO: The height delta should be based on height of dial
                                      );

    [ [ self window ] setFrame: newWindowFrame display: YES ];

    [ self setSubviews: @[ self._LCDScreen, self._calWithProgrammerStyle ] ];
    }

#pragma mark Customize Drawing
- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    NSBezierPath* bezierPath = [ NSBezierPath bezierPath ];

    NSRect bounds = [ self bounds ];
    [ bezierPath moveToPoint: NSMakePoint( self.arrowX, NSMaxY( bounds ) ) ];
    [ bezierPath lineToPoint: NSMakePoint( self.arrowX + ARROW_WIDTH / 2, NSMaxY( bounds ) - ARROW_HEIGHT ) ];
    [ bezierPath lineToPoint: NSMakePoint( NSMaxX( bounds ) - CORNER_RADIUS, NSMaxY( bounds ) - ARROW_HEIGHT ) ];

    NSPoint rightTopCorner = NSMakePoint( NSMaxX( bounds ), NSMaxY( bounds ) - ARROW_HEIGHT );
    [ bezierPath curveToPoint: NSMakePoint( NSMaxX( bounds ), NSMaxY( bounds ) - ARROW_HEIGHT - CORNER_RADIUS )
                controlPoint1: rightTopCorner
                controlPoint2: rightTopCorner ];

    [ bezierPath lineToPoint: NSMakePoint( NSMaxX( bounds ), NSMinY( bounds ) + CORNER_RADIUS ) ];

    NSPoint rightBottomCorner = NSMakePoint( NSMaxX( bounds ), NSMinY( bounds ) );
    [ bezierPath curveToPoint: NSMakePoint( NSMaxX( bounds ) - CORNER_RADIUS, NSMinY( bounds ) )
                controlPoint1: rightBottomCorner
                controlPoint2: rightBottomCorner ];

    [ bezierPath lineToPoint: NSMakePoint( NSMinX( bounds ) + CORNER_RADIUS, NSMinY( bounds ) ) ];

    NSPoint leftBottomCorner = bounds.origin;
    [ bezierPath curveToPoint: NSMakePoint( NSMinX( bounds ), NSMinY( bounds ) + CORNER_RADIUS )
                controlPoint1: leftBottomCorner
                controlPoint2: leftBottomCorner ];

    [ bezierPath lineToPoint: NSMakePoint( NSMinX( bounds ), NSMaxY( bounds ) - ARROW_HEIGHT - CORNER_RADIUS ) ];

    NSPoint leftTopCorner = NSMakePoint( NSMinX( bounds ), NSMaxY( bounds ) - ARROW_HEIGHT );
    [ bezierPath curveToPoint: NSMakePoint( NSMinX( bounds ) + CORNER_RADIUS, NSMaxY( bounds ) - ARROW_HEIGHT )
                controlPoint1: leftTopCorner
                controlPoint2: leftTopCorner ];

    [ bezierPath lineToPoint: NSMakePoint( self.arrowX - ARROW_WIDTH / 2, NSMaxY( bounds ) - ARROW_HEIGHT ) ];
    [ bezierPath closePath ];

    [ NSGraphicsContext saveGraphicsState ];
        {
        [ [ NSColor colorWithDeviceWhite: GRAY_SCALE alpha: ALPHA_VAL ] setFill ];
        [ bezierPath fill ];

        [ [ NSColor clearColor ] setStroke ];
        [ bezierPath stroke ];
        }
    [ NSGraphicsContext restoreGraphicsState ];
    }

#pragma mark Accessors
- ( CGFloat ) arrowX
    {
    return self->_arrowX;
    }

- ( void ) setArrowX: ( CGFloat )_ArrowX
    {
    if ( self->_arrowX != _ArrowX )
        {
        self->_arrowX = _ArrowX;

        [ self setNeedsDisplay: YES ];
        }
    }

@end // OMFPanelBackgroundView

/////////////////////////////////////////////////////////////////////////////

/****************************************************************************
 **                                                                        **
 **      _________                                      _______            **
 **     |___   ___|                                   / ______ \           **
 **         | |     _______   _______   _______      | /      |_|          **
 **         | |    ||     || ||     || ||     ||     | |    _ __           **
 **         | |    ||     || ||     || ||     ||     | |   |__  \          **
 **         | |    ||     || ||     || ||     ||     | \_ _ __| |  _       **
 **         |_|    ||_____|| ||     || ||_____||      \________/  |_|      **
 **                                           ||                           **
 **                                    ||_____||                           **
 **                                                                        **
 ***************************************************************************/
///:~