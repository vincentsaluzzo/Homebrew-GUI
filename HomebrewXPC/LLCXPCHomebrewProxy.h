//
//  LLCXPCHomebrewProxy.h
//  Homebrew GUI
//
//  Created by Seán Labastille on 12/1/13.
//
//

#import <Foundation/Foundation.h>
#import "LHBXPCApplicationProxy.h"

@protocol LLCXPCHomebrew <NSObject>
-(void)callDoctor:(void (^)(NSString *))diagnosis;
-(void)installedFormulaList:(void (^)(NSArray *))list;
-(void)install:(NSString *)formula completion:(void (^)(NSString *))output;
-(void)uninstall:(NSString *)formula completion:(void (^)(NSString *))output;
-(void)search:(NSString *)term completion:(void (^)(NSString *))output;
-(void)update:(void (^)(NSString *))output;
@end

@interface LLCXPCHomebrewProxy : NSObject <LLCXPCHomebrew>
@property (strong) LHBXPCApplicationProxy *applicationProxy;
@end

