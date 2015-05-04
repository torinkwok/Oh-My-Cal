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
#import "OMCBinaryAndDecimalConversion.h"

#define COMPARE_WITH_OPERATOR( _Rhs ) COMPARE_WITH_CASE_INSENSITIVE( self.theOperator, _Rhs )

// Exception Names
NSString extern* const OMCInvalidCalStyle;

// Notification UserInfo Keys
NSString extern* const OMCCalculationNewTypingState;
NSString extern* const OMCCalculationNewAry;

enum { k0xA = 10, k0xB = 11, k0xC = 12, k0xD = 13, k0xE = 14, k0xF = 15, k0xFF = 255 };

@class OMCOperand;
@class OMCBinaryOperationPanel;

@class OMCBasicStyleCalculation;
@class OMCScientificStyleCalculation;
@class OMCProgrammerStyleCalculation;

#pragma mark OMCCalculation Class
/** This class deletes large amounts of files asynchronously.
  * You should use the sharedInstance to get an instance. 
  * On iOS this automatically starts a background task if the app is suspended so that file deletion can complete.
  */
@interface OMCCalculation : NSObject <OMCBinaryAndDecimalConversion>
    {
@private
    OMCTypingState _typingState;

    OMCAry                  _currentAry;
    OMCTrigonometricMode    _trigonometricMode;
    BOOL                    _hasMemory;
    BOOL                    _isInShift;

    OMCButtonType _lastTypedButtonType;
    NSButton* _lastTypedButton;

    OMCOperand* _lhsOperand;
    OMCOperand* _rhsOperand;
    OMCOperand* _resultValue;

    OMCOperand* _memory;

    NSMutableString* _theOperator;
    }

/// @name Fucking GUI Widgets

/** 
  @abstract Binary operation panel for my precious calculator.
  @see typingState
  @see currentAry
  @see calStyle
  */
@property ( nonatomic, unsafe_unretained ) IBOutlet OMCBinaryOperationPanel* _binaryOperationPanel;

/// @name Calculator Status

/** The typing state in which my precious calculator is.
  * @see _binaryOperationPanel
  * @see currentAry
  * @see calStyle
  */
@property ( nonatomic, assign ) OMCTypingState typingState;

/** The ary used for my precious calculator.
  * @see _binaryOperationPanel
  * @see typingState
  * @see calStyle
  */
@property ( nonatomic, assign ) OMCAry currentAry;

/** The cal style which my precious accepted
  * @see _binaryOperationPanel
  * @see typingState
  * @see calStyle
  */
@property ( nonatomic, assign, readonly ) OMCCalStyle calStyle;

/** 
  Current trigonometric mode

  @warning **Important** Fuck You!

  - One(1)
    4. One(2)
    2. One(3)
    1. One(4)
        - One(3)
        - One(3)
        - One(3)
    - One(4)

  * Two
  * Two
  * Two
  
  + Three
  + Three
  + Three
  
  @return fuck
  @sa - deleteNumberWithLastPressedButton:
  */
@property ( nonatomic, assign ) OMCTrigonometricMode trigonometricMode;
@property ( nonatomic, assign ) BOOL hasMemory;
@property ( nonatomic, assign ) BOOL isInShift;

@property ( nonatomic, assign ) OMCButtonType lastTypedButtonType;
@property ( nonatomic, retain ) NSButton* lastTypedButton;

@property ( nonatomic, retain ) OMCOperand* lhsOperand;
@property ( nonatomic, retain ) OMCOperand* rhsOperand;
@property ( nonatomic, retain ) OMCOperand* resultValue;

@property ( nonatomic, retain ) OMCOperand* memory;

@property ( nonatomic, retain ) NSMutableString* theOperator;

@property ( nonatomic, assign, readonly ) BOOL isBinomialInLastCalculation;

- ( IBAction ) calculate: ( id )_Sender;

- ( void ) zeroedAllOperands;

/** 
  `Delete` the number that with last pressed button.

  | First Header | Second Header | Third Header |
  | ------------ | ------------- | ------------ |
  | Content Cell | Content Cell  | Content Cell |
  | Content Cell | Content Cell  | Content Cell |
  
  This text contains links to: class OMCScientificStyleCalculation, its extension NSString(OMCString),
  category NSMutableString(OMCCalculation) and protocol GBProtocol.
  
  This text contains links to: method calculateTheResultValueForMonomialWithLastPressedButton: and property lhsOperand

  This text contains links to: [this method]([OMCOperand zero]) and [this property]([OMCOperand numericString])
  
  For referring to common object multiple times,
  use this [OMCOperand][1]. And [repeat again][1].
  
  [Mail me](mailto:Tong-G@outlook.com)
  
  [Tweet Me](https://twitter.com/NSTongG)

  The delay and interval values are used if the button is configured (by a setContinuous: message)
  to continuously send the action message to the target object while tracking the mouse.

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

  @param _Button The last pressed button
        
  @warning Oh My God!
  @bug Opps!
  @sa OMCScientificStyleCalculation
  @sa NSString(OMCString)
  @sa NSMutableString(OMCCalculation)
  @exception NSPortTimeoutException Name of an exception that occurs when a timeout set on a port expires during a send or receive operation. 
                                    This is a distributed objects–specific exception.
  */
- ( void ) deleteNumberWithLastPressedButton: ( NSButton* )_Button;

- ( void ) appendNumberWithLastPressedButton: ( NSButton* )_Button;
- ( void ) appendUnitaryOperatorWithLastPressedButton: ( NSButton* )_Button;
- ( void ) appendBinaryOperatorWithLastPressedButton: ( NSButton* )_Button;

/**
  @abstract Calculate the result value for monimal with the last pressed button.
  @param _Button The last pressed button

  @warning It's not me!
  */
- ( void ) calculateTheResultValueForMonomialWithLastPressedButton: ( NSButton* )_Button;
- ( void ) calculateTheResultValueForBinomialWithLastPressedButton: ( NSButton* )_Button;

- ( void ) clearAllAndReset;
- ( void ) clearCurrentOperand;

@end // OMCCalculation class

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