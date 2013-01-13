//
//  HomebrewInstallController.m
//  HomebrewGUI
//
//  Created by Vincent Saluzzo on 08/12/11.
//  Copyright (c) 2011 Labastille Laser Corp. All rights reserved.
//

#import "LHBInstallerViewController.h"

@interface LHBInstallerViewController ()

@end

@implementation LHBInstallerViewController
@synthesize installButton, availableFormulas, formulaArrayController;

-(IBAction) showInstallWindow:(id)sender {
    [self.view.window orderFrontRegardless];
    [self refreshFormulasAvailableForInstallation];
}

-(IBAction) install:(id)sender {
    NSString *formulaToInstall = [[formulaArrayController arrangedObjects] objectAtIndex:[availableFormulasTableView selectedRow]];
    if ([formulaToInstall compare:@""] != NSOrderedSame) {
    [[(LHBAppDelegate *)[NSApp delegate] homebrewProxy] install:formulaToInstall completion:^(NSString *output){NSLog(@"Output from installation via XPC: %@",output);}];
        [[(LHBAppDelegate *)[NSApp delegate] homebrewProxy] installedFormulaList:^(NSArray *list) {
            NSLog(@"Received installed formula listing via XPC: %@", list);
            [[(LHBAppDelegate *)[NSApp delegate] homebrewModel] setInstalledFormulas:list];
            [self refreshFormulasAvailableForInstallation];
        }];
    }
}

-(void)refreshFormulasAvailableForInstallation {
    [[(LHBAppDelegate *)[NSApp delegate] homebrewProxy] search:@"" completion:^(NSString *output){
        //NSLog(@"Output from search via XPC: %@",output);
        availableFormulas = [[output componentsSeparatedByString:@"\n"] mutableCopy];
        [availableFormulas removeObjectsInArray:[[[NSApp delegate] homebrewModel] installedFormulas]];
        [formulaArrayController setContent:availableFormulas];
        //NSLog(@"Array Controller arrangedObjects: %@", [formulaArrayController arrangedObjects]);
        [availableFormulasTableView reloadData];
    }];
}

#pragma mark - NSTableView Delegate
-(void) tableViewSelectionDidChange:(NSNotification *)notification {
    if([availableFormulasTableView selectedRow] == -1) {
        [installButton setEnabled:NO];
    } else {
        [installButton setEnabled:YES];
    }
}

@end
