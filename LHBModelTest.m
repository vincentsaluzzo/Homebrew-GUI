//
//  LHBModelTest.m
//  Brewery
//
//  Created by Seán Labastille on 18/1/13.
//  Copyright (c) 2013 Labastille Laser Corp. All rights reserved.
//

#import "LHBModelTest.h"

@implementation LHBModelTest
@synthesize testModel;

-(void)setUp {
    testModel = [[LHBModel alloc] init];
}

-(void)testModelEmptyBeforeFetchingInstalledFormulas {
    STAssertNil([testModel installedFormulas], @"No  installed formulas should be listed by the model when initialized");
}
@end
