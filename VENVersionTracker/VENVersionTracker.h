//
//  VENVersionTracker.h
//  VENVersionTracker
//
//  Created by Chris Maddern on 10/22/13.
//  Copyright (c) 2013 Venmo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VENVersion.h"

typedef enum {
    VENVersionTrackerStateUnknown,
    VENVersionTrackerStateOK,
    VENVersionTrackerStateOutdated,
    VENVersionTrackerStateDeprecated
    
} VENVersionTrackerState;

typedef void (^VENVersionHandlerBlock)(VENVersionTrackerState, VENVersion *);

@interface VENVersionTracker : NSObject

@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, copy) VENVersionHandlerBlock handler;
@property (nonatomic) VENVersionTrackerState currentState;

+ (BOOL)beginTrackingVersionForChannel:(NSString *)channel
                        serviceBaseUrl:(NSString *)baseUrl
                           withHandler:(void (^)(VENVersionTrackerState, VENVersion *))handler;

@end
