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
typedef void (^VENVersionTrackBlock)();

@interface VENVersionTracker : NSObject

@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic) unsigned long long checkInterval;

@property (nonatomic, copy) VENVersionTrackBlock trackBlock;
@property (nonatomic, copy) VENVersionHandlerBlock handler;
@property (nonatomic) VENVersionTrackerState currentState;

+ (BOOL)beginTrackingVersionForChannel:(NSString *)channelName
                        serviceBaseUrl:(NSString *)baseUrl
                          timeInterval:(unsigned long long)timeInterval
                           withHandler:(void (^)(VENVersionTrackerState, VENVersion *))handler;

+ (VENVersionTracker *)tracker;

- (BOOL)startTracking;
- (BOOL)stopTracking;
@end
