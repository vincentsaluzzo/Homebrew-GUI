//
//  LHBModel.m
//  Homebrew GUI
//
//  Created by Seán Labastille on 13/1/13.
//  Copyright (c) 2013 Labastille Laser Corp. All rights reserved.
//

#import "LHBModel.h"

@implementation LHBModel
+(id)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}
@end
