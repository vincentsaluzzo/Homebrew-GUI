//
//  LHBModelTest.m
//  Brewery
//
//  Created by Seán Labastille on 18/1/13.
//  Copyright (c) 2013 Labastille Laser Corp. All rights reserved.
//

#import "LHBModel.h"
#import "LHBInstalledViewController.h"
#import "Kiwi.h"

SPEC_BEGIN(LHBModelSpec)

describe(@"Model", ^{
    it(@"should be nil before fetching installed formulas", ^{
        [[[LHBModel sharedInstance] installedFormulas] shouldBeNil];
    });
    it(@"should not be nil after fetching installed formulas", ^{
        id installedViewControllerMock = [LHBInstalledViewController new];
        [installedViewControllerMock refreshInstalledFormulas:nil];
        [[[expectFutureValue([[LHBModel sharedInstance] installedFormulas]) shouldEventuallyBeforeTimingOutAfter(5.0)] haveAtLeast:1] items];
        //NSLog(@"Installed formulas: %@", [[LHBModel sharedInstance] installedFormulas]);
    });
});

SPEC_END
