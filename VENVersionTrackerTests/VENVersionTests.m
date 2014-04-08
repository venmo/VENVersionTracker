//
//  VENVersionTests.m
//  VENVersionTracker
//
//  Created by Chris Maddern on 11/3/13.
//  Copyright (c) 2013 Venmo. All rights reserved.
//


                       
                       
#import <XCTest/XCTest.h>
#import "VENTestData.h"
#import "VENVersion.h"

@interface VENVersionTests : XCTestCase

@end


@implementation VENVersionTests


- (void)testVersionCreation {
    VENVersion *version2_0      = [[VENVersion alloc] initWithDictionary:VEN_TEST_VERSION_DICT_2_0];
    VENVersion *version1_1      = [[VENVersion alloc] initWithDictionary:VEN_TEST_VERSION_DICT_1_1];
    VENVersion *version1_2_0_a2 = [[VENVersion alloc] initWithDictionary:VEN_TEST_VERSION_DICT_1_2_a2];
    VENVersion *version1_2_0_b1 = [[VENVersion alloc] initWithDictionary:VEN_TEST_VERSION_DICT_1_2_b1];
    
    VENVersion *version_inv_empty   = [[VENVersion alloc] initWithDictionary:VEN_TEST_VERSION_DICT_INV_EMPTY];
    VENVersion *version_inv_types   = [[VENVersion alloc] initWithDictionary:VEN_TEST_VERSION_DICT_INV_TYPES];
    
    XCTAssertNil(version_inv_empty, @"Created Invalid Version");
    XCTAssertNil(version_inv_types, @"Created Invalid Version");
    
    // Test Version 2
    XCTAssertEqualObjects(version2_0.versionString, VEN_TEST_VERSION_NAME_2_0, @"Incorrect Version Name");
    XCTAssertEqualObjects(version2_0.installUrl, VEN_TEST_INSTALL_URL_2_0, @"Incorrect Install URL");

    XCTAssertEqualObjects(version1_1.versionString, VEN_TEST_VERSION_NAME_1_1, @"Incorrect Version Name");
    XCTAssertEqualObjects(version1_1.installUrl, VEN_TEST_INSTALL_URL_1_1, @"Incorrect Install URL");
    
    XCTAssertEqualObjects(version1_2_0_a2.versionString, VEN_TEST_VERSION_NAME_1_2_a2, @"Incorrect Version Name");
    XCTAssertEqualObjects(version1_2_0_a2.installUrl, VEN_TEST_INSTALL_URL_1_2_a2, @"Incorrect Install URL");
    
    XCTAssertEqualObjects(version1_2_0_b1.versionString, VEN_TEST_VERSION_NAME_1_2_b1, @"Incorrect Version Name");
    XCTAssertEqualObjects(version1_2_0_b1.installUrl, VEN_TEST_INSTALL_URL_1_2_b1, @"Incorrect Install URL");
}

