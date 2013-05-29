//
//  HomebrewController.h
//  HomebrewGUI
//
//  Created by Vincent Saluzzo on 06/12/11.
//  Copyright (c) 2011 Labastille Laser Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLCXPCHomebrewProxy.h"
#import "LHBAppDelegate.h"

@interface LHBInstalledViewController : NSViewController<NSTableViewDataSource, NSTableViewDelegate> {
    IBOutlet NSTableView* installedFormulaTableView;
    IBOutlet NSToolbar* MainToolbar;
    IBOutlet NSToolbarItem* MainToolbarItem_Uninstall;
    __weak NSMenuItem *_homebrewOutputMenuItem;
}

-(IBAction) refreshInstalledFormulas:(id)sender;
-(IBAction) uninstall:(id)sender;
- (IBAction)showHomebrewOutput:(id)sender;
-(void) updateHomebrewStatus;

@property (weak) IBOutlet NSArrayController *installedFormulaArrayController;
@property (weak) IBOutlet NSTextField *statusTextField;
@property (unsafe_unretained) IBOutlet NSWindow *homebrewOutputWindow;
//@property (strong) NSArray* arrayOfApplicationInstalled;
@property (weak) IBOutlet NSMenuItem *homebrewOutputMenuItem;
@end
