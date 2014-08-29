//
//  LHBXPCApplicationProxy.m
//  Homebrew GUI
//
//  Created by Seán Labastille on 13/1/13.
//  Copyright (c) 2013 Labastille Laser Corp. All rights reserved.
//

#import "LHBXPCApplicationProxy.h"

@implementation LHBXPCApplicationProxy
-(void)report:(NSString *)output {
    BOOL foundBrew = NO;
    if ([output rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"🍺"]].location != NSNotFound) {
        NSError *regularExpressionError = [[NSError alloc] init];
        NSRegularExpression *formulaNameExpression = [NSRegularExpression regularExpressionWithPattern:@"🍺  \\/usr\\/local\\/Cellar\\/([\\w\\d-]+)\\/" options:0 error:&regularExpressionError];
        NSRange formulaNameRange;
        NSArray *formulaNameMatches = [formulaNameExpression matchesInString:output options:0 range:NSMakeRange(0, [output length])];
        if ([formulaNameMatches count] > 0) {
            formulaNameRange = [(NSTextCheckingResult *)(formulaNameMatches[0]) rangeAtIndex:1];
        }
        
        NSUserNotification *completedBrewNotification = [[NSUserNotification alloc] init];
        [completedBrewNotification setTitle:@"Brew Complete"];
        [completedBrewNotification setSubtitle:[output substringWithRange:formulaNameRange]];
        [completedBrewNotification setSoundName:NSUserNotificationDefaultSoundName];
        //[completedBrewNotification setSubtitle:@"The formula has completed installation"];
        [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:completedBrewNotification];
        foundBrew = YES;
    }
    NSAttributedString *outputString = [[NSAttributedString alloc] initWithString:output attributes:@{NSFontAttributeName:[NSFont fontWithName:@"Menlo" size:12.0]}];
    [[[self homebrewOutputTextView] textStorage] performSelectorOnMainThread:@selector(appendAttributedString:) withObject:outputString waitUntilDone:YES];
    if (foundBrew) {
        [[self homebrewOutputTextView] performSelectorOnMainThread:@selector(scrollToEndOfDocument:) withObject:nil waitUntilDone:YES];
    }
}
@end
