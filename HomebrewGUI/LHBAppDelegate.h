//
//  AppDelegate.h
//  HomebrewGUI
//
//  Created by Vincent Saluzzo on 06/12/11.
//  Copyright (c) 2011 Labastille Laser Corp. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LLCXPCHomebrewProxy.h"
#import "LHBXPCApplicationProxy.h"
#import "LHBModel.h"

@interface LHBAppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (strong, readonly) LLCXPCHomebrewProxy *homebrewProxy;
@property (strong, readonly) LHBXPCApplicationProxy *applicationProxy;
@property (strong) IBOutlet NSTextView *homebrewOutputTextView;
@property (strong, readonly) LHBModel *homebrewModel;
@end
