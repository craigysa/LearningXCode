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

@interface CYCGameClock (Test)
@property (readwrite, nonatomic) CYCStopWatch *stopWatch;
@end

@interface CYCGameClockTests : XCTestCase
@end

@implementation CYCGameClockTests {
    CYCGameClock *_clock;
}

- (void)setUp {
    [super setUp];
    _clock = [[CYCGameClock alloc] init];
}

- (void)tearDown {
    _clock = nil;
    [super tearDown];
}

- (void)testNewClock {
    XCTAssertEqual(_clock.state, csPaused, @"New clock should be paused");
}

- (void)testSetTime {
    [_clock setTime:1:30:0];
    NSTimeInterval expectedTime = (1 * 60 * 60) + (30 * 60) + 0;
    XCTAssertEqual(expectedTime, _clock.currentTime, @"Clock set to 90 minutes");
    XCTAssertEqual(1, _clock.hour, @"_clock.hour");
}

- (void)testGetTimeOfDay {
    /* Testing high precision timer */
    struct timeval startTime, endTime;
    gettimeofday(&startTime, NULL);
    usleep(1 * 1000 * 1000);
    gettimeofday(&endTime, NULL);

    double elapsedTime = (endTime.tv_sec - startTime.tv_sec) * 1000;
    elapsedTime += (endTime.tv_usec - startTime.tv_usec) / 1000;

    XCTAssert(elapsedTime >= 1000, @"Sleep 1s means at least 1s should have elapsed");
    XCTAssert(elapsedTime <= 1100, @"Sleep should be close to 1s, giving 100ms leeway");
}

- (void)testTotalSeconds {
    [_clock setTime:00:05:00];
    XCTAssertEqual(300, [_clock totalSeconds], @"5 minutes is 300 seconds");
}

- (void)testInitWithStopWatch {
    CYCStopWatch *stopWatch = [[CYCStopWatch alloc] init];
    CYCGameClock *clock = [CYCGameClock gameClockWithStopWatch:stopWatch];
    XCTAssertEqual(stopWatch, clock.stopWatch, @"Same StopWatch");
}

- (void)testDefaultStopWatchAssigned {
    CYCGameClock *clock = [[CYCGameClock alloc] init];
    XCTAssertNotNil(clock.stopWatch, @"A default StopWatch should be assigned for clocks created without a StopWatch");
}

- (void)testStartClock {
    [_clock setTime:1:30:0];
    [_clock start];
    XCTAssertEqual(_clock.state, csRunning, @"Clock should be running");
}

- (void)testInjectStopWatch {
    CYCStopWatch *stopWatch = [[CYCStopWatch alloc] init];
    [_clock setStopWatch:stopWatch];
    XCTAssertEqual(stopWatch, _clock.stopWatch, @"Same StopWatch");
}


@end
