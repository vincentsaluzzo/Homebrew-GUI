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
    [self updateHomebrewStatus];
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
        [[LHBModel sharedInstance] setInstalledFormulas:list] ;
        [installedFormulaArrayController setContent:[[LHBModel sharedInstance] installedFormulas]];
    }];
}

-(IBAction)uninstall:(id)sender {
    if([installedFormulaTableView selectedRow] != -1) {
        [[(LHBAppDelegate *)[NSApp delegate] homebrewProxy]
         uninstall:[[LHBModel sharedInstance] installedFormulas][[installedFormulaTableView selectedRow]]
         completion:^(NSString *output) {
             NSLog(@"Uninstalled via XPC: %@", output);
             [self refreshInstalledFormulas:nil];
         }];
        
    }
}

- (IBAction)showHomebrewOutput:(id)sender {
    if (![_homebrewOutputWindow isVisible]) {
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

-(void)updateHomebrewStatus {
    [_statusTextField setTextColor:[NSColor blackColor]];
    [_statusTextField setStringValue:@"Checking in with the doctor…"];
    [[(LHBAppDelegate *)[NSApp delegate] homebrewProxy] callDoctor:^(NSString *diagnosis) {
        NSError *regularExpressionError = [[NSError alloc] init];
        NSRegularExpression *warningExpression = [NSRegularExpression regularExpressionWithPattern:@"Warning\\:" options:0 error:&regularExpressionError];
        NSUInteger warningMatchCount = [warningExpression numberOfMatchesInString:diagnosis options:0 range:NSMakeRange(0, [diagnosis length])];
        if (warningMatchCount > 0) {
            [_statusTextField setTextColor:[NSColor redColor]];
            [_statusTextField setStringValue:[NSString stringWithFormat:@"%ld Doctor's %@", (unsigned long)warningMatchCount,(unsigned long)warningMatchCount > 1 ? @"Warnings" : @"Warning"]];
            [(LHBAppDelegate *)[NSApp delegate] scrollOutputToEnd];
            [self showHomebrewOutput:nil];
        } else {
            [_statusTextField setTextColor:[NSColor colorWithCalibratedRed:0.180 green:0.466 blue:0.014 alpha:1.000]];
            [_statusTextField setStringValue:diagnosis];
        }
    }];
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
