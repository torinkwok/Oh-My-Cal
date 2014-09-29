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

#define __THROW_EXCEPTION__FOR_INVALID_CAL_STYLE__( _Method )                   \
    @throw [ NSException exceptionWithName: OMCInvalidCalStyle                  \
                                    reason: [ NSString stringWithFormat: @"%@ is only available for the calculation with Scientific Style and Programmer Style" \
                                                                       , NSStringFromSelector( _Method ) ]                                                         \
                                  userInfo: nil ]                               \
// OMCBasicStyleCalculation class
@implementation OMCBasicStyleCalculation

- ( void ) awakeFromNib
    {
    [ super awakeFromNib ];

    [ self.lhsOperand setCalStyle: OMCBasicStyle ];
    [ self.rhsOperand setCalStyle: OMCBasicStyle ];
    [ self.resultValue setCalStyle: OMCBasicStyle ];

    [ self setCurrentAry: OMCDecimal ];
    }

#pragma mark Overrrides
- ( void ) reliveFromBasicStyleCalculation: ( OMCBasicStyleCalculation* )_BasicStyleCalculation
    {
    if ( self.calStyle == OMCBasicStyle )
        __THROW_EXCEPTION__FOR_INVALID_CAL_STYLE__( _cmd );
    else
        {

        }
    }

- ( void ) reliveFromScientificStyleCalculation: ( OMCScientificStyleCalculation* )_ScientificStyleCalculation
    {

    }

- ( void ) reliveFromProgrammerStyleCalculation: ( OMCProgrammerStyleCalculation* )_ProgrammerStyleCalculation
    {

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