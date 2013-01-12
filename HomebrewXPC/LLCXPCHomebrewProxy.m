//
//  LLCXPCHomebrewProxy.m
//  Homebrew GUI
//
//  Created by Seán Labastille on 12/1/13.
//
//

#import "LLCXPCHomebrewProxy.h"

@implementation LLCXPCHomebrewProxy
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
    NSTask *homebrewTask = [[NSTask alloc] init];
    [homebrewTask setLaunchPath:@"/usr/local/bin/brew"];
    [homebrewTask setArguments:arguments];
    NSLog(@"Homebrew Task Environment: %@",[homebrewTask environment]);
    CFDictionaryRef systemProxySettings = CFNetworkCopySystemProxySettings();
    NSDictionary *systemProxySettingsDictionary = CFBridgingRelease(systemProxySettings);
    /*if ([systemProxySettingsDictionary[(NSString *)kCFNetworkProxiesHTTPEnable] integerValue]) {
        
        NSLog(@"System HTTP Proxy: http://%@:%@",systemProxySettingsDictionary[(NSString *)kCFNetworkProxiesHTTPProxy],systemProxySettingsDictionary[(NSString *)kCFNetworkProxiesHTTPPort]);
        NSString *httpProxyURL = [NSString stringWithFormat:@"http://%@:%@",systemProxySettingsDictionary[(NSString *)kCFNetworkProxiesHTTPProxy],systemProxySettingsDictionary[(NSString *)kCFNetworkProxiesHTTPPort]];
        NSLog(@"System HTTPS Proxy: https://%@:%@",systemProxySettingsDictionary[(NSString *)kCFNetworkProxiesHTTPSProxy],systemProxySettingsDictionary[(NSString *)kCFNetworkProxiesHTTPSPort]);
        NSString *httpsProxyURL = [NSString stringWithFormat:@"https://%@:%@",systemProxySettingsDictionary[(NSString *)kCFNetworkProxiesHTTPSProxy],systemProxySettingsDictionary[(NSString *)kCFNetworkProxiesHTTPSPort]];
        [homebrewTask setEnvironment:@{@"http_proxy":httpProxyURL,@"https_proxy":httpsProxyURL}];
    }*/
    NSLog(@"Homebrew Task Environment: %@",[homebrewTask environment]);
    NSPipe *standardOutputPipe = [[NSPipe alloc] init];
    [homebrewTask setStandardOutput:standardOutputPipe];
    [homebrewTask launch];
    [homebrewTask waitUntilExit];
    return [[NSString alloc] initWithData:[[standardOutputPipe fileHandleForReading] readDataToEndOfFile] encoding:NSUTF8StringEncoding];
}
@end
