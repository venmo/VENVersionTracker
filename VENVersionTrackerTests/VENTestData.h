#define VEN_TEST_INSTALL_URL_1_1     @"http://install_url_1_1"
#define VEN_TEST_INSTALL_URL_1_2_a   @"http://install_url_1_2_a"
#define VEN_TEST_INSTALL_URL_1_2_a2  @"http://install_url_1_2_a2"
#define VEN_TEST_INSTALL_URL_1_2_b1  @"http://install_url_1_2_b1"
#define VEN_TEST_INSTALL_URL_1_0_1   @"http://install_url_1_0_1"
#define VEN_TEST_INSTALL_URL_2_0     @"http://install_url_2_0"

#define VEN_TEST_VERSION_NAME_1_1       @"1.1.0"
#define VEN_TEST_VERSION_NAME_1_2_a     @"1.2.0a1"
#define VEN_TEST_VERSION_NAME_1_2_a2    @"1.2.0a2"
#define VEN_TEST_VERSION_NAME_1_2_b1    @"1.2.0b1"
#define VEN_TEST_VERSION_NAME_1_0_1     @"1.0.1"
#define VEN_TEST_VERSION_NAME_2_0       @"2.0.0"

#define VEN_TEST_VERSION_DICT_1_1       @{@"number": VEN_TEST_VERSION_NAME_1_1, @"install_url": VEN_TEST_INSTALL_URL_1_1, @"mandatory": @(NO)}
#define VEN_TEST_VERSION_DICT_1_2_a     @{@"number": VEN_TEST_VERSION_NAME_1_2_a, @"install_url": VEN_TEST_INSTALL_URL_1_2_a, @"mandatory": @(NO)}
#define VEN_TEST_VERSION_DICT_1_2_a2    @{@"number": VEN_TEST_VERSION_NAME_1_2_a2, @"install_url": VEN_TEST_INSTALL_URL_1_2_a2, @"mandatory": @(NO)}
#define VEN_TEST_VERSION_DICT_1_2_b1    @{@"number": VEN_TEST_VERSION_NAME_1_2_b1, @"install_url": VEN_TEST_INSTALL_URL_1_2_b1, @"mandatory": @(NO)}
#define VEN_TEST_VERSION_DICT_1_0_1     @{@"number": VEN_TEST_VERSION_NAME_1_0_1, @"install_url": VEN_TEST_INSTALL_URL_1_0_1, @"mandatory": @(NO)}
#define VEN_TEST_VERSION_DICT_2_0       @{@"number": VEN_TEST_VERSION_NAME_2_0, @"install_url": VEN_TEST_INSTALL_URL_2_0, @"mandatory": @(NO)}

#define VEN_TEST_VERSION_DICT_INV_EMPTY @{}
#define VEN_TEST_VERSION_DICT_INV_TYPES @{@"number": @(YES), @"install_url": @(NO), @"mandatory": @"STRING"}