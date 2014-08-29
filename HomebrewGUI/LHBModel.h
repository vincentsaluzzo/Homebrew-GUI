//
//  LHBModel.h
//  Homebrew GUI
//
//  Created by Seán Labastille on 13/1/13.
//  Copyright (c) 2013 Labastille Laser Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHBModel : NSObject
@property (strong) NSArray *installedFormulas;
+(id)sharedInstance;
@end
