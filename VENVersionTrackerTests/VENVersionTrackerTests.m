//
//  VENVersionTrackerTests.m
//  VENVersionTrackerTests
//
//  Created by Chris Maddern on 10/22/13.
//  Copyright (c) 2013 Venmo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VENVersionTracker.h"
#import "VENVersion.h"
#import "VENTestAsyncHelpers.h"

#define VEN_TEST_CHANEL_NAME @"internal"
#define VEN_TEST_BASE_URL @"http://venmo-ios.s3.amazonaws.com/versioning"

@interface VENVersionTrackerTests : XCTestCase

@end

@interface VENVersionTracker (Private)
- (BOOL)startTrackingWithTrackBlock:(VENVersionTrackBlock)trackBlock;
@end

@implementation VENVersionTrackerTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreatingVersionTracker
{
    [VENVersionTracker beginTrackingVersionForChannel:VEN_TEST_CHANEL_NAME
                                       serviceBaseUrl:VEN_TEST_BASE_URL
                                          timeInterval:5
                                          withHandler:^(VENVersionTrackerState state, VENVersion *version) {
        // Do nothing
    }];
    
    VENVersionTracker *versionTracker = [VENVersionTracker tracker];
    
    // Test that the tracker was set up correctly
    XCTAssertNotNil(versionTracker, @"Did not succesfully create version tracker");
    XCTAssertEqualObjects(versionTracker.baseUrl, VEN_TEST_BASE_URL, @"Incorrect Base URL after initiation");
    XCTAssertEqualObjects(versionTracker.channelName, VEN_TEST_CHANEL_NAME, @"Incorrect Base URL after initiation");
    
    // Test that we run the tracking block
    VENStartAsyncBlock();
    [versionTracker startTrackingWithTrackBlock:^{
        VENEndAsyncBlock();
    }];
    VENWaitForAsyncBlock();
    
    [versionTracker stopTracking];
    
    [versionTracker startTracking];
    [versionTracker setCheckInterval:10ull];

    int i = 0;
    while (i < 400) {
        i++;
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.15]];
    }
    i = 0;
    
}


@end
