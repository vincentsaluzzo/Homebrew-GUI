//
//  HomebrewInstallController.h
//  HomebrewGUI
//
//  Created by Vincent Saluzzo on 08/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLCXPCHomebrewProxy.h"
#import "AppDelegate.h"

@interface HomebrewInstallController : NSViewController<NSTableViewDataSource, NSTableViewDelegate, NSWindowDelegate> {
    IBOutlet NSTableView* listOfApplicationToInstall;
    
    IBOutlet NSToolbar* InstallToolbar;
    IBOutlet NSToolbarItem* InstallToolbarItem_Install;
    
    
    
    __weak NSButton *_installButton;
    IBOutlet NSWindow* window;
    
}
-(IBAction) showInstallWindow:(id)sender;
-(IBAction) install:(id)sender;
@property (weak) IBOutlet NSButton *installButton;
@property (weak) IBOutlet NSSearchFieldCell *formulaSearchFieldCell;
@property (weak) IBOutlet NSArrayController *formulaArrayController;
@property (strong) NSArray* arrayOfApplicationToInstall;
@end
