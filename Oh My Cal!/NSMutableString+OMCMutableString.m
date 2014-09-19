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

#import "NSMutableString+OMCMutableString.h"

// NSMutableString + OMCCalculation
@implementation NSMutableString ( OMCCalculation )

- ( void ) clear
    {
    [ self deleteCharactersInRange: NSMakeRange( 0, [ self length ] ) ];
    }

- ( void ) replaceAllWithString: ( NSString* )_String
    {
    if ( _String )
        [ self replaceCharactersInRange: NSMakeRange( 0, self.length ) withString: _String ];
    }

- ( void ) deleteTheLastCharacter
    {
    [ self deleteCharactersInRange: NSMakeRange( self.length - 1, 1 ) ];
    }

- ( BOOL ) contains: ( NSString* )_SubString
    {
    BOOL contains = NO;

    NSRange range = [ self rangeOfString: _SubString ];
    if ( range.location != NSNotFound )
        contains = YES;

    return contains;
    }

- ( void ) fillWith: ( NSString* )_FillString
              count: ( NSInteger )_Count
    {
    for ( NSInteger index = 0; index < _Count; index++ )
        [ self appendString: _FillString ];
    }

@end // NSMutableString + OMCCalculation

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