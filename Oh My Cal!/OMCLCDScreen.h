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

@class OMFPanelBackgroundView;

@class OMCCalculation;
@class OMCBasicStyleCalculation;
@class OMCScientificStyleCalculation;
@class OMCProgrammerStyleCalculation;

@class OMCCal;
@class OMCCalWithBasicStyle;
@class OMCCalWithScientificStyle;
@class OMCCalWithProgrammerStyle;

@class FBKVOController;

typedef NSRect OMCSpaceBarRect;

// OMCLCDScreen class
@interface OMCLCDScreen : BGHUDView
    {
@private
    OMCSpaceBarRect _bottommostSpaceBar;
    OMCSpaceBarRect _secondSpaceBar;
    OMCSpaceBarRect _thirdSpaceBar;
    OMCSpaceBarRect _topmostSpaceBar;
    OMCSpaceBarRect _statusSpaceBar;

    NSBezierPath* _auxiliaryLinePath;
    NSBezierPath* _gridPath;

    NSColor* _gridColor;
    NSColor* _auxiliaryLineColor;
    NSColor* _operandsColor;
    NSColor* _operatorsColor;
    NSColor* _storageFormulasColor;
    NSColor* _statusColor;

    NSFont* _operandsFont;
    NSFont* _operatorsFont;
    NSFont* _storageFormulasFont;
    NSFont* _statusFont;
    }

@property ( nonatomic, retain ) FBKVOController* KVOController;

@property ( nonatomic, unsafe_unretained ) IBOutlet OMFPanelBackgroundView* _mainPanelBackgroundView;

@property ( nonatomic, unsafe_unretained ) IBOutlet OMCBasicStyleCalculation* _basicStyleCalculation;
@property ( nonatomic, unsafe_unretained ) IBOutlet OMCScientificStyleCalculation* _scientificStyleCalculation;
@property ( nonatomic, unsafe_unretained ) IBOutlet OMCProgrammerStyleCalculation* _programmerStyleCalculation;

@property ( nonatomic, unsafe_unretained ) IBOutlet OMCCalWithBasicStyle* _calWithBasicStyle;
@property ( nonatomic, unsafe_unretained ) IBOutlet OMCCalWithScientificStyle* _calWithScientificStyle;
@property ( nonatomic, unsafe_unretained ) IBOutlet OMCCalWithProgrammerStyle* _calWithProgrammerStyle;

@property ( nonatomic, unsafe_unretained, readonly ) OMCCal* currentCalculator;

@property ( nonatomic, assign, readonly ) OMCSpaceBarRect bottommostSpaceBar;
@property ( nonatomic, assign, readonly ) OMCSpaceBarRect secondSpaceBar;
@property ( nonatomic, assign, readonly ) OMCSpaceBarRect thirdSpaceBar;
@property ( nonatomic, assign, readonly ) OMCSpaceBarRect topmostSpaceBar;
@property ( nonatomic, assign, readonly ) OMCSpaceBarRect statusSpaceBar;

@property ( nonatomic, retain ) NSColor* gridColor;
@property ( nonatomic, retain ) NSColor* auxiliaryLineColor;
@property ( nonatomic, retain ) NSColor* operandsColor;
@property ( nonatomic, retain ) NSColor* operatorsColor;
@property ( nonatomic, retain ) NSColor* storageFormulasColor;
@property ( nonatomic, retain ) NSColor* statusColor;

@property ( nonatomic, retain ) NSFont* operandsFont;
@property ( nonatomic, retain ) NSFont* operatorsFont;
@property ( nonatomic, retain ) NSFont* storageFormulasFont;
@property ( nonatomic, retain ) NSFont* statusFont;

@property ( nonatomic, retain ) NSBezierPath* auxiliaryLinePath;
@property ( nonatomic, retain ) NSBezierPath* gridPath;

@property ( nonatomic, assign, readonly ) OMCTypingState typingState;
@property ( nonatomic, assign, readonly ) OMCAry currentAry;

@property ( nonatomic, retain, readonly ) OMCCalculation* currentCalculation;

#pragma mark IBActions
- ( IBAction ) cut: ( id )_Sender;
- ( IBAction ) copy: ( id )_Sender;
- ( IBAction ) paste: ( id )_Sender;

@end // OMCLCDScreen

#pragma mark Validate the 'Cut', 'Copy' and 'Paste' menu item
@interface OMCLCDScreen ( OMCLCDScreenValidation ) <NSUserInterfaceValidations>
- ( BOOL ) validateUserInterfaceItem: ( id <NSValidatedUserInterfaceItem> )_TheItemToBeValidated;
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