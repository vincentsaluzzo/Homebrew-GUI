//
//  HomebrewController.m
//  HomebrewGUI
//
//  Created by Vincent Saluzzo on 06/12/11.
//  Copyright (c) 2011 Labastille Laser Corp. All rights reserved.
//

#import "LHBInstalledViewController.h"

@implementation LHBInstalledViewController
@synthesize installedFormulaArrayController;
-(void)awakeFromNib {
    [self refreshInstalledFormulas:nil];
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem {
    //NSLog(@"Validating Toolbar Item: %@:", theItem);
    if ([theItem isEqualTo:MainToolbarItem_Uninstall]) {
        if ([installedFormulaTableView selectedRow] == -1) {
            return NO;
        }
    }
    return YES;
}

-(IBAction) refreshInstalledFormulas:(id)sender {
    [[(LHBAppDelegate *)[NSApp delegate] homebrewProxy] installedFormulaList:^(NSArray *list) {
        //NSLog(@"Received installed formula listing via XPC: %@", list);
        [[(LHBAppDelegate *)[NSApp delegate] homebrewModel] setInstalledFormulas:list] ;
        [installedFormulaArrayController setContent:[[(LHBAppDelegate *)[NSApp delegate] homebrewModel] installedFormulas]];
    }];
}

-(IBAction)uninstall:(id)sender {
    if([installedFormulaTableView selectedRow] != -1) {
        [[(LHBAppDelegate *)[NSApp delegate] homebrewProxy]
         uninstall:[[(LHBAppDelegate *)[NSApp delegate] homebrewModel] installedFormulas][[installedFormulaTableView selectedRow]]
         completion:^(NSString *output) {
            NSLog(@"Uninstalled via XPC: %@", output);
            [self refreshInstalledFormulas:nil];
        }];
        
    }
}

#pragma mark - NSTableView Delegate

-(void) tableViewSelectionDidChange:(NSNotification *)notification {
    if([installedFormulaTableView selectedRow] == -1) {
        [MainToolbarItem_Uninstall setEnabled:NO];
    } else {
        [MainToolbarItem_Uninstall setEnabled:YES];
    }
}
@end
