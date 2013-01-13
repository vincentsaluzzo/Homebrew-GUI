//
//  AppDelegate.m
//  HomebrewGUI
//
//  Created by Vincent Saluzzo on 06/12/11.
//  Copyright (c) 2011 Labastille Laser Corp. All rights reserved.
//

#import "LHBAppDelegate.h"

@interface LHBAppDelegate ()
@property (strong) NSXPCInterface *brewXPCInterface;
@property (strong) NSXPCConnection *connection;

@end

@implementation LHBAppDelegate
LLCXPCHomebrewProxy *homebrewProxy;
LHBXPCApplicationProxy *applicationProxy;
LHBModel *homebrewModel;
@synthesize window = _window;
@synthesize brewXPCInterface, connection;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
}

- (LHBModel *)homebrewModel {
    if (!homebrewModel) {
        homebrewModel = [[LHBModel alloc] init];
    }
    return homebrewModel;
}

- (LLCXPCHomebrewProxy *)homebrewProxy {
    if (!homebrewProxy) {
        brewXPCInterface = [NSXPCInterface interfaceWithProtocol:@protocol(LLCXPCHomebrew)];
        connection = [[NSXPCConnection alloc] initWithServiceName:@"LLC.HomebrewXPC"];
        [connection setRemoteObjectInterface:brewXPCInterface];
        [connection setExportedInterface:[NSXPCInterface interfaceWithProtocol:@protocol(LHBXPCApplication)]];
        applicationProxy = [[LHBXPCApplicationProxy alloc] init];
        applicationProxy.homebrewOutputTextView = self.homebrewOutputTextView;
        [connection setExportedObject:applicationProxy];
        [connection resume];
        homebrewProxy = [connection remoteObjectProxy];
    }
    return homebrewProxy;
}

@end
