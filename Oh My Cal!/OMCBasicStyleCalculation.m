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

#import "OMCBasicStyleCalculation.h"
#import "OMCOperand.h"

// OMCBasicStyleCalculation class
@implementation OMCBasicStyleCalculation

- ( void ) awakeFromNib
    {
    [ super awakeFromNib ];

    [ self.lhsOperand setCalStyle: OMCBasicStyle ];
    [ self.rhsOperand setCalStyle: OMCBasicStyle ];
    [ self.resultValue setCalStyle: OMCBasicStyle ];
    }

- ( void ) appendNumberWithLastPressedButton: ( NSButton* )_Button
    {
    NSString* buttonTitle = [ _Button title ];
    NSInteger numberWillBeAppended = numberWillBeAppended = [ buttonTitle integerValue ];

    BOOL isWaitingForFloatNumber = [ buttonTitle isEqualToString: @"." ];
    NSInteger appendCount = 1;  // appendCount in basicStyleCalculation is always 1

    // If Oh My Cal! is in the initial state or user is just typing the left operand
    if ( self.typingState == OMCWaitAllOperands )
        {
        [ self.lhsOperand setWaitingForFloatNumber: isWaitingForFloatNumber ];
        [ self.lhsOperand appendDigit: numberWillBeAppended count: appendCount ary: self.currentAry ];
        self.typingState = OMCWaitAllOperands;
        }
    else if ( self.typingState == OMCWaitRhsOperand )
        {
        [ self.rhsOperand setWaitingForFloatNumber: isWaitingForFloatNumber ];
        [ self.rhsOperand appendDigit: numberWillBeAppended count: appendCount ary: self.currentAry ];
        self.typingState = OMCWaitRhsOperand;   // Wait for the user to pressing next button
        }
    else if ( self.typingState == OMCFinishedTyping )
        {
        [ self.lhsOperand setBaseNumber: @.0f ];
        [ self.rhsOperand setBaseNumber: @.0f ];
        [ self.resultValue setBaseNumber: @.0f ];

        [ self.theOperator clear ];

        [ self.lhsOperand appendDigit: numberWillBeAppended count: appendCount ary: self.currentAry ];
        self.typingState = OMCWaitAllOperands;  // Wait for the user to pressing next button
        }
    }

@end // OMCBasicStyleCalculation

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