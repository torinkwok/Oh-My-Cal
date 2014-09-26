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

@synthesize sinRect = _sinRect;

#pragma mark Initializers & Deallocators
- ( void ) awakeFromNib
    {
    [ self._calculation addObserver: self
                         forKeyPath: kKeyPathForIsInShiftInCalculationObject
                            options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                            context: NULL ];

    self.sinRect = [ self._sin frame ];
    }

- ( void ) observeValueForKeyPath: ( NSString* )_KeyPath
                         ofObject: ( id )_Object
                           change: ( NSDictionary* )_Change
                          context: ( void* )_Context
    {
    if ( [ _KeyPath isEqualToString: kKeyPathForIsInShiftInCalculationObject ] )
        {
        BOOL isInShiftNow = [ _Change[ @"new" ] boolValue ];

        if ( isInShiftNow )
            {
            [ [ self._sin retain ] removeFromSuperview ];
            [ self addSubview: self._asinh ];
            }
        else
            {
            [ self._sin setFrame: self.sinRect ];
            [ self addSubview: self._sin  ];

            [ [ self._asinh retain ] removeFromSuperview ];
            }
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