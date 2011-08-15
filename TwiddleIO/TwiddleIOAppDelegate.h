//
//  TwiddleIOAppDelegate.h
//  TwiddleIO
//
//  Created by Robbie Trencheny on 8/15/11.
//  Copyright 2011 Sutter Studios. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TwiddleIOAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *_window;
}

@property (strong) IBOutlet NSWindow *window;

@end
