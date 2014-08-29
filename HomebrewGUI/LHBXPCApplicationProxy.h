//
//  LHBXPCApplicationProxy.h
//  Homebrew GUI
//
//  Created by Seán Labastille on 13/1/13.
//  Copyright (c) 2013 Labastille Laser Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@protocol LHBXPCApplication
-(void)report:(NSString *)output;
@end
@interface LHBXPCApplicationProxy : NSObject <LHBXPCApplication>
@property (strong) NSTextView *homebrewOutputTextView;
@property (weak) NSTextField * homebrewStatusTextField;
@end
