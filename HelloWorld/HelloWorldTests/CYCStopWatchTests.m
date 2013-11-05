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
    [_stopWatch stop];

    NSTimeInterval actualElapsedTime = [_stopWatch elapsedTime];

    XCTAssertEqualWithAccuracy(actualElapsedTime, 0.11, 0.01, @"Elapsed Time must be a minimum of 100ms (0.11-0.01) and should only be a little more");
}

- (void)testElapsedTimeWhileRunning {
    /* This effectively tests the stop watch's ability to be a cumulative "lap timer" */
    [_stopWatch start];
    usleep(100 * 1000);
    NSTimeInterval oneLapElapsedTime = [_stopWatch elapsedTime];
    usleep(100 * 1000);
    NSTimeInterval twoLapsElapsedTime = [_stopWatch elapsedTime];

    XCTAssertEqualWithAccuracy(oneLapElapsedTime, 0.11, 0.01, @"One lap time must be a minimum of 100ms (0.11-0.01) and should only be a little more");
    XCTAssertEqualWithAccuracy(twoLapsElapsedTime, 0.21, 0.01, @"Two laps time must be a minimum of 200ms (0.21-0.01) and should only be a little more");
}

- (void)testElapsedTimeOverTwoIntervals {
    [_stopWatch start];
    usleep(100 * 1000);
    [_stopWatch stop];
    usleep(50 * 1000);
    [_stopWatch start];
    usleep(100 * 1000);
    [_stopWatch stop];

    NSTimeInterval totalElapsedTime = [_stopWatch elapsedTime];

    XCTAssertEqualWithAccuracy(totalElapsedTime, 0.21, 0.01, @"Elapsed Time must be a minimum of 200ms (0.21-0.01) and should only be a little more");
}

- (void)testStartIsIdempotent {
    /* If the stop watch is already running, the start method should have no effect (i.e. it should not restart the timer). */
    [_stopWatch start];
    usleep(100 * 1000);
    [_stopWatch start];
    usleep(100 * 1000);
    [_stopWatch stop];

    NSTimeInterval totalElapsedTime = [_stopWatch elapsedTime];

    XCTAssertEqualWithAccuracy(totalElapsedTime, 0.21, 0.01, @"Elapsed Time must be a minimum of 200ms (0.21-0.01) and should only be a little more");
}

- (void)testStopIsIdempotent {
    /* If the stop watch is not running, then the stop method should have no effect (i.e. it not add more accumulated time). */
    [_stopWatch start];
    usleep(100 * 1000);
    [_stopWatch stop];
    usleep(100 * 1000);
    [_stopWatch stop];

    NSTimeInterval totalElapsedTime = [_stopWatch elapsedTime];

    XCTAssertEqualWithAccuracy(totalElapsedTime, 0.11, 0.01, @"Elapsed Time must be a minimum of 100ms (0.11-0.01) and should only be a little more");
}

-(void)testDateComponentsFromTimeInterval {
    NSDate *aDate = [NSDate dateWithTimeIntervalSince1970:100.9];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSCalendarUnit u = NSCalendarUnitSecond | NSCalendarUnitMinute;
    NSDateComponents *dc = [cal components:u fromDate:[NSDate dateWithTimeIntervalSince1970:0] toDate:aDate options:0];
    XCTAssertEqual(dc.minute, 1, @"Minutes extracting both minutes and seconds");
    XCTAssertEqual(dc.second, 40, @"Seconds extracting both minutes and seconds");

    u = NSCalendarUnitSecond;
    dc = [cal components:u fromDate:[NSDate dateWithTimeIntervalSince1970:0] toDate:aDate options:0];
    XCTAssertEqual(dc.minute, NSDateComponentUndefined, @"Minutes extracting only seconds");
    XCTAssertEqual(dc.second, 100, @"Seconds extracting only seconds");
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
