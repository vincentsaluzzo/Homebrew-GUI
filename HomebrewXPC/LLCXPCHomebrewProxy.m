//
//  LLCXPCHomebrewProxy.m
//  Homebrew GUI
//
//  Created by Seán Labastille on 12/1/13.
//
//

#import "LLCXPCHomebrewProxy.h"

@implementation LLCXPCHomebrewProxy
@synthesize applicationProxy;
-(void)installedFormulaList:(void (^)(NSArray *))list {
    NSMutableArray *formulaList = [[[self callBrewWith:@[@"list"]] componentsSeparatedByString:@"\n"] mutableCopy];
    [formulaList removeLastObject];
    list(formulaList);
}
-(void)install:(NSString *)formula completion:(void (^)(NSString *))output {
    output([self callBrewWith:@[@"install",formula]]);
}
-(void)uninstall:(NSString *)formula completion:(void (^)(NSString *))output {
    output([self callBrewWith:@[@"uninstall",formula]]);
}

-(void)search:(NSString *)term completion:(void (^)(NSString *))output {
    output([self callBrewWith:@[@"search",term]]);
}

-(NSString *)callBrewWith:(NSArray *)arguments {
    
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
    
    [xpcEnvironment setValue:[NSString stringWithFormat:@"%@:%@",xpcEnvironment[@"PATH"],@"/usr/local/bin"] forKey:@"PATH"];
    [homebrewTask setEnvironment:xpcEnvironment];
    NSPipe *standardOutputPipe = [[NSPipe alloc] init];
    [homebrewTask setStandardOutput:standardOutputPipe];
    [homebrewTask launch];
    //[homebrewTask waitUntilExit];
    NSString *homebrewOutput = @"";
    while ([homebrewTask isRunning]) {
        NSString *availableString = [[NSString alloc] initWithData:[[standardOutputPipe fileHandleForReading] availableData] encoding:NSUTF8StringEncoding];
        [applicationProxy report:availableString];
        homebrewOutput = [homebrewOutput stringByAppendingString:availableString];
    }
    return homebrewOutput;
}
@end