- (void)testVersionComparison {
    VENVersion *version2_0      = [[VENVersion alloc] initWithDictionary:VEN_TEST_VERSION_DICT_2_0];
    VENVersion *version1_1      = [[VENVersion alloc] initWithDictionary:VEN_TEST_VERSION_DICT_1_1];
    VENVersion *version1_0_1    = [[VENVersion alloc] initWithDictionary:VEN_TEST_VERSION_DICT_1_0_1];
    VENVersion *version1_2_0    = [[VENVersion alloc] initWithDictionary:VEN_TEST_VERSION_DICT_1_2];
    VENVersion *version1_2_0_a  = [[VENVersion alloc] initWithDictionary:VEN_TEST_VERSION_DICT_1_2_a];
    VENVersion *version1_2_0_ax = [[VENVersion alloc] initWithDictionary:VEN_TEST_VERSION_DICT_1_2_ax];
    VENVersion *version1_2_0_a2 = [[VENVersion alloc] initWithDictionary:VEN_TEST_VERSION_DICT_1_2_a2];
    VENVersion *version1_2_0_b1 = [[VENVersion alloc] initWithDictionary:VEN_TEST_VERSION_DICT_1_2_b1];
    
    // Check Descending Comparisons
    XCTAssertEqual([version2_0 compare:version1_0_1], NSOrderedDescending, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_1 compare:version1_0_1], NSOrderedDescending, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_2_0_a compare:version1_0_1], NSOrderedDescending, @"Comparison returned unexpected result");
    XCTAssertEqual([version2_0 compare:version1_2_0_a], NSOrderedDescending, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_2_0_a compare:version1_1], NSOrderedDescending, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_2_0_a2 compare:version1_2_0_a], NSOrderedDescending, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_2_0_b1 compare:version1_2_0_a], NSOrderedDescending, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_2_0_b1 compare:version1_2_0_a2], NSOrderedDescending, @"Comparison returned unexpected result");
    XCTAssertEqual([version2_0 compare:version1_2_0_b1], NSOrderedDescending, @"Comparison returned unexpected result");
    XCTAssertEqual([version2_0 compare:version1_2_0_a2], NSOrderedDescending, @"Comparison returned unexpected result");
    
    // Check Ascending Comparisons
    XCTAssertEqual([version1_2_0_a compare:version2_0], NSOrderedAscending, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_1 compare:version2_0], NSOrderedAscending, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_0_1 compare:version2_0], NSOrderedAscending, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_0_1 compare:version1_1], NSOrderedAscending, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_0_1 compare:version1_2_0_a], NSOrderedAscending, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_1 compare:version1_2_0_a], NSOrderedAscending, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_2_0_a compare:version1_2_0_a2], NSOrderedAscending, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_2_0_a compare:version1_2_0_b1], NSOrderedAscending, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_2_0_a2 compare:version1_2_0_b1], NSOrderedAscending, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_2_0_a2 compare:version2_0], NSOrderedAscending, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_2_0_b1 compare:version2_0], NSOrderedAscending, @"Comparison returned unexpected result");
    
    
    // Check Same Values
    XCTAssertEqual([version1_1 compare:version1_1], NSOrderedSame, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_0_1 compare:version1_0_1], NSOrderedSame, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_2_0_a compare:version1_2_0_a], NSOrderedSame, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_2_0_a2 compare:version1_2_0_a2], NSOrderedSame, @"Comparison returned unexpected result");
    XCTAssertEqual([version1_2_0_b1 compare:version1_2_0_b1], NSOrderedSame, @"Comparison returned unexpected result");
    XCTAssertEqual([version2_0 compare:version2_0], NSOrderedSame, @"Comparison returned unexpected result");
    
    // Check release version (no added letters / numbers) are higher than any b / a / rc builds
    XCTAssertEqual([version1_2_0_a compare:version1_2_0], NSOrderedAscending, @"Incorrectly considered development build above production build");
    XCTAssertEqual([version1_2_0_b1 compare:version1_2_0], NSOrderedAscending, @"Incorrectly considered development build above production build");
    XCTAssertEqual([version1_2_0_a2 compare:version1_2_0], NSOrderedAscending, @"Incorrectly considered development build above production build");
    XCTAssertEqual([version1_2_0 compare:version1_2_0_a], NSOrderedDescending, @"Incorrectly considered development build above production build");
    XCTAssertEqual([version1_2_0 compare:version1_2_0_b1], NSOrderedDescending, @"Incorrectly considered development build above production build");
    XCTAssertEqual([version1_2_0 compare:version1_2_0_a2], NSOrderedDescending, @"Incorrectly considered development build above production build");

    // Check 'bucket build' 1.2.0ax is considered higher than 1.2.0a1-9
    XCTAssertEqual([version1_2_0_ax compare:version1_2_0_a2], NSOrderedDescending, @"Incorrectly considered a 'bucket build' higher than a released build");
    XCTAssertEqual([version1_2_0_ax compare:version1_2_0_b1], NSOrderedAscending, @"Incorrectly considered a 'bucket build' higher than a released build");

    
}


@end
