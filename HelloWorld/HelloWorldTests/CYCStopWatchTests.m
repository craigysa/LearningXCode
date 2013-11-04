//
//  CYCStopWatchTests.m
//  HelloWorld
//
//  Created by Craig Young on 2013/11/04.
//  Copyright (c) 2013 Craig Young. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CYCStopWatch.h"


/*
 struct timeval startTime, endTime;
 gettimeofday(&startTime, NULL);
 usleep(1 * 1000 * 1000);
 gettimeofday(&endTime, NULL);

 double elapsedTime = (endTime.tv_sec - startTime.tv_sec) * 1000;
 elapsedTime += (endTime.tv_usec - startTime.tv_usec) / 1000;
 */

@interface CYCStopWatchTests : XCTestCase
@end

@implementation CYCStopWatchTests {
    id <CYCStopWatch> _stopWatch;
}

/* Override this factory method to run the same suite of tests against a different implementation of the CYCStopWatch protocol. */
- (id <CYCStopWatch>)createStopWatchToTest {
    return [[CYCStopWatch alloc] init];
}

- (void)testNewStopWatch {
    id <CYCStopWatch> stopWatch = [self createStopWatchToTest];
    XCTAssertFalse([stopWatch running], @"New Stop Watch should not be running");
    XCTAssertEqual(0.0, [stopWatch elapsedTime], @"New stop watch should have zero time elapsed");
}

- (void)testStart {
    [_stopWatch start];
    XCTAssertTrue(_stopWatch.running, @"start should set isRunning == YES");
}

- (void)testStop {
    [_stopWatch stop];
    XCTAssertFalse(_stopWatch.running, @"stop should set isRunning == NO");
}

- (void)testElapsedTimeAfter100ms {
    [_stopWatch start];
    usleep(100 * 1000);
    [_stopWatch start];

    NSTimeInterval actualElapsedTime = [_stopWatch elapsedTime];

    //TODO...
    //XCTAssert(actualElapsedTime >= 0.1, @"Elapsed Time must be a minimum of 100ms");
    //XCTAssert(actualElapsedTime < 0.12, @"Elapsed Time may be a little more than 100ms due to nature of usleep function");
}

- (void)setUp {
    [super setUp];
    _stopWatch = [self createStopWatchToTest];
}

- (void)tearDown {
    _stopWatch = nil;
    [super tearDown];
}

@end
