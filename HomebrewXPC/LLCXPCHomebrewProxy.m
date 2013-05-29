//
//  LLCXPCHomebrewProxy.m
//  Homebrew GUI
//
//  Created by Seán Labastille on 12/1/13.
//
//

#import "LLCXPCHomebrewProxy.h"
@interface LLCXPCHomebrewProxy ()
-(void)callBrewWith:(NSArray *)arguments completion:(void (^)(NSString *))output;
@end
@implementation LLCXPCHomebrewProxy
@synthesize applicationProxy;
-(void)installedFormulaList:(void (^)(NSArray *))list {
    [self callBrewWith:@[@"list"] completion:^(NSString *output) {
        NSMutableArray *formulaList = [[output componentsSeparatedByString:@"\n"] mutableCopy];
        [formulaList removeLastObject];
        list(formulaList);
    }];
}
-(void)install:(NSString *)formula completion:(void (^)(NSString *))output {
    [self callBrewWith:@[@"install",formula] completion:output];
}
-(void)uninstall:(NSString *)formula completion:(void (^)(NSString *))output {
    [self callBrewWith:@[@"uninstall",formula] completion:output];
}

-(void)search:(NSString *)term completion:(void (^)(NSString *))output {
    [self callBrewWith:@[@"search",term] completion:output];
}

-(void)callDoctor:(void (^)(NSString *))diagnosis {
    [self callBrewWith:@[@"doctor"] completion:diagnosis];
}

-(void)callBrewWith:(NSArray *)arguments completion:(void (^)(NSString *))output {
    NSMutableDictionary *xpcEnvironment = [[[NSProcessInfo processInfo] environment] mutableCopy];
    NSTask *homebrewTask = [[NSTask alloc] init];
    [homebrewTask setLaunchPath:@"/usr/local/bin/brew"];
    [homebrewTask setArguments:arguments];
    CFDictionaryRef systemProxySettings = CFNetworkCopySystemProxySettings();
    NSDictionary *systemProxySettingsDictionary = CFBridgingRelease(systemProxySettings);
    if ([systemProxySettingsDictionary[(NSString *)kCFNetworkProxiesHTTPEnable] integerValue]) {
        
        //NSLog(@"System HTTP Proxy: http://%@:%@",systemProxySettingsDictionary[(NSString *)kCFNetworkProxiesHTTPProxy],systemProxySettingsDictionary[(NSString *)kCFNetworkProxiesHTTPPort]);
        NSString *httpProxyURL = [NSString stringWithFormat:@"http://%@:%@",systemProxySettingsDictionary[(NSString *)kCFNetworkProxiesHTTPProxy],systemProxySettingsDictionary[(NSString *)kCFNetworkProxiesHTTPPort]];
        //NSLog(@"System HTTPS Proxy: https://%@:%@",systemProxySettingsDictionary[(NSString *)kCFNetworkProxiesHTTPSProxy],systemProxySettingsDictionary[(NSString *)kCFNetworkProxiesHTTPSPort]);
        NSString *httpsProxyURL = [NSString stringWithFormat:@"https://%@:%@",systemProxySettingsDictionary[(NSString *)kCFNetworkProxiesHTTPSProxy],systemProxySettingsDictionary[(NSString *)kCFNetworkProxiesHTTPSPort]];
        [xpcEnvironment addEntriesFromDictionary:@{@"http_proxy":httpProxyURL,@"https_proxy":httpsProxyURL}];
    }
    
    [xpcEnvironment setValue:[NSString stringWithFormat:@"%@:%@",@"/usr/local/bin",xpcEnvironment[@"PATH"]] forKey:@"PATH"];
    [xpcEnvironment setValue:nil forKey:@"DYLD_LIBRARY_PATH"];
    [xpcEnvironment setValue:nil forKey:@"DYLD_FRAMEWORK_PATH"];
    [homebrewTask setEnvironment:xpcEnvironment];
    NSPipe *standardOutputPipe = [[NSPipe alloc] init];
    [homebrewTask setStandardOutput:standardOutputPipe];
    [homebrewTask setStandardError:standardOutputPipe];
    [homebrewTask launch];
    //[homebrewTask waitUntilExit];
    NSString *homebrewOutput = @"";
    [applicationProxy report:
     [NSString stringWithFormat:@"\n Brew called with arguments: %20@ \n",arguments]];
    while ([homebrewTask isRunning]) {
        NSString *availableString = [[NSString alloc] initWithData:[[standardOutputPipe fileHandleForReading] availableData] encoding:NSUTF8StringEncoding];
        [applicationProxy report:availableString];
        homebrewOutput = [homebrewOutput stringByAppendingString:availableString];
    }
    output(homebrewOutput);
}
@end
