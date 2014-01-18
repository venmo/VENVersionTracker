//
//  VENVersionTracker.m
//  VENVersionTracker
//
//  Created by Chris Maddern on 10/22/13.
//  Copyright (c) 2013 Venmo. All rights reserved.
//

#import "VENVersionTracker.h"

#define VEN_DEFAULT_TIME_BETWEEN_CHECKS_SECONDS_DEFAULT 1800ull //1800ull // 30 minutes

static VENVersionTracker *versionTracker = nil;

#pragma mark - Private Interface -
@interface VENVersionTracker(){}

@property (nonatomic) dispatch_source_t timerSource;

- (instancetype)initWithChannel:(NSString *)channel
                 serviceBaseUrl:(NSString *)baseUrl
                   timeInterval:(unsigned long long)timeInterval
                     andHandler:(VENVersionHandlerBlock)handler;

- (BOOL)startTracking;
- (BOOL)stopTracking;

@end

@implementation VENVersionTracker


#pragma mark - Static Tracker Creation -

+ (BOOL)beginTrackingVersionForChannel:(NSString *)channelName
                        serviceBaseUrl:(NSString *)baseUrl
                          timeInterval:(unsigned long long)timeInterval
                            withHandler:(void (^)(VENVersionTrackerState, VENVersion *))handler {
    if (versionTracker) {
        [versionTracker stopTracking];
        versionTracker = nil;
    }
    
    versionTracker = [[VENVersionTracker alloc] initWithChannel:channelName
                                                 serviceBaseUrl:baseUrl
                                                   timeInterval:timeInterval
                                                     andHandler:handler];
    return [versionTracker startTracking];
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
                   timeInterval:(unsigned long long)timeInterval
                     andHandler:(VENVersionHandlerBlock)handler {
    
    self = [super init];
    if (self) {
        self.channelName    = channel;
        self.baseUrl        = baseUrl;
        self.handler        = handler;
        self.checkInterval  = timeInterval;

        if (self.checkInterval == 0) {
            self.checkInterval  = VEN_DEFAULT_TIME_BETWEEN_CHECKS_SECONDS_DEFAULT;
        }

        self.currentState   = VENVersionTrackerStateUnknown;
    }
    return self;
}


#pragma mark - Start and Stopping -

- (void)setCheckInterval:(unsigned long long)checkInterval {
    _checkInterval = checkInterval;
    [self stopTracking];
    [self startTracking];
}


- (BOOL)startTracking {
    return [self startTrackingWithTrackBlock:^{
        [self checkForUpdates];
    }];
}


- (BOOL)startTrackingWithTrackBlock:(VENVersionTrackBlock)trackBlock {
    
    [self stopTracking];
    self.trackBlock = trackBlock;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timerSource, dispatch_walltime(NULL, 0), self.checkInterval * NSEC_PER_SEC, 1ull * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timerSource, self.trackBlock);
    dispatch_resume(self.timerSource);
    return YES;
}


- (BOOL)stopTracking {
    if (self.timerSource) {
        dispatch_source_set_timer(self.timerSource, DISPATCH_TIME_NOW, DISPATCH_TIME_FOREVER, 0ull);
        dispatch_source_cancel(self.timerSource);
        self.timerSource = nil;
    }
    self.trackBlock = nil;
    return YES;
}


#pragma mark - Track a channel -

- (void)checkForUpdates {
    NSLog(@"Checking for Application Updates");
    VENVersion *version         = [VENVersion latestRemoteVersionForChannel:self.channelName withBaseUrl:self.baseUrl];
    VENVersion *localVersion    = [VENVersion currentLocalVersion];
    
    if (version && [version compare:localVersion] == NSOrderedDescending) {
        
        // Outdated
        if (self.currentState == VENVersionTrackerStateOutdated) {
            // Already knew
        }
        else {
            if (version.mandatory) {
                self.currentState = VENVersionTrackerStateDeprecated;
            }
            else {
                self.currentState = VENVersionTrackerStateOutdated;
            }
            
            self.handler(VENVersionTrackerStateOutdated, version);
        }
    }
    else {
        self.currentState = VENVersionTrackerStateOK;
    }
}

@end
