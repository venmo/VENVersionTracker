//
//  VENVersion.h
//  VENVersionTracker
//
//  Created by Chris Maddern on 10/22/13.
//  Copyright (c) 2013 Venmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VENVersion : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *installUrl;
@property (nonatomic) BOOL mandatory;


// Configures a VENVersion with the contents of a version payload
// returns nil if there is an error
- (instancetype)initWithJSONPayload:(NSDictionary *)payload;


// Compare one version to another
- (NSComparisonResult)compare:(VENVersion *)otherVersion;


// Install the application version using the itms service url
- (BOOL)install;


+ (VENVersion *)latestRemoteVersionForChannel:(NSString *)channel withBaseUrl:(NSString *)baseUrl;

+ (VENVersion *)currentLocalVersion;

@end
