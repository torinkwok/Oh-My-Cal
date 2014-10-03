//
//  OMCAppDelegate.m
//  OMCStartHelper
//
//  Created by Tong G. on 10/3/14.
//  Copyright (c) 2014 Tong G. All rights reserved.
//

#import "OMCAppDelegate.h"

@implementation OMCAppDelegate

- ( void ) applicationDidFinishLaunching: ( NSNotification* )_Notif
    {
    NSString *appPath = [[NSBundle mainBundle] bundlePath];
    appPath = [ appPath stringByReplacingOccurrencesOfString: @"/Contents/Library/LoginItems/OMCStartHelper.app" withString: @"" ];
    appPath = [ appPath stringByAppendingPathComponent: @"/Contents/MacOS/Oh My Cal!" ];

    if ( ![ [ NSFileManager defaultManager ] fileExistsAtPath: appPath ] )
        return;

    NSArray* runningArray = [ NSRunningApplication runningApplicationsWithBundleIdentifier: @"individual.TongGuo.Oh-My-Cal-" ];
    if ( [ runningArray count ] > 0 )
        return;

    [ [ NSWorkspace sharedWorkspace ] launchApplication: appPath ];
    }

@end
