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

#import "OMCCalculation.h"

// Notifications
NSString* const OMCCurrentTypingStateDidChangedNotification = @"OMCCurrentTypingStateDidChangedNotification";
NSString* const OMCCurrentAryDidChangedNotification = @"OMCCurrentAryDidChangedNotification";
NSString* const OMCCurrentLeftOperandDidChangedNotification = @"OMCCurrentLeftOperandDidChangedNotification";
NSString* const OMCCurrentRightOperandDidChangedNotification = @"OMCCurrentRightOperandDidChangedNotification";
NSString* const OMCCurrentResultValueDidChangedNotification = @"OMCCurrentResultValueDidChangedNotification";

// Keys for User Info in notifications
NSString* const OMCCurrentTypingState = @"OMCCurrentTypingState";
NSString* const OMCCurrentAry = @"OMCCurrentAry";
NSString* const OMCLastTypedButton = @"OMCLastTypedButton";

// OMCCalculation class
@implementation OMCCalculation

@synthesize typingState = _typingState;
@synthesize currentAry = _currentAry;

@synthesize resultVal = _resultVal;
@synthesize lhsOperand = _lhsOperand;
@synthesize rhsOperand = _rhsOperand;
@synthesize resultingFormula = _resultingFormula;

@synthesize lastTypedButtonType = _lastTypedButtonType;
@synthesize lastTypedButton = _lastTypedButton;

#pragma mark Initializers & Deallocators
- ( void ) awakeFromNib
    {
    [ self setTypingState: OMCWaitAllOperands ];
    [ self setCurrentAry: ( OMCAry )[ USER_DEFAULTS objectForKey: OMCDefaultsKeyAry ] ];

    self.resultingFormula = [ NSMutableString string ];
    }

#pragma mark IBActions

