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

#import <XCTest/XCTest.h>

#import "OMCAppDelegate.h"
#import "OMCOperand.h"

@interface BasicTestForOMCOperand : XCTestCase

@property ( nonatomic, unsafe_unretained ) NSApplication* app;
@property ( nonatomic, unsafe_unretained ) OMCAppDelegate* appDelegate;
@property ( nonatomic, retain ) OMCOperand* lhsOperand;
@property ( nonatomic, retain ) OMCOperand* rhsOperand;

@end

@implementation BasicTestForOMCOperand

- ( void ) setUp
    {
    /* TODO: Put setup code here.
     * This method is called before the invocation of each test method in the class.
     */

    self.app = [ NSApplication sharedApplication ];
    self.appDelegate = [ NSApp delegate ];

    XCTAssertNotNil( self.app, @"Test for self.app failed!" );
    XCTAssertNotNil( self.appDelegate, @"Test for self.appDelegate failed!" );

    [ super setUp ];
    }

- ( void ) tearDown
    {
    /* TODO: Put teardown code here.
     * This method is called after the invocation of each test method in the class.
     */

    [ super tearDown ];
    }

- ( void ) testOperandCreation
    {
    NSArray* array = @[ @1, @2, @3 ];
    XCTAssertThrowsSpecific( array[ 4 ], NSException );
    XCTAssertThrowsSpecificNamed( array[ 4 ], NSException, NSRangeException );
    XCTAssertNoThrowSpecificNamed( array[ 4 ], NSException, NSInvalidArgumentException );

    // operandWithDecimalNumber:
    self.lhsOperand = [ OMCOperand operandWithDecimalNumber: [ NSDecimalNumber decimalNumberWithString: @"41.513" ] ];
    XCTAssertNotNil( self.lhsOperand
                   , @"%@ ♦︎ self.lhsOperand ♦︎ Part 1 ♦︎ FAILED!"
                   , NSStringFromSelector( @selector( operandWithDecimalNumber: ) )
                   );

    XCTAssertEqualObjects( self.lhsOperand.decimalNumber
                         , [ NSDecimalNumber decimalNumberWithString: @"41.513" ]
                         , @"operandWithDecimalNumber: ♦︎ self.lhsOperand ♦︎ Part 2 ♦︎ FAILED!"
                         );

    self.rhsOperand = [ OMCOperand operandWithDecimalNumber: [ NSDecimalNumber decimalNumberWithString: @"73423425" ] ];
    XCTAssertNotNil( self.rhsOperand
                   , @"operandWithDecimalNumber: ♦︎ self.rhsOperand ♦︎ Part 1 ♦︎ FAILED!"
                   );

    XCTAssertEqualObjects( self.rhsOperand.decimalNumber
                         , [ NSDecimalNumber decimalNumberWithString: @"73423425" ]
                         , @"operandWithDecimalNumber: ♦︎ self.rhsOperand ♦︎ Part 2 ♦︎ FAILED!"
                         );

    // operandWithString:
    self.lhsOperand = [ OMCOperand operandWithString: @"111" ];
    XCTAssertNotNil( self.lhsOperand
                   , @"operandWithString: ♦︎ self.lhsOperand ♦︎ Part 1 ♦︎ FAILED!"
                   );

    XCTAssertEqualObjects( self.lhsOperand.decimalNumber.stringValue
                         , @"111"
                         , @"operandWithString: ♦︎ self.lhsOperand ♦︎ Part 2 ♦︎ FAILED!"
                         );

    self.rhsOperand = [ OMCOperand operandWithString: @"213.4214" ];
    XCTAssertNotNil( self.rhsOperand
                   , @"operandWithString: ♦︎ self.rhsOperand ♦︎ Part 1 ♦︎ FAILED!"
                   );

    XCTAssertEqualObjects( self.rhsOperand.decimalNumber.stringValue
                         , @"213.4214"
                         , @"operandWithString: ♦︎ self.rhsOperand ♦︎ Part 2 ♦︎ FAILED!"
                         );

//    self.lhsOperand = [ OMCOperand operandWithDecimalNumber
    }

- ( void ) testAddition
    {

    }

@end

//////////////////////////////////////////////////////////////////////////////

/*****************************************************************************
 **                                                                         **
 **                                                                         **
 **      █████▒█    ██  ▄████▄   ██ ▄█▀       ██████╗ ██╗   ██╗ ██████╗     **
 **    ▓██   ▒ ██  ▓██▒▒██▀ ▀█   ██▄█▒        ██╔══██╗██║   ██║██╔════╝     **
 **    ▒████ ░▓██  ▒██░▒▓█    ▄ ▓███▄░        ██████╔╝██║   ██║██║  ███╗    **
 **    ░▓█▒  ░▓▓█  ░██░▒▓▓▄ ▄██▒▓██ █▄        ██╔══██╗██║   ██║██║   ██║    **
 **    ░▒█░   ▒▒█████▓ ▒ ▓███▀ ░▒██▒ █▄       ██████╔╝╚██████╔╝╚██████╔╝    **
 **     ▒ ░   ░▒▓▒ ▒ ▒ ░ ░▒ ▒  ░▒ ▒▒ ▓▒       ╚═════╝  ╚═════╝  ╚═════╝     **
 **     ░     ░░▒░ ░ ░   ░  ▒   ░ ░▒ ▒░                                     **
 **     ░ ░    ░░░ ░ ░ ░        ░ ░░ ░                                      **
 **              ░     ░ ░      ░  ░                                        **
 **                    ░                                                    **
 **                                                                         **
 ****************************************************************************/