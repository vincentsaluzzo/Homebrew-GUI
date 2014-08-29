//
//  LLCXPCListenerDelegate.m
//  Homebrew GUI
//
//  Created by Seán Labastille on 12/1/13.
//
//

#import "LLCXPCListenerDelegate.h"
LLCXPCHomebrewProxy *homebrewProxy;

@implementation LLCXPCListenerDelegate 
-(BOOL)listener:(NSXPCListener *)listener shouldAcceptNewConnection:(NSXPCConnection *)newConnection {
    NSXPCInterface *brewXPCInterface = [NSXPCInterface interfaceWithProtocol:@protocol(LLCXPCHomebrew)];
    [newConnection setExportedInterface:brewXPCInterface];
    homebrewProxy = [[LLCXPCHomebrewProxy alloc] init];
    [newConnection setExportedObject:homebrewProxy];
    [newConnection setRemoteObjectInterface:[NSXPCInterface interfaceWithProtocol:@protocol(LHBXPCApplication)]];
    [homebrewProxy setApplicationProxy:[newConnection remoteObjectProxy]];
    [newConnection resume];
    return YES;
}
@end
