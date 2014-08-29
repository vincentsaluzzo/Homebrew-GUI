//
//  HomebrewInstallController.h
//  HomebrewGUI
//
//  Created by Vincent Saluzzo on 08/12/11.
//  Copyright (c) 2011 Labastille Laser Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLCXPCHomebrewProxy.h"
#import "LHBAppDelegate.h"

@interface LHBInstallerViewController : NSViewController<NSTableViewDataSource, NSTableViewDelegate, NSWindowDelegate>

-(IBAction) showInstallWindow:(id)sender;
-(IBAction) install:(id)sender;

@property (weak) IBOutlet NSTableView* availableFormulasTableView;
@property (weak) IBOutlet NSWindow* window;

@property (weak) IBOutlet NSButton *installButton;
@property (weak) IBOutlet NSSearchFieldCell *formulaSearchFieldCell;
@property (weak) IBOutlet NSArrayController *formulaArrayController;
@property (weak) IBOutlet NSTextField *statusTextField;

@property (strong) NSMutableArray* availableFormulas;


@end
