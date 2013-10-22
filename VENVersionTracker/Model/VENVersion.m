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
    if (!payload || ![payload isKindOfClass:[NSDictionary class]] || ![payload objectForKey:@"number"]) {
        NSLog(@"VENVersionTracker :: Attempted to created invalid version");
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.number         = [payload objectForKey:@"number"];
        self.name           = [payload objectForKey:@"name"];
        self.installUrl     = [payload objectForKey:@"install_url"];
        self.mandatory      = [[payload objectForKey:@"mandatory"] isEqualToNumber:[NSNumber numberWithBool:YES]];
        self.description    = @"";
    }
    return self;
}


- (BOOL)install {
    if (self.installUrl) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.installUrl]];
    }
    return NO;
}


- (NSComparisonResult)compare:(VENVersion *)otherVersion {
    return [self.number compare:otherVersion.number options:NSNumericSearch];
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
    VENVersion *version = [[VENVersion alloc] initWithJSONPayload:json];
    
    return version;
}


+ (VENVersion *)currentLocalVersion {
    NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    VENVersion *version = [[VENVersion alloc] init];
    version.number      = versionString;
    version.name        = versionString;
    version.mandatory   = NO;
    
    return version;
}

@end