// All of the buttons on the keyboard has been connected to this action
- ( IBAction ) calculate: ( id )_Sender
    {
    NSButton* pressedButton = _Sender;
    self.lastTypedButtonType = ( OMCButtonType )[ pressedButton tag ];
    self.lastTypedButton = _Sender;

    switch ( self.lastTypedButtonType )
        {
        // Numbers
    case OMCOne:
            {
            if ( self.typingState == OMCWaitAllOperands )
                self.typingState = OMCWaitAllOperands;

            

            [ self.resultingFormula appendString: @"1" ];
            } break;

    case OMCTwo:
            {
            if ( self.typingState == OMCWaitAllOperands )
                self.typingState = OMCWaitAllOperands;

            [ self.resultingFormula appendString: @"2" ];
            } break;

    case OMCThree:
            {
            if ( self.typingState == OMCWaitAllOperands )
                self.typingState = OMCWaitAllOperands;

            [ self.resultingFormula appendString: @"3" ];
            } break;

    case OMCFour:
            {
            if ( self.typingState == OMCWaitAllOperands )
                self.typingState = OMCWaitAllOperands;

            [ self.resultingFormula appendString: @"4" ];
            } break;

    case OMCFive:
            {
            if ( self.typingState == OMCWaitAllOperands )
                self.typingState = OMCWaitAllOperands;

            [ self.resultingFormula appendString: @"5" ];
            } break;

    case OMCSix:
            {
            if ( self.typingState == OMCWaitAllOperands )
                self.typingState = OMCWaitAllOperands;

            [ self.resultingFormula appendString: @"6" ];
            } break;

    case OMCSeven:
            {
            if ( self.typingState == OMCWaitAllOperands )
                self.typingState = OMCWaitAllOperands;

            [ self.resultingFormula appendString: @"7" ];
            } break;

    case OMCEight:
            {
            if ( self.typingState == OMCWaitAllOperands )
                self.typingState = OMCWaitAllOperands;

            [ self.resultingFormula appendString: @"8" ];
            } break;

    case OMCNine:
            {
            if ( self.typingState == OMCWaitAllOperands )
                self.typingState = OMCWaitAllOperands;

            [ self.resultingFormula appendString: @"9" ];
            } break;

    case OMCZero:
            {
            if ( self.typingState == OMCWaitAllOperands )
                self.typingState = OMCWaitAllOperands;

            [ self.resultingFormula appendString: @"0" ];
            } break;

    case OMCDoubleZero:
            {
            if ( self.typingState == OMCWaitAllOperands )
                self.typingState = OMCWaitAllOperands;

            [ self.resultingFormula appendString: @"00" ];
            } break;

    case OMC0xA:        [ self.resultingFormula appendString: @"A" ];  break;
    case OMC0xB:        [ self.resultingFormula appendString: @"B" ];  break;
    case OMC0xC:        [ self.resultingFormula appendString: @"C" ];  break;
    case OMC0xD:        [ self.resultingFormula appendString: @"D" ];  break;
    case OMC0xE:        [ self.resultingFormula appendString: @"E" ];  break;
    case OMC0xF:        [ self.resultingFormula appendString: @"F" ];  break;
    case OMC0xFF:       [ self.resultingFormula appendString: @"FF" ]; break;

        // Binary operators
    case OMCAnd:
            {
            if ( self.typingState == OMCWaitAllOperands )
                self.typingState = OMCOperatorDidPressed;

            [ self.resultingFormula appendString: @"&" ];
            } break;

    case OMCOr:         [ self.resultingFormula appendString: @"|" ];   break;
    case OMCXor:        [ self.resultingFormula appendString: @"^" ];  break;
    case OMCLsh:        [ self.resultingFormula appendString: @"<<" ];  break;
    case OMCRsh:        [ self.resultingFormula appendString: @">>" ];  break;
    case OMCRoL:        [ self.resultingFormula appendString: @"ROL" ];  break;
    case OMCRoR:        [ self.resultingFormula appendString: @"ROR" ];  break;
    case OMC2_s:        [ self.resultingFormula appendString: @"2's" ];  break;
    case OMC1_s:        [ self.resultingFormula appendString: @"1's" ];  break;
    case OMCMod:        [ self.resultingFormula appendString: @"%" ];  break;

    case OMCAdd:        [ self.resultingFormula appendString: @"+" ];  break;
    case OMCSub:        [ self.resultingFormula appendString: @"-" ];  break;
    case OMCMuliply:    [ self.resultingFormula appendString: @"*" ];  break;
    case OMCDivide:     [ self.resultingFormula appendString: @"/" ];  break;

    case OMCNor:        [ self.resultingFormula appendString: @"~" ];  break;
    case OMCFactorial:  [ self.resultingFormula appendString: @"!" ]; break;

    case OMCDel:        break;  // TODO:
    case OMCAC:         break;  // TODO:
    case OMCClear:      break;  // TODO:

    case OMCLeftParenthesis:  [ self.resultingFormula appendString: @"(" ];  break;
    case OMCRightParenthesis: [ self.resultingFormula appendString: @")" ];  break;

    case OMCEnter:
            {
            NSLog( @"%@", self.resultingFormula );
            [ self.resultingFormula deleteCharactersInRange: NSMakeRange( 0, self.resultingFormula.length ) ];
            } break;
        }
    }

#pragma mark Accessors
- ( void ) setTypingState: ( OMCTypingState )_TypingState
    {
    if ( self->_typingState != _TypingState )
        self->_typingState = _TypingState;

    [ NOTIFICATION_CENTER postNotificationName: OMCCurrentTypingStateDidChangedNotification
                                        object: self
                                      userInfo: @{ OMCCurrentTypingState : [ NSNumber numberWithInt: self->_typingState ]
                                                 , OMCCurrentAry : [ NSNumber numberWithInt: self->_currentAry ]
                                                 , OMCLastTypedButton : [ NSNumber numberWithInt: self->_lastTypedButtonType ]
                                                 } ];
    }

- ( void ) setCurrentAry: ( OMCAry )_Ary
    {
    if ( self->_currentAry != _Ary )
        self->_currentAry = _Ary;

    [ NOTIFICATION_CENTER postNotificationName: OMCCurrentAryDidChangedNotification
                                        object: self
                                      userInfo: @{ OMCCurrentTypingState : [ NSNumber numberWithInt: self->_typingState ]
                                                 , OMCCurrentAry : [ NSNumber numberWithInt: self->_currentAry ]
                                                 , OMCLastTypedButton : [ NSNumber numberWithInt: self->_lastTypedButtonType ]
                                                 } ];
    }

@end // OMCCalculation

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