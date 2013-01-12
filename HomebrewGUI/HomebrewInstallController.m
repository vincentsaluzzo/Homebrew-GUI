//
//  HomebrewInstallController.m
//  HomebrewGUI
//
//  Created by Vincent Saluzzo on 08/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HomebrewInstallController.h"

@interface HomebrewInstallController ()

@end

@implementation HomebrewInstallController
@synthesize installButton, arrayOfApplicationToInstall, formulaArrayController;

-(IBAction) showInstallWindow:(id)sender {
    [self.view.window orderFrontRegardless];
    
    [[(AppDelegate *)[NSApp delegate] homebrewProxy] search:@"" completion:^(NSString *output){
        NSLog(@"Output from search via XPC: %@",output);
        arrayOfApplicationToInstall = [output componentsSeparatedByString:@"\n"];
        [formulaArrayController setContent:arrayOfApplicationToInstall];
        NSLog(@"Array Controller arrangedObjects: %@", [formulaArrayController arrangedObjects]);
        [listOfApplicationToInstall reloadData];
    }];
}

-(IBAction) install:(id)sender {
    NSString *formulaToInstall = [[formulaArrayController arrangedObjects] objectAtIndex:[listOfApplicationToInstall selectedRow]];
    if (![formulaToInstall compare:@""]) {
    [[(AppDelegate *)[NSApp delegate] homebrewProxy] install:@"test" completion:^(NSString *output){NSLog(@"Output from installation via XPC: %@",output);}];
    }
}

#pragma mark - NSTableView Delegate
-(void) tableViewSelectionDidChange:(NSNotification *)notification {
    if([listOfApplicationToInstall selectedRow] == -1) {
        [installButton setEnabled:NO];
    } else {
        [installButton setEnabled:YES];
    }
}

@end
