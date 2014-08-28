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

// OMCCalculation class
@implementation OMCCalculation

@synthesize typingState = _typingState;
@synthesize currentAry = _currentAry;

@synthesize resultVal = _resultVal;
@synthesize lhsOperand = _lhsOperand;
@synthesize rhsOperand = _rhsOperand;
@synthesize resultingFormula = _resultingFormula;

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
    OMCButtonType buttonType = ( OMCButtonType )[ pressedButton tag ];

    switch ( buttonType )
        {
    case OMCOne:        [ self.resultingFormula appendString: @"1" ];  break;
    case OMCTwo:        [ self.resultingFormula appendString: @"2" ];  break;
    case OMCThree:      [ self.resultingFormula appendString: @"3" ];  break;
    case OMCFour:       [ self.resultingFormula appendString: @"4" ];  break;
    case OMCFive:       [ self.resultingFormula appendString: @"5" ];  break;
    case OMCSix:        [ self.resultingFormula appendString: @"6" ];  break;
    case OMCSeven:      [ self.resultingFormula appendString: @"7" ];  break;
    case OMCEight:      [ self.resultingFormula appendString: @"8" ];  break;
    case OMCNine:       [ self.resultingFormula appendString: @"9" ];  break;
    case OMCZero:       [ self.resultingFormula appendString: @"0" ];  break;
    case OMCDoubleZero: [ self.resultingFormula appendString: @"00" ]; break;
    case OMC0xA:        [ self.resultingFormula appendString: @"A" ];  break;
    case OMC0xB:        [ self.resultingFormula appendString: @"B" ];  break;
    case OMC0xC:        [ self.resultingFormula appendString: @"C" ];  break;
    case OMC0xD:        [ self.resultingFormula appendString: @"D" ];  break;
    case OMC0xE:        [ self.resultingFormula appendString: @"E" ];  break;
    case OMC0xF:        [ self.resultingFormula appendString: @"F" ];  break;
    case OMC0xFF:       [ self.resultingFormula appendString: @"FF" ]; break;

    case OMCAnd:        [ self.resultingFormula appendString: @"&" ];  break;
    case OMCOr:         [ self.resultingFormula appendString: @"|" ];   break;
    case OMCNor:        [ self.resultingFormula appendString: @"~" ];  break;
    case OMCXor:        [ self.resultingFormula appendString: @"^" ];  break;
    case OMCLsh:        [ self.resultingFormula appendString: @"<<" ];  break;
    case OMCRsh:        [ self.resultingFormula appendString: @">>" ];  break;
    case OMCRoL:        [ self.resultingFormula appendString: @"ROL" ];  break;
    case OMCRoR:        [ self.resultingFormula appendString: @"ROR" ];  break;
    case OMC2_s:        [ self.resultingFormula appendString: @"2's" ];  break;
    case OMC1_s:        [ self.resultingFormula appendString: @"1's" ];  break;
    case OMCMod:        [ self.resultingFormula appendString: @"%" ];  break;
    case OMCFactorial:  [ self.resultingFormula appendString: @"!" ]; break;

    case OMCDel:        break;  // TODO:
    case OMCAC:         break;  // TODO:
    case OMCClear:      break;  // TODO:

    case OMCAdd:        [ self.resultingFormula appendString: @"+" ];  break;
    case OMCSub:        [ self.resultingFormula appendString: @"-" ];  break;
    case OMCMuliply:    [ self.resultingFormula appendString: @"*" ];  break;
    case OMCDivide:     [ self.resultingFormula appendString: @"/" ];  break;

    case OMCLeftParenthesis:  [ self.resultingFormula appendString: @"(" ];  break;
    case OMCRightParenthesis: [ self.resultingFormula appendString: @")" ];  break;

    case OMCEnter:
            {
            NSLog( @"%@", self.resultingFormula );
            [ self.resultingFormula deleteCharactersInRange: NSMakeRange( 0, self.resultingFormula.length ) ];
            } break;
        }
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