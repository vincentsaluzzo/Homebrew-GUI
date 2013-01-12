//
//  AppDelegate.h
//  HomebrewGUI
//
//  Created by Vincent Saluzzo on 06/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LLCXPCHomebrewProxy.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (strong) LLCXPCHomebrewProxy *homebrewProxy;
@end
