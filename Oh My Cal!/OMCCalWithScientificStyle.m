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

#import "OMCCalWithScientificStyle.h"
#import "OMCScientificStyleCalculation.h"

NSString static* const kKeyPathForIsInShiftInCalculationObject = @"self.isInShift";

// OMCCalWithScientificStyle class
@implementation OMCCalWithScientificStyle

@synthesize _shift;
@synthesize _lhsParenthesis;
@synthesize _rhsParenthesis;
@synthesize _percent;

@synthesize _reciprocal;
@synthesize _square;
@synthesize _cube;
@synthesize _xPower;

@synthesize _cubeRoot;
@synthesize _xRoot;
@synthesize _e_x;
@synthesize _2_x;
@synthesize _10_x;

@synthesize _factorial;
@synthesize _sqrt;
@synthesize _rad;
@synthesize _log2;

@synthesize _sin;
@synthesize _cos;
@synthesize _tan;
@synthesize _asin;
@synthesize _acos;
@synthesize _atan;
@synthesize _log10;

@synthesize _sinh;
@synthesize _cosh;
@synthesize _tanh;
@synthesize _asinh;
@synthesize _acosh;
@synthesize _atanh;
@synthesize _In;

@synthesize _pi;
@synthesize _e;
@synthesize _rand;
@synthesize _EE;

#pragma mark Initializers & Deallocators
- ( void ) awakeFromNib
    {
    [ self._calculation addObserver: self
                         forKeyPath: kKeyPathForIsInShiftInCalculationObject
                            options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                            context: NULL ];
    }

- ( void ) observeValueForKeyPath: ( NSString* )_KeyPath
                         ofObject: ( id )_Object
                           change: ( NSDictionary* )_Change
                          context: ( void* )_Context
    {
    if ( [ _KeyPath isEqualToString: kKeyPathForIsInShiftInCalculationObject ] )
        {
        BOOL isInShiftNow = [ _Change[ @"new" ] boolValue ];

        [ self._sin setHidden: isInShiftNow ];
        [ self._asin setHidden: !isInShiftNow ];

        [ self._cos setHidden: isInShiftNow ];
        [ self._acos setHidden: !isInShiftNow ];

        [ self._tan setHidden: isInShiftNow ];
        [ self._atan setHidden: !isInShiftNow ];

        [ self._sinh setHidden: isInShiftNow ];
        [ self._asinh setHidden: !isInShiftNow ];

        [ self._cosh setHidden: isInShiftNow ];
        [ self._acosh setHidden: !isInShiftNow ];

        [ self._tanh setHidden: isInShiftNow ];
        [ self._atanh setHidden: !isInShiftNow ];

        [ self._cube setHidden: isInShiftNow ];
        [ self._cubeRoot setHidden: !isInShiftNow ];

        [ self._xPower setHidden: isInShiftNow ];
        [ self._xRoot setHidden: !isInShiftNow ];

        [ self._In setHidden: isInShiftNow ];
        [ self._e_x setHidden: !isInShiftNow ];

        [ self._log2 setHidden: isInShiftNow ];
        [ self._2_x setHidden: !isInShiftNow ];

        [ self._log10 setHidden: isInShiftNow ];
        [ self._10_x setHidden: !isInShiftNow ];
        }
    }

@end // OMCCalWithScientificStyle

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