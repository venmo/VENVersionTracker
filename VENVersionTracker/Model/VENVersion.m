//
//  VENVersion.m
//  VENVersionTracker
//
//  Created by Chris Maddern on 10/22/13.
//  Copyright (c) 2013 Venmo. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "VENVersion.h"

@implementation VENVersion

- (instancetype)initWithJSONPayload:(NSDictionary *)payload {
    
    @try {
        if (!payload || ![payload isKindOfClass:[NSDictionary class]] || ![payload objectForKey:@"number"]) {
            NSLog(@"VENVersionTracker :: Attempted to created invalid version");
            return nil;
        }
        
        self = [super init];
        if (self) {
            self.versionString      = [NSString stringWithFormat:@"%@", [payload objectForKey:@"number"]];
            self.installUrl         = [payload objectForKey:@"install_url"];
            self.mandatory          = [[payload objectForKey:@"mandatory"] isEqualToNumber:[NSNumber numberWithBool:YES]];
            self.descriptionText    = @"";
        }
        return self;
    }
    @catch (NSException *exception) {
        return nil;
    }
}


- (BOOL)install {
    if (self.installUrl) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.installUrl]];
    }
    return NO;
}


- (NSComparisonResult)compare:(VENVersion *)otherVersion {
    return [self.versionString compare:otherVersion.versionString options:NSNumericSearch];
}


+ (VENVersion *)latestRemoteVersionForChannel:(NSString *)channel withBaseUrl:(NSString *)baseUrl {
    if (!channel || !baseUrl) {
        return nil;
    }
    
    NSString *versionUrl        = [NSString stringWithFormat:@"%@/track/%@", baseUrl, channel];
    NSURL *url                  = [NSURL URLWithString:versionUrl];
    NSURLRequest *urlRequest    = [NSURLRequest requestWithURL:url];
    NSURLResponse *response     = nil;
    NSError *err                = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
                                             returningResponse:&response
                                                         error:&err];
    if (err || ((NSHTTPURLResponse *)response).statusCode != 200 || !data) {
        return nil;
    }
    
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&err];
    if (json && [json objectForKey:@"version"]) {
        VENVersion *version = [[VENVersion alloc] initWithJSONPayload:[json objectForKey:@"version"]];
        return version;
    }
    return nil;
}


+ (VENVersion *)currentLocalVersion {
    NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    if (!versionString) { //Not in a bundle -- return 0
        versionString = @"0";
    }
    
    VENVersion *version     = [[VENVersion alloc] init];
    version.versionString   = versionString;
    version.mandatory       = NO;
    
    return version;
}

@end
