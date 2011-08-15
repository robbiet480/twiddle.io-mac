//
//  TwiddleIOAppDelegate.m
//  TwiddleIO
//
//  Created by Robbie Trencheny on 8/15/11.
//  Copyright 2011 Sutter Studios. All rights reserved.
//

#import "TwiddleIOAppDelegate.h"
#import "SocketIO.h"
#import "Growl.framework/Headers/GrowlApplicationBridge.h"

@interface growlExample :NSObject <GrowlApplicationBridgeDelegate> {} 
-(void) growlAlert:(NSString *)message title:(NSString *)title;
-(void) growlAlertWithClickContext:(NSString *)message title:(NSString *)title;
-(void) exampleClickContext;
@end

@implementation TwiddleIOAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    SocketIO *socketIO = [[SocketIO alloc] initWithDelegate:self];
    [socketIO connectToHost:@"localhost" onPort:3000];
    [GrowlApplicationBridge setGrowlDelegate:self];
}

- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveEvent() >>> data: %@", packet.data);
    NSLog(@"Packet Recieved.");
    //NSLog(@"packet name: %@", packet.name);
    
    NSArray *messagearr = (NSArray *)[packet valueForKey:@"args"];
    NSLog(@"%@", messagearr);
    for (NSDictionary *item in messagearr)
    {
        // You can retrieve individual values using objectForKey on the status NSDictionary
        // This will print the tweet and username to the console
        NSLog(@"%@ - %@", [item objectForKey:@"message"], [item objectForKey:@"sender"]);
        [GrowlApplicationBridge notifyWithTitle:[item objectForKey:@"sender"] /* notifyWithTitle is a required parameter */
                                    description:[item objectForKey:@"message"] /* description is a required parameter */
                               notificationName:@"example" /* notification name is a required parameter, and must exist in the dictionary we registered with growl */
                                       iconData:nil /* not required, growl defaults to using the application icon, only needed if you want to specify an icon. */ 
                                       priority:0 /* how high of priority the alert is, 0 is default */
                                       isSticky:NO /* indicates if we want the alert to stay on screen till clicked */
                                   clickContext:nil]; /* click context is the method we want called when the alert is clicked, nil for none */

    }
    
    
    
}
- (void) socketIODidConnect:(SocketIO *)socketIO {
    NSLog(@"sending web-start");
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys: @"asdfaasfa42432asdf", @"UDID", nil];
    [socketIO sendEvent:@"web-start" withData:data];
    return;
}

/* Begin methods from GrowlApplicationBridgeDelegate */
- (NSDictionary *) registrationDictionaryForGrowl { /* Only implement this method if you do not plan on just placing a plist with the same data in your app bundle (see growl documentation) */
    NSArray *array = [NSArray arrayWithObjects:@"example", @"error", nil]; /* each string represents a notification name that will be valid for us to use in alert methods */
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:1], /* growl 0.7 through growl 1.1 use ticket version 1 */
                          @"TicketVersion", /* Required key in dictionary */
                          array, /* defines which notification names our application can use, we defined example and error above */
                          @"AllNotifications", /*Required key in dictionary */
                          array, /* using the same array sets all notification names on by default */
                          @"DefaultNotifications", /* Required key in dictionary */
                          nil];
    return dict;
}

- (void) growlNotificationWasClicked:(id)clickContext{
    if (clickContext && [clickContext isEqualToString:@"exampleClickContext"])
        [self exampleClickContext];
    return;
}

/* These methods are not required to be implemented, so we will skip them in this example 
 - (NSString *) applicationNameForGrowl;
 - (NSData *) applicationIconDataForGrowl;
 - (void) growlNotificationTimedOut:(id)clickContext;
 */ 
/* There is no good reason not to rely on the what Growl provides for the next two methods, in otherwords, do not override these methods
 - (void) growlIsReady;
 - (void) growlIsInstalled;
 */
/* End Methods from GrowlApplicationBridgeDelegate */

/* Simple method to make an alert with growl that has no click context */
-(void) growlAlert:(NSString *)message title:(NSString *)title{
    [GrowlApplicationBridge notifyWithTitle:title /* notifyWithTitle is a required parameter */
                                description:message /* description is a required parameter */
                           notificationName:@"example" /* notification name is a required parameter, and must exist in the dictionary we registered with growl */
                                   iconData:nil /* not required, growl defaults to using the application icon, only needed if you want to specify an icon. */ 
                                   priority:0 /* how high of priority the alert is, 0 is default */
                                   isSticky:NO /* indicates if we want the alert to stay on screen till clicked */
                               clickContext:nil]; /* click context is the method we want called when the alert is clicked, nil for none */
}

@end
