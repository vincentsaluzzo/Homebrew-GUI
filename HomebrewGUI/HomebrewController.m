//
//  HomebrewController.m
//  HomebrewGUI
//
//  Created by Vincent Saluzzo on 06/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HomebrewController.h"

@implementation HomebrewController
@synthesize arrayOfApplicationInstalled, installedFormulaArrayController;
-(void)awakeFromNib {
    [self refreshListOfApplicationAlreadyInstalled:nil];
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem {
    //NSLog(@"Validating Toolbar Item: %@:", theItem);
    if ([theItem isEqualTo:MainToolbarItem_Uninstall]) {
        if ([listOfApplicationAlreadyInstalled selectedRow] == -1) {
            return NO;
        }
    }
    return YES;
}


-(IBAction) refreshListOfApplicationAlreadyInstalled:(id)sender {
    [[(AppDelegate *)[NSApp delegate] homebrewProxy] installedFormulaList:^(NSArray *list) {
        NSLog(@"Received installed formula listing via XPC: %@", list);
        arrayOfApplicationInstalled = list;
        [installedFormulaArrayController setContent:arrayOfApplicationInstalled];
    }];
}

-(IBAction)uninstall:(id)sender {
    if([listOfApplicationAlreadyInstalled selectedRow] != -1) {
        [[(AppDelegate *)[NSApp delegate] homebrewProxy]
         uninstall:arrayOfApplicationInstalled[[listOfApplicationAlreadyInstalled selectedRow]]
         completion:^(NSString *output) {
            NSLog(@"Uninstalled via XPC: %@", output);
            [self performSelector:@selector(refreshListOfApplicationAlreadyInstalled:)];
        }];
        
    }
}

#pragma mark - NSTableView Delegate

-(void) tableViewSelectionDidChange:(NSNotification *)notification {
    if([listOfApplicationAlreadyInstalled selectedRow] == -1) {
        [MainToolbarItem_Uninstall setEnabled:NO];
    } else {
        [MainToolbarItem_Uninstall setEnabled:YES];
    }
}
@end
