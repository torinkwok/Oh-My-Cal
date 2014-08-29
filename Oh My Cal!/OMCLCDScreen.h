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

typedef NSRect OMCSpaceBarRect;

// OMCLCDScreen class
@interface OMCLCDScreen : BGHUDView
    {
@private
    OMCSpaceBarRect _bottommostSpaceBar;
    OMCSpaceBarRect _secondSpaceBar;
    OMCSpaceBarRect _thirdSpaceBar;
    OMCSpaceBarRect _topmostSpaceBar;

    NSBezierPath* _linePath;
    NSBezierPath* _gridPath;

    NSColor* _gridColor;
    NSColor* _auxiliaryLineColor;
    NSColor* _operandsColor;
    NSColor* _operatorsColor;
    NSColor* _storageFormulasColor;

    NSFont* _operandsFont;
    NSFont* _operatorsFont;
    NSFont* _storageFormulasFont;

    NSMutableString* _lhsOperand;
    NSMutableString* _rhsOperand;
    NSMutableString* _resultValue;
    }

@property ( nonatomic, assign ) IBOutlet OMCCalculation* _calculation;

@property ( nonatomic, assign, readonly ) OMCSpaceBarRect bottommostSpaceBar;
@property ( nonatomic, assign, readonly ) OMCSpaceBarRect secondSpaceBar;
@property ( nonatomic, assign, readonly ) OMCSpaceBarRect thirdSpaceBar;
@property ( nonatomic, assign, readonly ) OMCSpaceBarRect topmostSpaceBar;

@property ( nonatomic, retain ) NSColor* gridColor;
@property ( nonatomic, retain ) NSColor* auxiliaryLineColor;
@property ( nonatomic, retain ) NSColor* operandsColor;
@property ( nonatomic, retain ) NSColor* operatorsColor;
@property ( nonatomic, retain ) NSColor* storageFormulasColor;

@property ( nonatomic, retain ) NSFont* operandsFont;
@property ( nonatomic, retain ) NSFont* operatorsFont;
@property ( nonatomic, retain ) NSFont* storageFormulasFont;

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