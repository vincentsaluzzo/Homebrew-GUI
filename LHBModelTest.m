//
//  LHBModelTest.m
//  Brewery
//
//  Created by Seán Labastille on 18/1/13.
//  Copyright (c) 2013 Labastille Laser Corp. All rights reserved.
//

#import "LHBModel.h"
#import "Kiwi.h"

SPEC_BEGIN(LHBModelSpec)

describe(@"Model", ^{
    it(@"should be empty before fetching installed formulas", ^{
        [[[LHBModel sharedInstance] installedFormulas] shouldBeNil];
    });
    it(@"should have its installedFormulas set eventually", ^{
        [[[LHBModel sharedInstance] shouldEventually] receive:@selector(setInstalledFormulas:)];
    });
});

SPEC_END
