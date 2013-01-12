//
//  AppDelegate.m
//  HomebrewGUI
//
//  Created by Vincent Saluzzo on 06/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (strong) NSXPCInterface *brewXPCInterface;
@property (strong) NSXPCConnection *connection;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize homebrewProxy, brewXPCInterface, connection;

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    brewXPCInterface = [NSXPCInterface interfaceWithProtocol:@protocol(LLCXPCHomebrew)];
    connection = [[NSXPCConnection alloc] initWithServiceName:@"LLC.HomebrewXPC"];
    [connection setRemoteObjectInterface:brewXPCInterface];
    [connection resume];
    homebrewProxy = [connection remoteObjectProxy];
}

@end
