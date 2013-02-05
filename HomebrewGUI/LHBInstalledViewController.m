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
        NSRange r = NSMakeRange(10, 42);
        NSValue *rangeValue = [NSValue valueWithBytes:&r objCType:@encode(NSRange)];
        NSLog(@"%@", rangeValue);
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

- (IBAction)showHomebrewOutput:(id)sender {
    if ([sender isEqual:_homebrewOutputMenuItem] && ![_homebrewOutputWindow isVisible]) {
        [_homebrewOutputMenuItem setTitle:@"Hide Homebrew Output"];
    } else {
        [_homebrewOutputMenuItem setTitle:@"Show Homebrew Output"];
    }
    if ([_homebrewOutputWindow isVisible]) {
        [_homebrewOutputWindow close];
    } else {
        [_homebrewOutputWindow makeKeyAndOrderFront:sender];
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
