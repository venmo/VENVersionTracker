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

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    @try {
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]] || !dictionary[@"number"]) {
            NSLog(@"VENVersionTracker :: Attempted to created invalid version");
            return nil;
        }
        
        self = [super init];
        if (self) {
            self.versionString      = [NSString stringWithFormat:@"%@", dictionary[@"number"]];
            self.installUrl         = dictionary[@"install_url"];
            self.mandatory          = [dictionary[@"mandatory"] isEqualToNumber:[NSNumber numberWithBool:YES]];
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
    
    // Explicitly handle release builds being higher than development builds of the same version
    NSCharacterSet *splitSet    = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
    NSArray *versionParts       = [self.versionString componentsSeparatedByCharactersInSet:splitSet];
    NSArray *otherVersionParts  = [otherVersion.versionString componentsSeparatedByCharactersInSet:splitSet];
    
    if ([versionParts count] > 1 && [otherVersionParts count] == 1) {
        VENVersion *currentVersionBase      = [[VENVersion alloc] init];
        currentVersionBase.versionString    = [versionParts objectAtIndex:0];
        if ([currentVersionBase compare:otherVersion] == NSOrderedSame) {
            return NSOrderedAscending;
        }
    }
    else if ([otherVersionParts count] > 1 && [versionParts count] == 1) {
        VENVersion *otherVersionBase        = [[VENVersion alloc] init];
        otherVersionBase.versionString      = [otherVersionParts objectAtIndex:0];
        if ([self compare:otherVersionBase] == NSOrderedSame) {
            return NSOrderedDescending;
        }
    }
    
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
    if (json && json[@"version"]) {
        VENVersion *version = [[VENVersion alloc] initWithDictionary:json[@"version"]];
        return version;
    }
    return nil;
}


+ (VENVersion *)currentLocalVersion {
    NSString *versionString = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    
    if (!versionString) { //Not in a bundle -- return 0
        versionString = @"0";
    }
    
    VENVersion *version     = [[VENVersion alloc] init];
    version.versionString   = versionString;
    version.mandatory       = NO;
    
    return version;
}

@end
