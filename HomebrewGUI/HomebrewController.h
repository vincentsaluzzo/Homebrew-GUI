//
//  HomebrewController.h
//  HomebrewGUI
//
//  Created by Vincent Saluzzo on 06/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLCXPCHomebrewProxy.h"
#import "AppDelegate.h"

@interface HomebrewController : NSViewController<NSTableViewDataSource, NSTableViewDelegate> {
    IBOutlet NSTableView* listOfApplicationAlreadyInstalled;
    IBOutlet NSToolbar* MainToolbar;
    IBOutlet NSToolbarItem* MainToolbarItem_Uninstall;
}

-(IBAction) refreshListOfApplicationAlreadyInstalled:(id)sender;
-(IBAction) uninstall:(id)sender;
@property (weak) IBOutlet NSArrayController *installedFormulaArrayController;
@property (strong) NSArray* arrayOfApplicationInstalled;
@end
