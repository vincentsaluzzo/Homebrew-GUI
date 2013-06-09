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
@synthesize availableFormulas, formulaArrayController;

-(void)awakeFromNib {
    RAC(installButton.isEnabled) =
    [RACSignal combineLatest:@[RACAble(availableFormulasTableView.selectedRow)]
                      reduce:^(NSInteger selectedRow) {
                          return @(selectedRow != -1);
                      }];
}

-(IBAction) showInstallWindow:(id)sender {
    [self.view.window makeKeyAndOrderFront:sender];
    [[LHBModel sharedInstance] addObserver:self forKeyPath:@"installedFormulas" options:(NSKeyValueObservingOptionNew) context:NULL];
    [self refreshFormulasAvailableForInstallation];
}

-(IBAction) install:(id)sender {
    NSString *formulaToInstall = [[formulaArrayController arrangedObjects] objectAtIndex:[_availableFormulasTableView selectedRow]];
    if ([formulaToInstall compare:@""] != NSOrderedSame) {
    [[(LHBAppDelegate *)[NSApp delegate] homebrewProxy] install:formulaToInstall completion:^(NSString *output){NSLog(@"Output from installation via XPC: %@",output);}];
        [[(LHBAppDelegate *)[NSApp delegate] homebrewProxy] installedFormulaList:^(NSArray *list) {
            NSLog(@"Received installed formula listing via XPC: %@", list);
            [[LHBModel sharedInstance] setInstalledFormulas:list];
            [self refreshFormulasAvailableForInstallation];
        }];
    }
}

-(void)refreshFormulasAvailableForInstallation {
    [[(LHBAppDelegate *)[NSApp delegate] homebrewProxy] search:@"" completion:^(NSString *output){
        //NSLog(@"Output from search via XPC: %@",output);
        availableFormulas = [[output componentsSeparatedByString:@"\n"] mutableCopy];
        [availableFormulas removeObjectsInArray:[[LHBModel sharedInstance] installedFormulas]];
        [formulaArrayController setContent:availableFormulas];
        //NSLog(@"Array Controller arrangedObjects: %@", [formulaArrayController arrangedObjects]);
        [_availableFormulasTableView reloadData];
        
    }];
}

#pragma mark — Key-Value-Observing
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"installedFormulas"]) {
        [self refreshFormulasAvailableForInstallation];
    }
}

#pragma mark - NSTableView Delegate
-(void) tableViewSelectionDidChange:(NSNotification *)notification {
    if([_availableFormulasTableView selectedRow] == -1) {
        [_installButton setEnabled:NO];
    } else {
        [_installButton setEnabled:YES];
    }
}

@end
