//
//  VENVersionTracker.m
//  VENVersionTracker
//
//  Created by Chris Maddern on 10/22/13.
//  Copyright (c) 2013 Venmo. All rights reserved.
//

#import "VENVersionTracker.h"

#define VEN_DEFAULT_TIME_BETWEEN_CHECKS_SECONDS 300

static VENVersionTracker *versionTracker = nil;

#pragma mark - Private Interface -
@interface VENVersionTracker(){}

- (instancetype)initWithChannel:(NSString *)channel
                 serviceBaseUrl:(NSString *)baseUrl
                     andHandler:(VENVersionHandlerBlock)handler;

- (BOOL)startTracking;
- (BOOL)stopTracking;

@end

@implementation VENVersionTracker


#pragma mark - Static Tracker Creation -

+ (BOOL)beginTrackingVersionForChannel:(NSString *)channelName
                        serviceBaseUrl:(NSString *)baseUrl
                            withHandler:(void (^)(VENVersionTrackerState, VENVersion *))handler {
    if (versionTracker) {
        [versionTracker stopTracking];
        versionTracker = nil;
    }
    
    versionTracker = [[VENVersionTracker alloc] initWithChannel:channelName
                                                 serviceBaseUrl:baseUrl
                                                     andHandler:handler];
    return YES;
}


+ (VENVersionTracker *)tracker {
    return versionTracker;
}


#pragma mark - Instance Lifecycle Methods -

- (instancetype)init {
    // Don't allow outside creation of our tracker
    return nil;
}


- (instancetype)initWithChannel:(NSString *)channel
                 serviceBaseUrl:(NSString *)baseUrl
                     andHandler:(VENVersionHandlerBlock)handler {
    
    self = [super init];
    if (self) {
        self.channelName    = channel;
        self.baseUrl        = baseUrl;
        self.handler        = handler;
        
        self.currentState   = VENVersionTrackerStateUnknown;
    }
    return self;
}


- (void)dealloc {
    
}

#pragma mark - Start and Stopping -

- (BOOL)startTracking {
    
    return YES;
}


- (BOOL)stopTracking {
    
    return YES;
}


#pragma mark - Track a channel -

- (void)track {
    
    VENVersion *version     = [VENVersion latestRemoteVersionForChannel:self.channelName withBaseUrl:self.baseUrl];
    VENVersion *localVersion = [VENVersion currentLocalVersion];
    
    if (version && [version compare:localVersion] == NSOrderedAscending) {
        
        // Outdated
        if (self.currentState == VENVersionTrackerStateOutdated) {
            // Already knew
        }
        else {
            self.currentState = VENVersionTrackerStateOutdated;
            self.handler(VENVersionTrackerStateOutdated, version);
        }
    }
    else {
        self.currentState = VENVersionTrackerStateOK;
    }
}

@end
