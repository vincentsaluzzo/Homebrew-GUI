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
    //NSLog(@"Output from XPC: %@", output);
    NSAttributedString *outputString = [[NSAttributedString alloc] initWithString:output];
    [[[self homebrewOutputTextView] textStorage] performSelectorOnMainThread:@selector(appendAttributedString:) withObject:outputString waitUntilDone:YES];
}
@end
