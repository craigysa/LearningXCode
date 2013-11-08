//
//  CYCGameClockTests.m
//  HelloWorld
//
//  Created by Craig Young on 2013/10/30.
//  Copyright (c) 2013 Craig Young. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CYCGameClock.h"
#import "CYCStopWatch.h"
#import <sys/time.h>

@interface CYCGameClock (Test)
@property (readwrite, nonatomic) id <CYCStopWatch> stopWatch;
@end

@interface CYCMockStopWatch : NSObject <CYCStopWatch>
/* @protocol CYCStopWatch */
@property (readwrite, nonatomic) BOOL running;
@property (readwrite, nonatomic) NSTimeInterval elapsedTime;

/* Additional interfaces */
@property (nonatomic) BOOL started;

@end

@implementation CYCMockStopWatch
- (void)start; {
    self.running = YES;
}

- (void)stop; {
    self.running = NO;
}

- (void)reset; {
    self.running = NO;
}

@end

@interface CYCGameClockTests : XCTestCase
@end

@implementation CYCGameClockTests {
    CYCMockStopWatch *_mockStopWatch;
    CYCGameClock *_clock;
}

- (void)testNewClock {
    XCTAssertEqual(_clock.state, csPaused, @"New clock should be paused");
}

- (void)testSetTime {
    [_clock setTime:1:30:0];
    NSTimeInterval expectedTime = (1 * 60 * 60) + (30 * 60) + 0;
    XCTAssertEqual(_clock.currentTime, expectedTime, @"Clock set to 90 minutes");
    XCTAssertEqual(_clock.hour, 1, @"_clock.hour");
    XCTAssertEqual(_clock.minute, 30, @"_clock.minute");
    XCTAssertEqual(_clock.second, 0, @"_clock.second");
    XCTAssertEqual(_clock.millisecond, 0, @"_clock.millisecond");
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

- (void)testInitWithStopWatch {
    id <CYCStopWatch> stopWatch = [[CYCStopWatch alloc] init];
    CYCGameClock *clock = [CYCGameClock gameClockWithStopWatch:stopWatch];
    XCTAssertEqual(stopWatch, clock.stopWatch, @"Same StopWatch");
}

- (void)testDefaultStopWatchAssigned {
    CYCGameClock *clock = [[CYCGameClock alloc] init];
    XCTAssertNotNil(clock.stopWatch,
            @"A default StopWatch should be assigned for clocks created without a StopWatch");
}

- (void)testStartClock {
    [_clock setTime:1:30:00];
    [_clock startMove];
    XCTAssertEqual(_clock.state, csRunning, @"Clock should be running");
}

- (void)testOverrideExistingStopWatch {
    /* This is probably an undesirable usage scenario in normal code. However it is desirable to 
        ensure this works in test code so that we can mock specific behaviour from the stop watch 
        for soem tests. */
    id <CYCStopWatch> stopWatch = [[CYCMockStopWatch alloc] init];
    [_clock setStopWatch:stopWatch];
    XCTAssertEqual(stopWatch, _clock.stopWatch, @"Same StopWatch");
}

- (void)testStopWatchStartCalled {
    [_clock startMove];
    XCTAssertTrue(_mockStopWatch.running, @"Clock should start StopWatch");
}

- (void)testTestRunningClockReducesTime {
    [_clock setTime:1:30:00];
    [_clock startMove];
    _mockStopWatch.elapsedTime = 0.150200; /* 150 msec, 200 usec*/

    NSTimeInterval expectedTime = 5399.8498; /* (1 * 3600) + (30 * 60) + 0 - 0.150200 */

    XCTAssertEqual(_clock.currentTime, expectedTime,
            @"Current time should be reduced by stop watch");
    XCTAssertEqual(_clock.hour, 1, @"_clock.hour");
    XCTAssertEqual(_clock.minute, 29, @"_clock.minute");
    XCTAssertEqual(_clock.second, 59, @"_clock.second");
    XCTAssertEqual(_clock.millisecond, 849, @"_clock.millisecond");
}

- (void)testStopMove {
    [_clock startMove];
    [_clock endMove];

    XCTAssertEqual(_clock.state, csPaused, @"_clock.state");
    XCTAssertFalse(_mockStopWatch.running, @"Clock should pause StopWatch");
    XCTAssertEqual(_clock.moveCount, 1, @"_clock.moveCount");
}

- (void)setUp {
    [super setUp];
    _mockStopWatch = [[CYCMockStopWatch alloc] init];
    _clock = [CYCGameClock gameClockWithStopWatch:_mockStopWatch];
}

- (void)tearDown {
    _clock = nil;
    [super tearDown];
}

@end
