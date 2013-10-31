//
//  CYCGameClockTests.m
//  HelloWorld
//
//  Created by Craig Young on 2013/10/30.
//  Copyright (c) 2013 Craig Young. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CYCGameClock.h"
#import <sys/time.h>

@interface CYCGameClockTests : XCTestCase

@end

@implementation CYCGameClockTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testNewClock
{
    CYCGameClock *clock = [CYCGameClock new];
    XCTAssertEqual(clock.state, csPaused, @"New clock should be paused");
}

- (void)testSetTime
{
    CYCGameClock *clock = [CYCGameClock new];
    [clock setTime:1:30:0];
    NSTimeInterval expectedTime = (((1 * 60) + 30) * 60) + 0;
    XCTAssertEqual(expectedTime, clock.currentTime, @"Clock set to 90 minutes");
    XCTAssertEqual(1, clock.hour, @"clock.hour");
}

- (void)testGetTimeOfDay
{
    /* Testing high precision timer */
    struct timeval startTime, endTime;
    gettimeofday(&startTime, NULL);
    usleep(1000000);
    gettimeofday(&endTime, NULL);

    double elapsedTime = (endTime.tv_sec - startTime.tv_sec) * 1000;
    elapsedTime += (endTime.tv_usec - startTime.tv_usec) / 1000;

    XCTAssert(elapsedTime >= 1000, @"Sleep 1s means at least 1s should have elapsed");
    XCTAssert(elapsedTime <= 1100, @"Sleep should be close to 1s, giving 100ms leeway");
}

- (void)testTotalSeconds
{
    CYCGameClock *clock = [CYCGameClock new];
    [clock setTime:0:5:0];
    XCTAssertEqual(300, [clock totalSeconds], @"5 minutes is 300 seconds");
}

- (void)testInitWithTimer
{
    CYCTimer *timer = [CYCTimer new];
    CYCGameClock *clock = [CYCGameClock initWithTimer:timer];
    XCTAssertEqual(timer, clock.timer, @"Same timer");
}

@end
