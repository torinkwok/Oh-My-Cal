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

#define __THROW_EXCEPTION__WHEN_INVOKED_PURE_VIRTUAL_METHOD__   \
    @throw [ NSException exceptionWithName: NSGenericException  \
                         reason: [ NSString stringWithFormat: @"unimplemented pure virtual method `%@` in `%@` " \
                                                               "from instance: %p" \
                                                            , NSStringFromSelector( _cmd )          \
                                                            , NSStringFromClass( [ self class ] )   \
                                                            , self ]                                \
                       userInfo: nil ]

#if DEBUG
#   define __CAVEMEN_DEBUGGING__PRINT_WHICH_METHOD_INVOKED__   \
        NSLog( @"-[ %@ %@ ] be invoked"                        \
            , NSStringFromClass( [ self class ] )              \
            , NSStringFromSelector( _cmd )                     \
            )
#else
#   define __CAVEMEN_DEBUGGING__PRINT_WHICH_METHOD_INVOKED__
#endif

#define IBACTION_BUT_NOT_FOR_IB IBAction

#define USER_DEFAULTS  [ NSUserDefaults standardUserDefaults ]
#define NOTIFICATION_CENTER [ NSNotificationCenter defaultCenter ]

#define GENERAL_PASTEBOARD [ NSPasteboard generalPasteboard ]

#define FLAT    0
#define TEXTURE !FLAT

#define RELEASE_AND_NIL( _Object )  \
    [ _Object release ];            \
    _Object = nil                   \

// User Defaults Keys
#define OMCDefaultsKeyCalStyle                      @"OMCDefaultsKeyCalStyle"
#define OMCDefaultsKeyStartAtLogin                  @"OMCDefaultsKeyStartAtLogin"
#define OMCDefaultsKeyCurrentAryForProgrammerStyle  @"OMCDefaultsKeyCurrentAryForProgrammerStyle"
#define OMCDefaultsKeyCalloutByKeyCombination       @"OMCDefaultsKeyCalloutByKeyCombination"

typedef NS_ENUM( short, OMCCalStyle) { OMCBasicStyle, OMCScientificStyle, OMCProgrammerStyle };
typedef NS_ENUM( short, OMFBehaviorWhileStarting ) { OMFStartAtLogin, OMFNotStartAtLogin };

NSString extern* const OMCFlatStyle;
NSString extern* const OMCTextureStyle;

#define PI              3.141592653589793
#define EULER_NUMBER    2.718281828459045

typedef NS_ENUM( short, OMCButtonType )
    { OMCAnd = 0,      OMCOr = 1,      OMCNor = 2,         OMCXor = 3
    , OMCLsh = 4,      OMCRsh = 5,     OMCRoL = 6,         OMCRoR = 7
    , OMC2_s = 8,      OMC1_s = 9,     OMCMod = 10,        OMCFactorial = 11

    , OMCOne = 12,     OMCTwo = 13,    OMCThree = 14,      OMCFour = 15
    , OMCFive = 16,    OMCSix = 17,    OMCSeven = 18,      OMCEight = 19
    , OMCNine = 20,    OMCZero = 21,   OMCDoubleZero = 22
    , OMC0xA = 23,     OMC0xB = 24,    OMC0xC = 25,        OMC0xD = 26
    , OMC0xE = 27,     OMC0xF = 28,    OMC0xFF = 29

    , OMCDel = 30,     OMCAC = 31,     OMCClear = 32,      OMCEnter = 33

    , OMCAdd = 34,     OMCSub = 35,    OMCMuliply = 36, OMCDivide = 37
    , OMCLeftParenthesis = 38,         OMCRightParenthesis = 39

    , OMCMemoryClear = 40, OMCMemoryAdd = 41, OMCMemorySub = 42, OMCMemoryRead = 43

    , OMCPositiveAndNegative = 44

    , OMCFloatPoint = 45

    , OMCShift = 46,       OMCPercent = 47
    , OMCReciprocal = 48,  OMCSquare = 49,     OMCCube = 50,   OMCxPower = 51
    , OMCSqrt = 53,        OMCToggleTrigonometircMode = 54

    , OMCCubeRoot = 74,    OMCxRoot = 75
    , OMCe_x = 76,         OMC2_x = 77,        OMC10_x = 78

    , OMCLog2 = 55,        OMCLog10 = 59,      OMCIn = 63

    , OMCSin = 56,         OMCCos = 57,        OMCTan = 58
    , OMCSinh = 60,        OMCCosh = 61,       OMCTanh = 62

    , OMCAsin = 68,        OMCAcos = 69,       OMCAtan = 70
    , OMCAsinh = 71,       OMCAcosh = 72,      OMCAtanh = 73

    , OMCPi = 64,          OMCe = 65,          OMCRand = 66,   OMCEE = 67
    };

typedef NS_ENUM( short, OMCAry ) { OMCOctal, OMCDecimal, OMCHex };
typedef NS_ENUM( short, OMCTrigonometricMode ) { OMCDegreeMode, OMCRadianMode };
typedef NS_ENUM( short, OMCTypingState ) { OMCWaitAllOperands, OMCWaitRhsOperand, OMCFinishedTyping };

#import <objc/runtime.h>
#import "NSString+OMCString.h"
#import "NSMutableString+OMCMutableString.h"

#define BIT_COUNT       64
#define BIT_GROUP       4
#define BIT_GROUP_COUNT BIT_COUNT / BIT_GROUP
#define BIT_GROUP_HORIZONTAL_GAP    15.f
#define BIT_GROUP_VERTICAL_GAP      4.5f

// Identifier of binary operators
NSString extern* const OMCAddOperatorIdentifier;
NSString extern* const OMCSubOperatorIdentifier;
NSString extern* const OMCMultiplyOperatorIdentifier;
NSString extern* const OMCDivideOperatorIdentifier;

NSString extern* const OMCPowXOperatorIdentifier;
NSString extern* const OMCxRootIdentifier;
NSString extern* const OMCeIdentifier;

NSString extern* const OMCAndOperatorIdentifier;
NSString extern* const OMCOrOperatorIdentifier;
NSString extern* const OMCNorOperatorIdentifier;
NSString extern* const OMCXorOperatorIdentifier;
NSString extern* const OMCLshOperatorIdentifier;
NSString extern* const OMCRshOperatorIdentifier;
NSString extern* const OMCModOperatorIdentifier;

#define SHIFT_COMMAND_SPACE__GLOBAL_KEY     0x1

NSString extern* const OMCPressedShiftCommandSpaceGlobalKey;

////////////////////////////////////////////////////////////////////////////

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